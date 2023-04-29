include "filter.lua"
include "package_base.lua"
include "utils.lua"
include "variant.lua"

local p = premake
local packagemanager = p.modules.packagemanager

-- Inherit from the base package
project_package = {}

-- Project package can't load variants
function project_package:loadvariants(filter)
end

-- Project package can't load variants
function project_package:loadvariant(variant)
end

-- Project package doesn't have a manifest
function project_package:generateManifest(table, wks)
    print("This was called")
end

-- Project package can't be initialized
function project_package:initialize()
end

function project_package:new(package_info)
    local pkg = package_base.new(self, package_info)

    -- Override base methods.
    pkg.auto_includes            = function(cfg) return {} end
    pkg.auto_defines             = function(cfg) return {} end
    pkg.auto_dependson           = function(cfg) return {} end
    pkg.auto_links               = function(cfg) return { package_info.name } end
    pkg.auto_libdirs             = function(cfg) return {} end
    pkg.auto_bindirs             = function(cfg) return { cfg.targetdir } end
    pkg.auto_includedependencies = function(cfg) return {} end
    pkg.auto_linkdependencies    = function(cfg) return {} end

    setmetatable(pkg, self)
    self.__index = package_base
    self.__newindex = function(tbl, key, value)
        p.error("Attempt to modify readonly table")
    end
    self.__tostring = function()
        return "Project Package"
    end

    return pkg
end
