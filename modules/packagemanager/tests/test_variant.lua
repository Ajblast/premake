local suite = test.declare("variant")

local p = premake
local m = p.modules.packagemanager

local __filter = {
    action         = "vs2015",
    system         = os.getSystemTags("windows"),
    architecture   = "x86",
    toolset        = "msc-v140",
    configurations = "debug",
    tags           = {"a", "b", "c", "d"},
}

function suite.setup()
end

-- Empty Filter

function suite.NilFilter()
    local variant = variant:new("test")
    variant.filter = nil

    test.istrue(variant:match(__filter))
end

function suite.EmptyFilter()
    local variant = variant:new("test")
    variant.filter = {}

    test.istrue(variant:match(__filter))
end

-- Action Filter

function suite.ActionFilter()
    local variant = variant:new("test")
    variant.filter = {
        action = "vs*"
    }

    test.istrue(variant:match(__filter))
end

-- System Filter

function suite.SystemFilter()
    local variant = variant:new("test")
    variant.filter = {
        system = "windows"
    }

    test.istrue(variant:match(__filter))
end

function suite.SystemFilterNoMatch()
    local variant = variant:new("test")
    variant.filter = {
        system = "linux"
    }

    test.isfalse(variant:match(__filter))
end

-- Tag Filter

function suite.TagsFilter()
    local variant = variant:new("test")
    variant.filter = {
        tags = {"a", "b"}
    }

    test.istrue(variant:match(__filter))
end

function suite.TagsFilterNoMatch()
    local variant = variant:new("test")
    variant.filter = {
        tags = {"a", "e"}
    }

    test.isfalse(variant:match(__filter))
end

-- Config Filter

function suite.ConfigFilter()
    local variant = variant:new("test")
    variant.filter = {
        configurations = "debug"
    }

    test.istrue(variant:match(__filter))
end

function suite.ConfigFilterNoMatch()
    local variant = variant:new("test")
    variant.filter = {
        configurations = "release"
    }

    test.isfalse(variant:match(__filter))
end

