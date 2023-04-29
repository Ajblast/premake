local p = premake

-- The only allowed members to be set on a package
local __members = {
    -- Premake information
    filter              = "table",
    includes            = "table",
    links               = "table",
    libdirs             = "table",
    defines             = "table",
    dependson           = "table",
    bindirs             = "table",
    includedependencies = "table",
    linkdependencies    = "table",
    location            = "string",
    server              = "string",
    script              = "string",
    testscript          = "string",
    initializer         = "function",
    loaded              = "boolean",
    package             = "table",
    options             = "table",
}

variant = {}

-- Does this variant match the filter
function variant:match(filter)
    -- If there isn't a filter, it just matches
    if self.filter == nil then
        return true
    end

    -- Check if the filter has been compiled
    if not self.__compiled_filter then
        local validFilter = configfilter.validate(self.filter)

        -- Only add values that exist
        local function add(tbl, name, value)
            if value ~= nil then
                table.insert(tbl, name .. value)
            end
        end

        -- Add the different variant values
        local tbl = {}
        add(tbl, "system:" ,        validFilter.system)
        add(tbl, "host:" ,          validFilter.host)
        add(tbl, "architecture:",   validFilter.architecture)
        add(tbl, "toolset:",        validFilter.toolset)
        add(tbl, "action:",         validFilter.action)
        add(tbl, "configurations:", validFilter.configurations)

        -- If the filter has tags, then add all of them
        if validFilter.tags then
            for _, tag in ipairs(validFilter.tags) do
                table.insert(tbl, "tags:" .. tag)
            end
        end

        -- Avoid the metatable check.
        rawset(self, "__compiled_filter", criteria.new(tbl))
    end

    -- Return whether the compiled filter matches the given filter
    return criteria.matches(self.__compiled_filter, filter)
end

-- Generate manifest
function variant:generateManifest(tbl, wks)
    if not self.loaded then
        return
    end

    tbl[self.name] = {
        location       = p.workspace.getrelative(wks, self.location),
        system         = self.filter.system,
        host           = self.filter.host,
        architecture   = self.filter.architecture,
        toolset        = self.filter.toolset,
        action         = self.filter.action,
        configurations = self.filter.configurations,
        tags           = self.filter.tags,
        includedirs    = iif(type(self.includes)  == 'function', '<function>', self.includes),
        defines        = iif(type(self.defines)   == 'function', '<function>', self.defines),
        dependson      = iif(type(self.dependson) == 'function', '<function>', self.dependson),
        links          = iif(type(self.links)     == 'function', '<function>', self.links),
        libdirs        = iif(type(self.libdirs)   == 'function', '<function>', self.libdirs),
        bindirs        = iif(type(self.bindirs)   == 'function', '<function>', self.bindirs),
    }
end

-- Create a new variant
function variant:new(name)
    local variant = {
        name = name
    }

    -- Setup meta table information
    setmetatable(variant, self)
    self.__index = self
    self.__metatable = false
    self.__newindex = function(tbl, key, value)
        local t = __members[key]
        if t ~= nil then
            if value == nil or type(value) == t then
                rawset(tbl, key, value)
            else
                p.error("'%s' expected a '%s', got: '%s'.", key, t, type(value))
            end
        else
            p.error("Attempt to write to unknown member '%s' (%s).", key, type(value))
        end
    end
    self.__tostring = function()
        return "Variant " .. name
    end

    return variant
end