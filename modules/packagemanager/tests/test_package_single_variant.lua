local suite = test.declare("package_single_variant")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()

-- Setup the package manager
function suite.setup()
    p.packagemanager.reset()
    p.packagemanager.folders = { path.join(test_dir, "test_packages") }

    --verbosef = function(msg, ...)
    --	test.print(string.format(msg, ...))
    --end

    local wks = workspace "MyWorkspace"
        platforms { "windows", "linux" }
        configurations { "Debug", "Release" }
        import { ['test_package'] = {
            location = "DontCare/test_package",
            version = 'single-variant',
        } }
end

-- Test importing package
function suite.import()
    -- Get the package
    local pkg = package.get("test_package")
    test.isnotnil(pkg.variants["noarch"])
    test.istrue(pkg.variants["noarch"].loaded)

    test.isequal({"include"}, pkg.variants["noarch"].includes)
    test.isequal({"test_package"}, pkg.variants["noarch"].links)
end

function suite.includedependencies()
    -- Create a test package that includes the dependencies of test_package
    local prj = project "MyProject"
        language "C++"
        kind "ConsoleApp"
        includedependencies { 'test_package' }

    local cfg = test.getConfig(prj, "Debug", "windows")
    local expected = path.join(test_dir, 'test_packages/test_package/single-variant/include')
    test.isequal({expected}, cfg.includedirs)
end

function suite.linkdependencies()
    -- Create a test package that links the dependencies of test_package
    local prj = project "MyProject"
        language "C++"
        kind "ConsoleApp"
        linkdependencies { 'test_package' }

    local cfg = test.getConfig(prj, "Debug", "windows")
    test.isequal({"test_package"}, cfg.links)
end
