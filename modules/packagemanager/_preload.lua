local p = premake

-- Load Module
require("packagemanager")

-- Command Line
newoption {
    trigger = "compiler",
    value	 = "gcc44",
    description = "Select which compiler to use for package system"
}

newoption {
    trigger = 'to',
    default = 'build',
    value   = 'path',
    description = 'Set the output location for the generated files'
}

newoption {
    trigger = "package-help",
    description = "Display all package options for all imported packages."
}

-- API
p.api.register {
    name = 'includedependencies',
    scope = 'config',
    kind = 'tableorstring'
}

p.api.register {
    name = 'linkdependencies',
    scope = 'config',
    kind = 'tableorstring'
}

p.api.register {
    name = 'bindirdependencies',
    scope = 'config',
    kind = 'tableorstring'
}

p.api.register {
    name = 'copybindependencies',
    scope = 'config',
    kind = 'tableorstring',
}

p.api.register {
    name = 'copybintarget',
    scope = 'config',
    kind = 'path',
    tokens = true,
    pathVars = true,
}

-- API for controlling output locations

-- Location where packages are placed
p.api.register {
    name     = 'package_location',
    scope    = 'project',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where build logs are placed
p.api.register {
    name     = 'package_buildlog',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where package obj files are placed
p.api.register {
    name     = 'package_objdir',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where package lib files are placed
-- Controls the targetdir for StaticLib projects
p.api.register {
    name     = 'package_libdir',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where package bind files are place
-- Controls the targetdir for SharedLib, WindowedApp, and ConsoleApp projects
p.api.register {
    name     = 'package_bindir',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where projects are placed
p.api.register {
    name     = 'project_location',
    scope    = 'project',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where project obj files are placed
p.api.register {
    name     = 'project_objdir',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where project lib files are placed
-- Controls the targetdir for StaticLib projects
p.api.register {
    name     = 'project_libdir',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Location where project bind files are place
-- Controls the targetdir for SharedLib, WindowedApp, and ConsoleApp projects
p.api.register {
    name     = 'project_bindir',
    scope    = 'config',
    kind     = 'path',
    tokens   = true,
    pathVars = true,
}

-- Set default package locations

-- Temporary hard code
package_location    '%{path.join(wks.location, "projects/packages")}'
package_bindir      '%{path.join(wks.location, "bin", premake.packagemanager.buildVariantFromConfig(cfg))}'
package_objdir      '%{path.join(wks.location, "obj", premake.packagemanager.buildVariantFromConfig(cfg))}'
package_libdir      '%{path.join(wks.location, "lib", premake.packagemanager.buildVariantFromConfig(cfg))}'

project_location    '%{path.join(wks.location, "projects")}'
project_bindir      '%{path.join(wks.location, "bin", premake.packagemanager.buildVariantFromConfig(cfg))}'
project_objdir      '%{path.join(wks.location, "obj", premake.packagemanager.buildVariantFromConfig(cfg))}'
project_libdir      '%{path.join(wks.location, "lib", premake.packagemanager.buildVariantFromConfig(cfg))}'

-- Shortcut if you need both include & link dependencies
function usedependencies(table)
    includedependencies(table)
    linkdependencies(table)
end

-- Packagemanager is always required
return function(cfg)
    return true
end
