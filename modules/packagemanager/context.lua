-- File for turning a configuration

local p = premake
local packagemanager = p.modules.packagemanager

include "filter"

-- Local helper to concat a list strings together
local function __concat(...)
    return table.concat(table.filterempty({...}), '-'):lower()
end

-- Local helper to find tags out of a map, and remove them from the list.
local function __find(map, tags)
    local function findOne()
        for i, tag in ipairs(tags) do
            local m = map[tag]
            if m then
                table.remove(tags, i)
                return m
            end
        end
    end

    local r, final
    repeat
        r = findOne()
        if r then
            final = r
        end
    until not r

    return final
end

-- Translate a system
function packagemanager.translateSystem(system)
    if system == "windows" then
        return "win32"
    elseif system == 'macosx' then
        return "darwin"
    end
    return system
end

-- Translate an action
function packagemanager.translateAction(action)
    local var = action or _ACTION

    if var == "vs2010" then
        return "vc100"
    elseif var == "vs2012" then
        return "vc110"
    elseif var == "vs2013" then
        return "vc120"
    elseif var == "vs2015" then
        return "vc140"
    elseif var == "vs2017" then
        return "vc141"
    elseif var == "vs2019" then
        return "vc142"
    elseif var == "vs2022" then
        return "vc143"
    end

    if _OPTIONS['compiler'] then
        return _OPTIONS['compiler']
    elseif os.istarget('linux') then
        return "gcc44"
    elseif os.istarget('macosx') then
        return "clang"
    end

    return var
end

-- Translate an architecture
function packagemanager.translateArchitecture(architecture)
    if architecture == 'x86' then
        architecture = "i386"
    end
    return architecture
end

-- Translate a config
function packagemanager.translateConfig(config)
    return config
end

-- Find a system tag in a set of tags.
function packagemanager.findSystem(tags)
    local map = {
        ["android"]     = "android",
        ["posix"]       = "posix",
        ["linux"]       = "linux",
        ["centos6"]     = "centos6",
        ["centos7"]     = "centos7",
        ["centos8"]     = "centos8",
        ["centos9"]     = "centos9",
        ["osx"]         = "macosx",
        ["mac"]         = "macosx",
        ["macosx"]      = "macosx",
        ["darwin"]      = "macosx",
        ["windows"]     = "windows",
        ["win32"]       = "windows",
        ["win64"]       = "windows",
        ["win"]         = "windows",
        ["xboxone"]     = "xboxone",
        ["xboxseriesx"] = "xboxone",
        ["xbox360"]     = "xbox360",
        ["ios"]         = "ios",
        ["orbis"]       = "orbis",
        ["ps4"]         = "orbis",
        ["ps5"]         = "orbis",
    }
    return __find(map, tags)
end

-- Create a variant from the current configuration
function packagemanager.buildVariantFromConfig(cfg)
    local os        = packagemanager.translateSystem(cfg.system or os.target())
    local action    = packagemanager.translateAction(_ACTION)
    local arch      = packagemanager.translateArchitecture(cfg.architecture)
    local config    = packagemanager.translateConfig(cfg.buildcfg)
    return __concat(os, arch, action, config):lower()
end

-- Create a table of variants.
function packagemanager.buildVariantsFromFilter(filter)
    local action    = packagemanager.translateAction(filter.action)
    local arch      = packagemanager.translateArchitecture(filter.architecture)
    local config    = packagemanager.translateConfig(filter.configurations)

    local result = {}
    for _, sys in ipairs(filter.system) do
        local os = packagemanager.translateSystem(sys)
        table.insert(result, __concat(os, arch, action, config)) -- Check for [os]-[arch]-[action]-[config]
        table.insert(result, __concat(os, arch, action))         -- Check for [os]-[arch]-[action]
        table.insert(result, __concat(os, arch, config))         -- Check for [os]-[arch]-[config]
        table.insert(result, __concat(os, arch))                 -- Check for [os]-[arch]
        table.insert(result, __concat(os, action, config))       -- Check for [os]-[action]-[config]
        table.insert(result, __concat(os, action))               -- Check for [os]-[action]
        table.insert(result, __concat(os, config))               -- Check for [os]-[config]
        table.insert(result, os)                                 -- Check for [os]
    end

    return table.unique(result)
end

-- Find a toolset tag in a set of tags.
function packagemanager.findToolset(tags)
    local map = {
        -- GCC
        ["gcc"]         = "gcc",
        ["gcc41"]       = "gcc41",
        ["gcc42"]       = "gcc42",
        ["gcc44"]       = "gcc44",
        ["gcc4.4"]      = "gcc44",
        ["gcc47"]       = "gcc47",
        ["gcc48"]       = "gcc48",
        ["gcc4.8"]      = "gcc48",

        -- Clang
        ["clang"]       = "clang",

        -- Visual Studio
        ["vc100"]       = "msc-v100",
        ["vc110"]       = "msc-v110",
        ["vc120"]       = "msc-v120",
        ["vc140"]       = "msc-v140",
        ["vs2015"]      = "msc-v140",
        ["vc141"]       = "msc-v141",
        ["vc142"]       = "msc-v142",
        ["vc143"]       = "msc-v143",
        ["vc110_xp"]    = "msc-vc110_xp",
        ["vc140_xp"]    = "msc-vc140_xp",
    }
    return __find(map, tags)
end
    
-- Find an architecture tag in a set of tags.
function packagemanager.findArchitecture(tags)
    local map = {
        -- Intel
        ["x86"]     = "x86",
        ["i386"]    = "x86",
        ["x86_64"]  = "x86_64",
        ["x64"]     = "x86_64",

        -- Mips
        ["mips"]    = "mips",
        ["mips64"]  = "mips64",

        -- Arm
        ["arm"]     = "ARM",
        ["arm64"]   = "ARM64",
        ["aarch64"] = "ARM64",
        ["armv6"]   = "ARMv6",
        ["armv7"]   = "ARMv7",
        ["armv7s"]  = "ARMv7s",
        ["armv8"]   = "ARMv8",
        ["armv9"]   = "ARMv9",
    }
    return __find(map, tags)
end

-- Find an configuration tag in a set of tags.
function packagemanager.findConfig(tags)
    local map = {
        ["debug"]       = "debug",
        ["release"]     = "release",
        ["profile"]     = "profile",
        ["performance"] = "performance",
    }
    return __find(map, tags)
end

-- Create a filter from a variant string name
function packagemanager.filterFromVariant(name)
    if name == "noarch" or name == "univeral" then
        return {}
    end

    local result = {}
    local parts = string.explode(name, "-", true)

    -- Remove no arch, universal, and empty tags
    local ignore = {
        ["noarch"]      = "noarch",
        ["universal"]   = "universal",
        [""]            = "empty",
    }

    __find(ignore, parts)

    -- Find system, toolset, architecture and config.
    result.system         = packagemanager.findSystem(parts)
    result.toolset        = packagemanager.findToolset(parts)
    result.architecture   = packagemanager.findArchitecture(parts)
    result.configurations = packagemanager.findConfig(parts)

    -- The remaining tags are uses as 'tags'
    if #parts > 0 then
        result.tags = parts
    end

    return configfilter.validate(result)
end