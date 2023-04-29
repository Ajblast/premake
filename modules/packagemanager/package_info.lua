local p = premake

-- Define package info
package_info = {
    name    = '', 
    org     = '',
    repo    = '', 
    auth    = '',

    version = '', 
    branch  = '',
    id      = '',
    options = nil,
}

-- Create a new package info
function package_info:new(name, newInfo)
    local info = {
        name=name,
        auth=newInfo.auth,
        version=newInfo.version,
        branch=newInfo.branch,
    }

    -- Set the options if it exists
    if newInfo.options ~= nil then
        info.options = newInfo.options
    end

    -- Get the github organization and repository
    local organization, repository = newInfo.location:match('(%S+)/(%S+)')

    if not organization or not repository then
        p.error("Expected 'location' to contain 'organization/repository' but found %s", location)
    end

    info.org = organization
    info.repo = repository

    -- Get the package id
    if info.branch ~= nil then
        info.id = info.branch
    elseif info.version ~= nil then
        info.id = info.version
    else
        p.error("'package_info' must set either 'version' or 'branch'")
    end

    -- Setup meta table information
    setmetatable(info, self)
    self.__index = self
    self.__metatable = false
    self.__newindex = function(tbl, key, value)
        p.error("Attempt to modify readonly table")
    end
    self.__tostring = function()
        return "Package Info"
    end

    return info
end
