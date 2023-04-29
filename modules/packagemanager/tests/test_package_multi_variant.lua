local suite = test.declare("package_multi_variant")

local p        = premake
local pm       = p.packagemanager
local test_dir = os.getcwd()

local wks, prj

function suite.setup()
    p.packagemanager.reset()
    p.packagemanager.folders = { path.join(test_dir, "test_packages") }

    local wks = workspace "MyWorkspace"
        platforms { "windows", "linux" }
        configurations { "Debug", "Release" }

        import { ['test_package'] = {
            location = "DontCare/test_package",
            version = 'multi-variant',
        } }

        filter { 'platforms:windows' }
            system 'windows'
            architecture 'x86'

        filter { 'platforms:linux' }
            system 'linux'
            architecture 'x86_64'
end

-- Import variants
function suite.import()
    local pkg = package.get("test_package")
    test.isnotnil(pkg.variants["linux-i386"])
    test.isnotnil(pkg.variants["linux-x86_64"])
    test.isnotnil(pkg.variants["win32-i386"])
    test.isnotnil(pkg.variants["win32-x86_64"])

    test.isfalse(pkg.variants["linux-i386"].loaded)
    test.isfalse(pkg.variants["linux-x86_64"].loaded)
    test.isfalse(pkg.variants["win32-i386"].loaded)
    test.isfalse(pkg.variants["win32-x86_64"].loaded)
end

-- Test Include Dependencies
function suite.includedependencies()
    local prj = project "MyProject"
        language "C++"
        kind "ConsoleApp"
        includedependencies { 'test_package' }

    local cfg = test.getConfig(prj, "Debug", "windows")
    local expected = path.join(test_dir, 'test_packages/test_package/multi-variant/include')
    test.isequal({expected}, cfg.includedirs)

    local cfg = test.getConfig(prj, "Debug", "linux")
    local expected = path.join(test_dir, 'test_packages/test_package/multi-variant/include')
    test.isequal({expected}, cfg.includedirs)
end

-- Test link dependencies
function suite.linkdependencies()
    local prj = project "MyProject"
        language "C++"
        kind "ConsoleApp"
        linkdependencies { 'test_package' }

    local cfg = test.getConfig(prj, "Debug", "windows")
    local expected = path.join(test_dir, 'test_packages/test_package/multi-variant/libs/win32/x86/test_package.lib')
    test.isequal({expected}, cfg.links)

    local cfg = test.getConfig(prj, "Debug", "linux")
    local expected = path.join(test_dir, 'test_packages/test_package/multi-variant/libs/linux/x64/libtest_package.a')
    test.isequal({expected}, cfg.links)
end
