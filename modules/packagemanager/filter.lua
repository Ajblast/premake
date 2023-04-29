-- A configfilter is a filter of a build configuration 

local p = premake
local packagemanager = p.modules.packagemanager

include "utils.lua"

local _members = {
    ["system"]          = "string",
    ["host"]            = "string",
    ["architecture"]    = "string",
    ["toolset"]         = "string",
    ["action"]          = "string",
    ["configurations"]  = "string",
    ["tags"]            = "table",
}

-- Members are defined in separate table above
configfilter = {}

-- Validate that a filter is valid
function configfilter.validate(filter)
    for key, _ in pairs(filter) do
        if not _members[key] then
            p.error("Invalid entry in filter: '%s'.", key)
        end

        packagemanager.checkType(key, filter[key], _members[key]);
    end

    return filter
end
