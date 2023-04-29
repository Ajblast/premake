include "package_info.lua"
include "utils.lua"

local p = premake
local packagemanager = p.modules.packagemanager

package_base = {}

-- Load all variants that match a filter
function package_base:loadvariants(filter)
    local result = {}

    -- Load all variants that match the filter
    for _, variant in pairs(self.variants) do
        if variant:match(filter) then
            local r = self:loadvariant(variant)
            if r then
                table.insert(result, r)
            end
        end
    end

    return result
end

-- Load a variant
function package_base:loadvariant(variant)
    -- If it is a string, find it
    if type(variant) == "string" then
        variant = self.variants[variant:lower()]
    end

    -- If the variant doesn't exist, or is already loaded, return.
    if not variant or variant.loaded then
        return variant
    end

    -- Load variant
    verbosef(' - Load Variant: %s:%s', self.name, variant.name)

    -- Register the variant as loaded
    variant.loaded = true

    return variant
end

-- Initialize the package
function package_base:initialize()
    -- Remember the current _SCRIPT and working directory so we can restore them.
    local cwd = os.getcwd()
    local script = _SCRIPT
    local scriptDir = _SCRIPT_DIR

    -- Store current scope.
    local scope = p.api.scope.current

    -- Add the criteria prefixes temporarily.
    if self.options then
        local noarch = self.variants['noarch']
        for option, field in pairs(self.options) do
            -- Make sure we can set the options as a filter.
            if criteria._validPrefixes[option] then
                p.error('Cannot use a predefined filter prefix: %s', option)
            end
            criteria._validPrefixes[option] = true

            -- Export custom defines from package options
            if noarch and field.define then
                if field.kind == 'boolean' then
                    if self.optionValues[option] then
                        noarch.defines = noarch.defines or {}
                        table.insert(noarch.defines, field.define)
                    end
                else
                    noarch.defines = noarch.defines or {}
                    table.insert(noarch.defines, field.define .. '=' .. self.optionValues[option])
                end
            end
        end
    end

    -- Execture the initializer
    local errors = {}
    for name, variant in pairs(self.variants) do
        if variant.loaded and variant.initializer then
            -- Set the new _SCRIPT and working directory
            _SCRIPT     = variant.script
            _SCRIPT_DIR = variant.location
            os.chdir(variant.location)

            verbosef("  - Initialize [%s]: Variant [%s] | Script [%s] | Script Dir: [%s]", self.name, name, _SCRIPT, _SCRIPT_DIR)

            -- Store the current current package context.
            local previous_package = package.current
            package.current = variant

            -- Execute the callback, capture errors until the end, when scope is restored.
            local ok, err = pcall(variant.initializer, 'project')
            if not ok then
                table.insert(errors, err)
            end

            -- Clear the variant initializer to make sure that it is never ran again.
            variant.initializer = nil

            -- Restore package context.
            package.current = previous_package
        end
    end

    -- Restore the criteria prefixes.
    if self.options then
        for option, kind in pairs(self.options) do
            criteria._validPrefixes[option] = nil
        end
    end

    -- Restore current scope.
    p.api.scope.current = scope

    -- Finally, restore the previous _SCRIPT variable and working directory
    _SCRIPT = script
    _SCRIPT_DIR = scriptDir
    os.chdir(cwd)

    -- Throw the error if there was any.
    if #errors > 0 then
        p.error(table.concat(errors, "\n"))
    end    
end

-- Generate the manifest
function package_base:generateManifest(tbl, wks)
    -- Generate the variant manifests
    local vtbl = {}
    for _, v in pairs(self.variants) do
        v:generateManifest(vtbl, wks)
    end

    -- Check if the variant table is nil
    if next(vtbl) == nil then
        vtbl = nil
    end

    -- Add the package manifest
    tbl[self.name] = {
        id = self.id,
        variants = vtbl
    }
end

-- Include tests in the package
function package_base:includeTests()
    -- Remember the current _SCRIPT and working directory so we can restore them.
    local cwd = os.getcwd()
    local script = _SCRIPT
    local scriptDir = _SCRIPT_DIR

    -- Store current scope.
    local scope = p.api.scope.current

    -- Go through each variant that is loaded, and execute the initializer.
    for name, variant in pairs(self.variants) do
        if variant.loaded and variant.testscript ~= nil then
            -- Set the new _SCRIPT and working directory
            _SCRIPT     = variant.testscript
            _SCRIPT_DIR = variant.location
            os.chdir(variant.location)

            -- store current package context.
            local previous_package = package.current
            package.current = variant

            -- execute the testscript
            dofile(variant.testscript)

            -- restore package context.
            package.current = previous_package
        end
    end

    -- Restore current scope.
    p.api.scope.current = scope

    -- Finally, restore the previous _SCRIPT variable and working directory
    _SCRIPT = script
    _SCRIPT_DIR = scriptDir
    os.chdir(cwd)
end

-- Create a new package base class
function package_base:new(package_info)
    -- Create a new table that uses package_base as the index prototype
    local pkg = {
        name = package_info.name,
        id = package_info.info,
        projects = {},      -- Projects that use this package
        variants = {},      -- The known variants of this package
        optionValues = {},  -- Options for this package
        options = {},    
    }

    -- Private package cache
    -- Contains [propertyName][configName]
    local _cache = {}

    -- Get a value from the cache
    local function getCacheEntry(name, cfg)
        local cacheEntry = _cache[name]
        if not cacheEntry then
            return nil
        end
        return cacheEntry[cfg.name]
    end

    -- Set the values of a cache entry
    local function setCacheEntry(name, cfg, value)
        _cache[name] = _cache[name] or {}
        _cache[name][cfg.name] = value
    end

    -- Get properties of the package depending on the config and add it to the cache
    -- Set join if the values should be variant location should be joined to the cache value
    local function getProperties(name, cfg, join)
        -- Return the properties from the cache
        local cacheEntry = getCacheEntry(name, cfg)
        if cacheEntry then
            return cacheEntry
        end

        -- Create a new filter
        local filter = {
            action         = _ACTION,
            system         = os.getSystemTags(cfg.system or os.target()),
            architecture   = cfg.architecture,
            toolset        = cfg.toolset,
            configurations = cfg.buildcfg,
            tags           = cfg.tags,
        }

        cacheEntry = {}
        local cacheItem = true

        -- Get variants that match this filter.
        local variants = pkg:loadvariants(filter)

        -- Initialize variants that have just been loaded.
        pkg:initialize()

        -- Combine properties.
        for _, v in ipairs(variants) do
            -- Get the variant items
            local items = v[name]

            -- If the items is a function, load the result
            if type(items) == "function" then
                -- Get the items from the function, and don't set the cache entry
                items = items(cfg)
                cacheItem = false
            end

            -- If there are items in the variant, iterate over them and set 
            if items then
                for _, value in ipairs(items) do
                    value = p.detoken.expand(value, cfg.environ, {pathVars=true}, v.location)
                    if join then
                        table.insert(cacheEntry, path.join(v.location, value))
                    else
                        table.insert(cacheEntry, value)
                    end
                end
            end
        end

        -- Should the cache value be set
        if cacheItem then
            setCacheEntry(name, cfg, cacheEntry)
        end

        return cacheEntry
    end

    -- Setup auto-resolve for includes.
    function pkg.auto_includes(cfg)
        return getProperties('includes', cfg, true)
    end

    -- Setup auto-resolve for defines.
    function pkg.auto_defines(cfg)
        return getProperties('defines', cfg, false)
    end

    -- Setup auto-resolve for dependson.
    function pkg.auto_dependson(cfg)
        return getProperties('dependson', cfg, false)
    end

    -- Setup auto-resolve for links.
    function pkg.auto_links(cfg)
        return getProperties('links', cfg, false)
    end

    -- Setup auto-resolve for libdirs.
    function pkg.auto_libdirs(cfg)
        return getProperties('libdirs', cfg, true)
    end

    -- Setup auto-resolve for bindirs.
    function pkg.auto_bindirs(cfg)
        return getProperties('bindirs', cfg, true)
    end

    -- Setup auto-resolve for includedependencies.
    function pkg.auto_includedependencies(cfg)
        return getProperties('includedependencies', cfg, false)
    end

    -- Setup auto-resolve for linkdependencies.
    function pkg.auto_linkdependencies(cfg)
        return getProperties('linkdependencies', cfg, false)
    end

    -- Setup auto-resolve for includepath.
    function pkg.auto_includepath(cfg)
        local r = pkg.auto_includes(cfg)
        if (r and #r > 0) then
            return r[1]
        end
        return nil
    end

    -- Setup auto-resolve for binpath.
    function pkg.auto_binpath(cfg)
        local r = pkg.auto_bindirs(cfg)
        if (r and #r > 0) then
            return r[1]
        end
        return nil
    end

    -- Set meta table information
    setmetatable(pkg, self)
    self.__index = self
    self.__newindex = function(tbl, key, value)
        p.error("Attempt to write to unknown member '%s' (%s).", key, type(value))
    end
    self.__tostring = function()
        return "Package Base"
    end

    return pkg
end