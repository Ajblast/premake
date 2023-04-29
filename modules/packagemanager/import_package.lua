include "filter.lua"
include "http_utils.lua"
include "package_base.lua"
include "utils.lua"
include "variant.lua"

local p = premake
local packagemanager = p.modules.packagemanager

-- Inherit from the base package
import_package = {}

-- Is a folder path a package
-- Packages are defined as having a meta file
local function __isPackage(folder)
    local filename = path.join(folder, 'premake5-meta.lua')
    return os.isfile(filename)
end

-- Get a package location
local function __getPackageLocation(...)
    local location = path.join(...)
    location = path.normalize(location)
    location = location:gsub('%s+', '_') -- Replace spaces with underscores
    location = location:gsub('%(', '_')
    location = location:gsub('%)', '_')
    return location
end

-- Get the folder location of a package
local function __getPackageFolder(info)
    -- Check if the package id is a local folder
    if os.isdir(info.id) then
        if __isPackage(info.id) then
            local location = path.getabsolute(info.id)
            verbosef(' LOCAL: %s', location)
            return location
        end
    end

    -- Check if the package is in a local folder
    for _, folder in ipairs(packagemanager.folders) do
        local location = __getPackageLocation(folder, info.name, info.id)

        -- The folder is the correct package if it is a package
        if __isPackage(location) then
            location = path.getabsolute(location)
            verbosef(' - LOCAL: %s', location)
            return location
        end
    end

    -- Get the location of the package in the package cache
    return __getPackageLocation(p.packagemanager.getCacheLocation(), info.name, info.id)
end

local function __downloadPackage(info, location)
    -- Check if the package has already been downloaded
    -- This does not let us know if a branch has been updated
    -- But this works for now
    -- TODO: Check if a branch is updated, or just flat out redownload branches every time
    if __isPackage(location) then
        location = path.getabsolute(location)
        verbosef(' - CACHED: %s', location)
        return
    end

    -- The package wasn't found, so download it from online
    local link_url
    if info.branch ~= nil then
        link_url = makeBranchGitHubURL(info.org, info.repo, info.id)
    elseif info.version ~= nil then
        link_url = makeReleaseGitHubURL(info.org, info.repo, info.id)
    end

    -- Create the destination folder
    if os.mkdir(location) == nil then
        p.error("Unable to create package directory")
    end
    
    -- Download to packagecache/name-id.zip.
    local download_destination = __getPackageLocation(location, info.name .. '-' .. info.id .. '.zip')
    http_download(link_url, download_destination, info.auth, "package:__downloadPackage")

    -- Unzip it
    verbosef(' - UNZIP   : %s', download_destination)
    zip.extract(download_destination, location)
    os.remove(download_destination)

    -- Get rid of the stupid extra folder that GitHub adds
    local cruft = os.matchdirs(path.join(location, info.repo .. '-*'))
    local cruft_path = cruft[1]

    -- What we want to do is rename cruft_path to location
    -- Because it's inside of location we need to move it out of location
    -- Remove the old location
    -- And replace it with the new one
    verbosef(' - CLEANING: %s', cruft_path)
    os.rename(cruft_path, location .. '-temp')
    os.rmdir(location)
    os.rename(location .. '-temp', location)    
end

-- Create a filter from a package's meta information
local function __createFilter(meta)
    local filter = {
        system          = meta.system,
        host            = meta.host,
        architecture    = meta.architecture,
        toolset         = meta.toolset,
        action          = meta.action,
        configurations  = meta.configurations,
        tags            = meta.tags,
    }

    return configfilter.validate(filter)
end

-- Create a variant for this package with the given name and information
local function __createVariant(pkg, name, meta, dir)
    if meta == nil then
        p.error("Metadata entry for '" .. name .. "' does not exist.")
    end

    -- Check Meta types
    packagemanager.checkType("includedirs",         meta.includedirs,         "table")
    packagemanager.checkType("links",               meta.links,               "table")
    packagemanager.checkType("libdirs",             meta.libdirs,             "table")
    packagemanager.checkType("defines",             meta.defines,             "table")
    packagemanager.checkType("dependson",           meta.dependson,           "table")
    packagemanager.checkType("bindirs",             meta.bindirs,             "table")
    packagemanager.checkType("includedependencies", meta.includedependencies, "table")
    packagemanager.checkType("linkdependencies",    meta.linkdependencies,    "table")
    packagemanager.checkType("usedependencies",     meta.usedependencies,     "table")
    packagemanager.checkType("premake",             meta.premake,             "string")
    packagemanager.checkType("tests",               meta.tests,               "string")
    packagemanager.checkType("options",             meta.options,             "table")

    -- Initialize the package from the meta
    local variant               = variant:new(name)
    variant.filter              = __createFilter(meta)
    variant.includes            = meta.includedirs
    variant.links               = meta.links
    variant.libdirs             = meta.libdirs
    variant.defines             = meta.defines
    variant.bindirs             = meta.bindirs
    variant.dependson           = meta.dependson
    variant.includedependencies = table.join(meta.usedependencies or {}, meta.includedependencies)
    variant.linkdependencies    = table.join(meta.usedependencies or {}, meta.linkdependencies)
    variant.location            = dir
    variant.script              = meta.premake
    variant.testscript          = meta.tests
    variant.package             = pkg
    variant.loaded              = false

    -- Deal with package options.
    if name == 'noarch' then
        pkg.options = meta.options
    elseif meta.options ~= nil then
        p.error("Cannot specify package options in variants.")
    end

    -- If links wasn't set, then enumerate the libdirs if set
    if meta.links == nil and meta.libdirs ~= nil then
        variant.links = variant.links or {}
        for _, libdir in ipairs(meta.libdirs) do
            libdir = path.join(dir, libdir)
            table.insertflat(variant.links, _get_lib_files(libdir, variant.filter.system))
        end
    end

    -- Setup the initializer.
    if meta.premake ~= nil then
        variant.initializer = function()
            dofile(meta.premake)
        end
    end

    return variant
end

-- Initialize a package with the given info
local function __initialize(pkg, package_info)  
    -- Get the package location, or download it if need be
    local dir = __getPackageFolder(package_info)
    if not dir then
        -- Null out the package if 
        pkg = nil
    end

    -- Download the package
    __downloadPackage(package_info, dir)

    -- Get the absolute path of the found package.
    dir = path.getabsolute(dir)

    -- Make sure that the meta file exists.
    local env = {}
    local metafile = path.join(dir, 'premake5-meta.lua');
    if not os.isfile(metafile) then
        p.error('Package in folder "' .. dir .. '" does not have a premake5-meta.lua script.')
    end

    -- Load the meta file and the untrusted lua call
    -- We don't really have any error checking of the function
    -- so just assume it works properly
    local untrusted_function, message = loadfile(metafile, 't', env)
    if not untrusted_function then
        p.error(message)
    end

    -- Execute the meta file.
    local result, meta = pcall(untrusted_function)
    if not result then
        p.error(meta)
    end

    -- Get the variants
    pkg.variants['noarch'] = __createVariant(pkg, 'noarch', meta, dir)
    if meta.variants ~= nil then
        for _, v in ipairs(meta.variants) do
            if varient == "noarch" then
                p.error("'noarch' variant is resernved for the top-level meta-data.")
            end

            pkg.variants[v] = __createVariant(pkg, v, meta[v], dir)
        end
    end
end

local function __setPackageOptions(pkg, importOptions)
    -- Initialize the options defined in the meta file with their default values
    if pkg.options then
        for name, field in pairs(pkg.options) do
            field._proc = premake.field.accessor({_kind=field.kind}, "store")
            if field.default ~= nil then
                pkg.optionValues[name] = field._proc(nil, nil, field.default, nil)
            end
        end
    end

    -- Set options set through import
    if importOptions then
        if not pkg.options then
            p.error("Package '%s' has no options.", pkg.name)
        end

        for name, value in pairs(importOptions) do
            local field = pkg.options[name]
            if field == nil then
                p.error("Package '%s' does not have the option '%s'.", pkg.name, name)
            end

            pkg.optionValues[name] = field._proc(nil, nil, value, nil)
        end
    end

    -- Check if all required options have been set
    if pkg.options then
        for name, field in pairs(pkg.options) do
            if field.required and pkg.optionValues[name] == nil then
                p.error("Option '%s' is required for package '%s'", name, pkg.name)
            end
        end
    end
end

function import_package:new(package_info)
    local pkg = package_base.new(self, package_info)

    -- Initialize the package
    __initialize(pkg, package_info)

    -- Set the options for the package
    __setPackageOptions(pkg, package_info.options)

    setmetatable(pkg, self)
    self.__index = package_base
    self.__newindex = function(tbl, key, value)
        p.error("Attempt to modify readonly table")
    end
    self.__tostring = function()
        return "Import Package"
    end

    return pkg
end
