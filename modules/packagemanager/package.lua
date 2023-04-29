local p = premake
local packagemanager = p.modules.packagemanager

package = package or {}

-- Get an imported package by name
function package.get(name)
    local result = packagemanager.getPackage(name)
    if not result then
        p.error("Package was not imported; use 'import { ['" .. name .. "'] = 'version' }'.")
    end
    return result
end

-- Is a package imported
function package.isimported(name)
    return packagemanager.getPackage(name) ~= nil
end

-- Import a set of packages.
function import(tbl)
    if package.current then
        p.error('Packages cannot import other package, only the top-level workspace can do that')
    end

    return packagemanager.import(tbl)
end

-- Get an option for a package.
function getpackageoption(name, option)
    return packagemanager.getPackageOption(name, option)
end

-- Execute all test scripts
function includePackageTests()
    local wks = p.api.scope.workspace
    if wks == nil then
        p.error("No workspace in scope.", 3)
    end

    -- Go through each variant that is loaded, and execute the initializer.
    for name, pkg in pairs(wks.package_cache) do
        pkg:includeTests()
    end
end