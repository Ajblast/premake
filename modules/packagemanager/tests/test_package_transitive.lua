local suite = test.declare("package_transitive")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()

-- Setup test
function suite.setup()
    p.packagemanager.reset()
    p.packagemanager.folders = { path.join(test_dir, "test_packages") }

    --verbosef = function(msg, ...)
    --	test.print(string.format(msg, ...))
    --end

    local wks = workspace "MyWorkspace"
        platforms { "windows", "linux" }
        configurations { "Debug", "Release" }
        import {
            ['a'] = {
                location = "DontCare/a",
                version = "main",
            },
            ['b'] = {
                location = "DontCare/b",
                version = "main",
            },
            ['c'] = {
                location = "DontCare/c",
                version = "main",
            },
        }
end

-- Test include dependencies
function suite.includedependencies()
    local prj = project "MyProject"
        language "C++"
        kind "ConsoleApp"
        usedependencies { 'c' }

    local cfg = test.getConfig(prj, "Debug", "windows")
    local expected =
    {
        path.join(test_dir, 'test_packages/c/main/include'),
        path.join(test_dir, 'test_packages/b/main/include'),
        path.join(test_dir, 'test_packages/a/main/include'),
    }
    test.isequal(3, #cfg.includedirs)
    test.isequal(expected, cfg.includedirs)
end

-- Test link dependencies
function suite.linkdependencies()
    local prj = project "MyProject"
        language "C++"
        kind "ConsoleApp"
        usedependencies { 'c' }

    local cfg = test.getConfig(prj, "Debug", "windows")

    test.isequal(3, #cfg.links)
    test.isequal({'c', 'b', 'a'}, cfg.links)
end
