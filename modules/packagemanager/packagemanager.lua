local p = premake

p.modules.packagemanager = {
    cache_location = nil,
    folders = {},
}
p.modules.packagemanager._VERSION = "0.0.1-dev"

-- Backwards compatability
p.packagemanager = p.modules.packagemanager

local packagemanager = p.packagemanager
local project = p.project
local config = p.config

include "filter.lua"
include "http_utils.lua"
include "context.lua"
include "variant.lua"

include "package_info.lua"
include "import_package.lua"
include "project_package.lua"

include "package.lua"
include "package_resolver.lua"

verbosef("Initialize premake GitHub package manager")

-- Private variables
local __loaded = {}

-- Private Functions

-- Import a package by creating a new instance of it
-- Importing a package is different than packages that are defined in the premake files
local function __importPackage(package_info)
    -- If the version is nil, then we just want to download the main branch
    -- Create the package
    local pkg = import_package:new(package_info)
    if pkg ~= nil then
        return pkg
    end

    -- A package wasn't able to be made/found
    p.error("No package '%s' with the id '%s' was found.", package_info.name, package_info.id)
end

-- Public Functions

-- Import a list of packages
function packagemanager.import(tbl)
    -- Check if the list is an actual table
    if (not tbl) or (type(tbl) ~= "table") then
        local caller = filelineinfo(2)
        p.error("Invalid argument to import.\n   @%s\n", caller)
    end

    -- We always need to have a workspace.
    local scope = p.api.scope.current
    local wks   = p.api.scope.workspace
    if wks == nil then
        local caller = filelineinfo(2)
        p.error("No workspace is currently in scope.\n   @%s\n", caller)
    end

    -- Override the 'group' function, packages shouldn't call it.
    -- Get the group function from the global environment
    local groupFunc = _G['group']
    _G['group'] = function(name)
        local caller = filelineinfo(2)
        p.warn("Using group '%s' inside package script.\n   @%s\n", name, caller)
    end

    print("Import Packages")

    -- Import packages.
    local init_table = {}
    for name, info in pairs(tbl) do
        -- Make sure that each key has a table with it
        if type(info) ~= 'table' then
            p.error("Package '%s' arguments was not a table.", name)
        end

        if info.version == nil and info.branch == nil then
            p.error("Package '%s' must set either the 'version' or 'branch'", name)
        end

        local package_info = package_info:new(name, info)

        -- Import the package if hasn't already been done so
        if not wks.package_cache[name] then
            printf("Import Package [%s:%s]", package_info.name, package_info.id)
            
            -- Import the package
            local pkg = __importPackage(package_info)

            -- Add to the list of package to initialize
            table.insert(init_table, pkg)

            wks.package_cache[name] = pkg
        else
            p.warn("Package '%s' already imported.", name)
        end
    end

    print()
    print("Load Variants")
    local filter = {
        action = _ACTION,
        system = os.getSystemTags(os.target()),
    }

    for _, pkg in ipairs(init_table) do
        pkg:loadvariants(filter)
    end
    
    print()
    print("Initialize Packages")
    for _, pkg in ipairs(init_table) do
        if not __loaded[pkg.name] then
            __loaded[pkg.name] = true
        else
            -- If a package is already imported and loaded
            -- tell premake to not regenerate projects while the package is initialized
            p.api._isIncludingExternal = true
        end

        pkg:initialize()

        p.api._isIncludingExternal = nil
    end

    -- Restore 'group' function.
    _G['group'] = groupFunc

    -- Restore current scope.
    p.api.scope.current = scope
end

-- Get where the package manager should download packages
function packagemanager.getCacheLocation()
    local folder = os.getenv('PACKAGE_CACHE_PATH')

    if folder then
        return folder
    else
        if packagemanager.cache_location then
            return packagemanager.cache_location
        end
        return path.join(_MAIN_SCRIPT_DIR, _OPTIONS.to or "build", "package_cache")
    end
end

-- Get a package
function packagemanager.getPackage(name)
    local wks = p.api.scope.workspace
    if wks == nil then
        p.error("No workspace in scope", 3)
    end

    return wks.package_cache[name]
end

-- Get a package option
function packagemanager.getPackageOption(name, option)
    local pkg

    if option == nil then
        local project = p.api.scope.project or prj
        if project == nil then
            error("No project in scope.", 3)
        end

        option = name
        pkg    = project.package
    else
        pkg = packagemanager.getPackage(name)
    end

    if pkg == nil then
        p.error("Package options can't be read.", 3)
    end

    return pkg.optionValues[option]
end

-- Generate manifest
function packagemanager.generateManifest(wks)
    local tbl = {}

    -- Generate each package manifest
    for _, pkg in pairs(wks.package_cache) do
        pkg:generateManifest(tbl, wks)
    end

    return tbl
end

-- Reset the package manager
function packagemanager.reset()
    __loaded = {}
    packagemanager.cache_location    = nil
    packagemanager.folders           = {}
end

-- Callback for selecting the proper target directory
function packagemanager.__selectPackageTargetDir(cfg)
    if cfg.kind == 'StaticLib' then
        return cfg.package_libdir
    else
        return cfg.package_bindir
    end
end

-- Callback for selecting the proper target directory
function packagemanager.__selectProjectTargetDir(cfg)
    if cfg.kind == 'StaticLib' then
        return cfg.project_libdir
    else
        return cfg.project_bindir
    end
end

function packagemanager.__printPackageOptions(pkg)
    if not pkg.options then
        return
    end
    printf('  Package: %s-%s', pkg.name, pkg.version)
    printf('  --------------------------')

    local k_length = 0
    local n_length = 0
    for name, f in pairs(pkg.options) do
        if (#f.kind > k_length) then k_length = #f.kind end
        if (#name > n_length) then n_length = #name end
    end

    local fmt = "  %-" .. k_length .. "s %-" .. n_length .. "s %s %s"
    for name, f in spairs(pkg.options) do
        local k = string.format("%-" .. k_length .. "s", f.kind)
        local n = string.format("%-" .. n_length .. "s", name)
        local r = iif(f.required, "[required]", "[optional]")

        if f.default ~= nil then
            printf("  %s %s (default: %s) %s", k, n, tostring(f.default), f.description or '');
        else
            printf("  %s %s %s %s", k, n, r, f.description or '');
        end
    end
end

-- override 'workspace' so that we can initialize a package cache.
p.override(p.workspace, 'new', function(base, name)
    local wks = base(name)
    wks.package_cache = wks.package_cache or {}

    verbosef("Create Workspace: [%s]", name)

    wks.blocks[1].location = '%{path.join(_MAIN_SCRIPT_DIR, "build")}'

    return wks
end)

p.override(p.project, 'new', function(base, name, parent)
    local prj = base(name, parent)

    if not prj.package then
        if package.current then
            verbosef("Create package project variant [%s] in the active project [%s]", package.current.name, name)

            -- Set package on project.
            prj.package = package.current.package
            prj.variant = package.current
            prj.frompackage = true

            -- set some default package values.
            prj.blocks[1].targetdir = "%{premake.packagemanager.__selectPackageTargetDir(cfg)}"
            prj.blocks[1].objdir    = "%{path.join(cfg.package_objdir, name)}"
            prj.blocks[1].buildlog  = "%{cfg.package_buildlog}"
            prj.blocks[1].location  = "%{prj.package_location}"

        elseif parent ~= nil then
            verbosef("Create project package [%s] wrapper in workspace [%s]", name, parent.name)
            name = name:lower()

            -- Check if the workspace already has a package            
            local p = parent.package_cache[name]
            if p then
                error("Package '" .. name .. "' already exists in the workspace [" .. parent.name .. "].")
            end

            -- set some default project package values.
            prj.blocks[1].targetdir = "%{premake.packagemanager.__selectProjectTargetDir(cfg)}"
            prj.blocks[1].objdir    = "%{path.join(cfg.project_objdir, name)}"
            prj.blocks[1].buildlog  = "%{cfg.project_buildlog}"
            prj.blocks[1].location  = "%{prj.project_location}"

            -- Project packages are packages that are defined in the active project
            -- They are not imported and downloaded. They are the actual contents that
            -- is defined through normal premake project defines
            
            -- Set the project package and add it to the workspace
            prj.package = project_package:new(
                {
                    name = name
                }
            )
            parent.package_cache[name] = prj.package
        end
        
        -- Tell the project package that this project refrences it
        table.insert(prj.package.projects, prj)
    end

    return prj
end)

-- override 'context.compile' so that we can inject the package options into the filters
p.override(p.context, 'compile', function(base, ctx)
    -- If this is a project and it was generated from a package, inject package options
    -- into filter context.
    local prj = ctx.project
    if prj ~= nil and prj.frompackage then
        for name, value in pairs(prj.package.optionValues) do
            p.context.addFilter(ctx, name, value)
        end
    end

    return base(ctx)
end)

-- override 'processCommandLine' to injust option to print package options
p.override(p.main, 'processCommandLine', function(base)
    if (_OPTIONS["package-help"]) then
        print('Package options:')
        print();
        for wks in p.global.eachWorkspace() do
            printf('\nWorkspace: %s', wks.name)
            printf('--------------------------')
            for name, pkg in pairs(wks.package_cache) do
                if not __aliases[name] then
                    packagemanager.__printPackageOptions(pkg)
                end
            end
        end
        print('--------------------------')
        print('done.');
        os.exit(1)
    end
    base()
end)

-- Set metatable on global package manager, locking it down.
setmetatable(packagemanager, {
    __metatable = false,

    __index = function(tbl, key)
        return rawget(tbl, key)
    end,

    __newindex = function(tbl, key, value)
        if (key == "cache_location") then
            assert(value == nil or type(value) == "string", "cache_location must be a string or nil.")
            rawset(tbl, key, value)
        elseif (key == "folders") then
            assert(type(value) == "table", "folders must be a table.")
            rawset(tbl, key, value)
        -- elseif (key == "servers") then
        --     assert(type(value) == "table", "servers must be a table.")
        --     rawset(tbl, key, value)
        -- elseif (key == "aliases") then
        --     assert(type(value) == "table", "aliases must be a table.")
        --     rawset(tbl, key, value)
        else
            error("Attempt to modify packagemanager field: " .. key)
        end
    end,

    __tostring = function()
        return "Package Manager " .. packagemanager._VERSION
    end,
})

verbosef("")
verbosef("Packagemanger initialized")
verbosef("Premake version: %s", p._VERSION)
verbosef("%s", packagemanager)
verbosef("")

return p.modules.packagemanager