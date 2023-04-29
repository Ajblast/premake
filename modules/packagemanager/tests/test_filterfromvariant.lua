local suite = test.declare("filterfromvariant")

local p = premake
local packagemanager = p.modules.packagemanager

-- Are two tables equal
local function tableequals(a, b)
    if a == b then
        return true
    end
    if a == nil or b == nil then
        return false
    end
    for k, v in pairs(a) do
        if type(v) == 'table' then
            if not tableequals(b[k], v) then
                return false
            end
        elseif b[k] ~= v then
            return false
        end
    end
    return true
end

-- Are two tables equal
local function isTableEqual(a, b)
    if a == b then
        return
    end

    if not tableequals(a,b) or not tableequals(b,a) then
        test.fail("expected value:\n%s\ngot:\n%s\n", table.tostring(a, 2), table.tostring(b, 2))
    end
end


function suite.setup()
end

--- Android

function suite.testVariant_android()
    isTableEqual({system = 'android'}, packagemanager.filterFromVariant('android'))
end

function suite.testVariant_android_armeabi()
    isTableEqual({system = 'android', tags = {'armeabi'}}, packagemanager.filterFromVariant('android-armeabi'))
end

function suite.testVariant_android_armeabi_gcc48()
    isTableEqual({system = 'android', toolset = 'gcc48', tags = {'armeabi'}}, packagemanager.filterFromVariant('android-armeabi-gcc48'))
end

function suite.testVariant_android_armeabi_gcc48_debug()
    isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'debug', tags = {'armeabi'}}, packagemanager.filterFromVariant('android-armeabi-gcc48-debug'))
end

function suite.testVariant_android_armeabi_gcc48_release()
    isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'release', tags = {'armeabi'}}, packagemanager.filterFromVariant('android-armeabi-gcc48-release'))
end

function suite.testVariant_android_armeabiv7a()
    isTableEqual({system = 'android', tags = {'armeabiv7a'}}, packagemanager.filterFromVariant('android-armeabiv7a'))
end

function suite.testVariant_android_armeabiv7a_gcc48()
    isTableEqual({system = 'android', toolset = 'gcc48', tags = {'armeabiv7a'}}, packagemanager.filterFromVariant('android-armeabiv7a-gcc48'))
end

function suite.testVariant_android_armeabiv7a_gcc48_debug()
    isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'debug', tags = {'armeabiv7a'}}, packagemanager.filterFromVariant('android-armeabiv7a-gcc48-debug'))
end

function suite.testVariant_android_armeabiv7a_gcc48_release()
    isTableEqual({system = 'android', toolset = 'gcc48', configurations = 'release', tags = {'armeabiv7a'}}, packagemanager.filterFromVariant('android-armeabiv7a-gcc48-release'))
end

function suite.testVariant_android_i386()
    isTableEqual({system = 'android', architecture = 'x86'}, packagemanager.filterFromVariant('android-i386'))
end

function suite.testVariant_android_i386_clang_debug()
    isTableEqual({system = 'android', toolset = 'clang', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('android-i386-clang-debug'))
end

function suite.testVariant_android_i386_gcc48_release()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('android-i386-gcc48-release'))
end

function suite.testVariant_android_mips()
    isTableEqual({system = 'android', architecture = 'mips'}, packagemanager.filterFromVariant('android-mips'))
end

function suite.testVariant_android_mips_gcc48()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'mips'}, packagemanager.filterFromVariant('android-mips-gcc48'))
end

function suite.testVariant_android_mips_gcc48_debug()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'mips', configurations = 'debug'}, packagemanager.filterFromVariant('android-mips-gcc48-debug'))
end

function suite.testVariant_android_mips_gcc48_release()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'mips', configurations = 'release'}, packagemanager.filterFromVariant('android-mips-gcc48-release'))
end

function suite.testVariant_android_x86()
    isTableEqual({system = 'android', architecture = 'x86'}, packagemanager.filterFromVariant('android-x86'))
end

function suite.testVariant_android_x86_gcc48()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86'}, packagemanager.filterFromVariant('android-x86-gcc48'))
end

function suite.testVariant_android_x86_gcc48_debug()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('android-x86-gcc48-debug'))
end

function suite.testVariant_android_x86_gcc48_release()
    isTableEqual({system = 'android', toolset = 'gcc48', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('android-x86-gcc48-release'))
end

function suite.testVariant_arm_gcc48_android8()
    isTableEqual({toolset = 'gcc48', architecture = 'ARM', tags = {'android8'}}, packagemanager.filterFromVariant('arm-gcc48-android8'))
end

-- Centos

function suite.testVariant_centos7_x86_64()
    isTableEqual({system = 'centos7', architecture = 'x86_64'}, packagemanager.filterFromVariant('centos7-x86_64'))
end

-- Darwin

function suite.testVariant_darwin()
    isTableEqual({system = 'macosx'}, packagemanager.filterFromVariant('darwin'))
end

function suite.testVariant_darwing_i386_clang_debug()
    isTableEqual({toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'darwing'}}, packagemanager.filterFromVariant('darwing-i386-clang-debug'))
end

-- Macosx - Darwin

function suite.testVariant_darwin_i386()
    isTableEqual({system = 'macosx', architecture = 'x86'}, packagemanager.filterFromVariant('darwin-i386'))
end

function suite.testVariant_darwin_i386_anticheat()
    isTableEqual({system = 'macosx', architecture = 'x86', tags = {'anticheat'}}, packagemanager.filterFromVariant('darwin-i386-anticheat'))
end

function suite.testVariant_darwin_i386_clang()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86'}, packagemanager.filterFromVariant('darwin-i386-clang'))
end

function suite.testVariant_darwin_i386_clang_6_0_release()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'6.0'}}, packagemanager.filterFromVariant('darwin-i386-clang-6.0-release'))
end

function suite.testVariant_darwin_i386_clang_6_0_release_libc__()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'6.0', 'libc++'}}, packagemanager.filterFromVariant('darwin-i386-clang-6.0-release-libc++'))
end

function suite.testVariant_darwin_i386_clang_debug()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('darwin-i386-clang-debug'))
end

function suite.testVariant_darwin_i386_clang_debug_blz()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('darwin-i386-clang-debug-blz'))
end

function suite.testVariant_darwin_i386_clang_debug_libc__()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'libc++'}}, packagemanager.filterFromVariant('darwin-i386-clang-debug-libc++'))
end

function suite.testVariant_darwin_i386_clang_debug_std()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('darwin-i386-clang-debug-std'))
end

function suite.testVariant_darwin_i386_clang_debug_stl()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'debug', tags = {'stl'}}, packagemanager.filterFromVariant('darwin-i386-clang-debug-stl'))
end

function suite.testVariant_darwin_i386_clang_release()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('darwin-i386-clang-release'))
end

function suite.testVariant_darwin_i386_clang_release_blz()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('darwin-i386-clang-release-blz'))
end

function suite.testVariant_darwin_i386_clang_release_libc__()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'libc++'}}, packagemanager.filterFromVariant('darwin-i386-clang-release-libc++'))
end

function suite.testVariant_darwin_i386_clang_release_std()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('darwin-i386-clang-release-std'))
end

function suite.testVariant_darwin_i386_clang_release_stl()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86', configurations = 'release', tags = {'stl'}}, packagemanager.filterFromVariant('darwin-i386-clang-release-stl'))
end

function suite.testVariant_darwin_i386_debug()
    isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('darwin-i386-debug'))
end

function suite.testVariant_darwin_i386_debug_std()
    isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('darwin-i386-debug-std'))
end

function suite.testVariant_darwin_i386_gcc42_debug()
    isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('darwin-i386-gcc42-debug'))
end

function suite.testVariant_darwin_i386_gcc42_release()
    isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('darwin-i386-gcc42-release'))
end

function suite.testVariant_darwin_i386_libcpp_debug()
    isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'debug', tags = {'libcpp'}}, packagemanager.filterFromVariant('darwin-i386-libcpp-debug'))
end

function suite.testVariant_darwin_i386_libcpp_release()
    isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'release', tags = {'libcpp'}}, packagemanager.filterFromVariant('darwin-i386-libcpp-release'))
end

function suite.testVariant_darwin_i386_pic()
    isTableEqual({system = 'macosx', architecture = 'x86', tags = {'pic'}}, packagemanager.filterFromVariant('darwin-i386-pic'))
end

function suite.testVariant_darwin_i386_release()
    isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('darwin-i386-release'))
end

function suite.testVariant_darwin_i386_release_std()
    isTableEqual({system = 'macosx', architecture = 'x86', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('darwin-i386-release-std'))
end

function suite.testVariant_darwin_x86_64()
    isTableEqual({system = 'macosx', architecture = 'x86_64'}, packagemanager.filterFromVariant('darwin-x86_64'))
end

function suite.testVariant_darwin_x86_64_clang()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64'}, packagemanager.filterFromVariant('darwin-x86_64-clang'))
end

function suite.testVariant_darwin_x86_64_clang_debug()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('darwin-x86_64-clang-debug'))
end

function suite.testVariant_darwin_x86_64_clang_debug_blz()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-debug-blz'))
end

function suite.testVariant_darwin_x86_64_clang_debug_libc__()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'libc++'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-debug-libc++'))
end

function suite.testVariant_darwin_x86_64_clang_debug_std()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-debug-std'))
end

function suite.testVariant_darwin_x86_64_clang_debug_stl()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'debug', tags = {'stl'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-debug-stl'))
end

function suite.testVariant_darwin_x86_64_clang_release()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('darwin-x86_64-clang-release'))
end

function suite.testVariant_darwin_x86_64_clang_release_blz()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-release-blz'))
end

function suite.testVariant_darwin_x86_64_clang_release_libc__()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'libc++'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-release-libc++'))
end

function suite.testVariant_darwin_x86_64_clang_release_std()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-release-std'))
end

function suite.testVariant_darwin_x86_64_clang_release_stl()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64', configurations = 'release', tags = {'stl'}}, packagemanager.filterFromVariant('darwin-x86_64-clang-release-stl'))
end

function suite.testVariant_darwin_x86_64_debug()
    isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('darwin-x86_64-debug'))
end

function suite.testVariant_darwin_x86_64_libcpp_debug()
    isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'debug', tags = {'libcpp'}}, packagemanager.filterFromVariant('darwin-x86_64-libcpp-debug'))
end

function suite.testVariant_darwin_x86_64_libcpp_release()
    isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'release', tags = {'libcpp'}}, packagemanager.filterFromVariant('darwin-x86_64-libcpp-release'))
end

function suite.testVariant_darwin_x86_64_pic()
    isTableEqual({system = 'macosx', architecture = 'x86_64', tags = {'pic'}}, packagemanager.filterFromVariant('darwin-x86_64-pic'))
end

function suite.testVariant_darwin_x86_64_release()
    isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('darwin-x86_64-release'))
end

function suite.testVariant_darwin_x86_64_release_std()
    isTableEqual({system = 'macosx', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('darwin-x86_64-release-std'))
end

-- Macosx

function suite.testVariant_macosx()
    isTableEqual({system = 'macosx'}, packagemanager.filterFromVariant('macosx'))
end

function suite.testVariant_macosx_i386_clang()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86'}, packagemanager.filterFromVariant('macosx-i386-clang'))
end

function suite.testVariant_macosx_i386_gcc42()
    isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86'}, packagemanager.filterFromVariant('macosx-i386-gcc42'))
end

function suite.testVariant_macosx_i386_gcc42_debug()
    isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('macosx-i386-gcc42-debug'))
end

function suite.testVariant_macosx_i386_gcc42_release()
    isTableEqual({system = 'macosx', toolset = 'gcc42', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('macosx-i386-gcc42-release'))
end

function suite.testVariant_macosx_x86_64_clang()
    isTableEqual({system = 'macosx', toolset = 'clang', architecture = 'x86_64'}, packagemanager.filterFromVariant('macosx-x86_64-clang'))
end

-- IOS

function suite.testVariant_ios_arm64()
    isTableEqual({system = 'ios', architecture = 'ARM64'}, packagemanager.filterFromVariant('ios-arm64'))
end

function suite.testVariant_ios_arm64_clang()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64'}, packagemanager.filterFromVariant('ios-arm64-clang'))
end

function suite.testVariant_ios_arm64_clang_debug()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64', configurations = 'debug'}, packagemanager.filterFromVariant('ios-arm64-clang-debug'))
end

function suite.testVariant_ios_arm64_clang_release()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARM64', configurations = 'release'}, packagemanager.filterFromVariant('ios-arm64-clang-release'))
end

function suite.testVariant_ios_armv6_clang()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv6'}, packagemanager.filterFromVariant('ios-armv6-clang'))
end

function suite.testVariant_ios_armv7()
    isTableEqual({system = 'ios', architecture = 'ARMv7'}, packagemanager.filterFromVariant('ios-armv7'))
end

function suite.testVariant_ios_armv7_clang()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7'}, packagemanager.filterFromVariant('ios-armv7-clang'))
end

function suite.testVariant_ios_armv7_clang_debug()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7', configurations = 'debug'}, packagemanager.filterFromVariant('ios-armv7-clang-debug'))
end

function suite.testVariant_ios_armv7_clang_release()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7', configurations = 'release'}, packagemanager.filterFromVariant('ios-armv7-clang-release'))
end

function suite.testVariant_ios_armv7s()
    isTableEqual({system = 'ios', architecture = 'ARMv7s'}, packagemanager.filterFromVariant('ios-armv7s'))
end

function suite.testVariant_ios_armv7s_clang()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s'}, packagemanager.filterFromVariant('ios-armv7s-clang'))
end

function suite.testVariant_ios_armv7s_clang_debug()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s', configurations = 'debug'}, packagemanager.filterFromVariant('ios-armv7s-clang-debug'))
end

function suite.testVariant_ios_armv7s_clang_release()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'ARMv7s', configurations = 'release'}, packagemanager.filterFromVariant('ios-armv7s-clang-release'))
end

function suite.testVariant_ios_i386()
    isTableEqual({system = 'ios', architecture = 'x86'}, packagemanager.filterFromVariant('ios-i386'))
end

function suite.testVariant_ios_i386_clang()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86'}, packagemanager.filterFromVariant('ios-i386-clang'))
end

function suite.testVariant_ios_i386_clang_debug()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('ios-i386-clang-debug'))
end

function suite.testVariant_ios_i386_clang_release()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('ios-i386-clang-release'))
end

function suite.testVariant_ios_x86_64()
    isTableEqual({system = 'ios', architecture = 'x86_64'}, packagemanager.filterFromVariant('ios-x86_64'))
end

function suite.testVariant_ios_x86_64_clang()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64'}, packagemanager.filterFromVariant('ios-x86_64-clang'))
end

function suite.testVariant_ios_x86_64_clang_debug()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('ios-x86_64-clang-debug'))
end

function suite.testVariant_ios_x86_64_clang_release()
    isTableEqual({system = 'ios', toolset = 'clang', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('ios-x86_64-clang-release'))
end

-- Linux

function suite.testVariant_linux()
    isTableEqual({system = 'linux'}, packagemanager.filterFromVariant('linux'))
end

function suite.testVariant_linux_i386()
    isTableEqual({system = 'linux', architecture = 'x86'}, packagemanager.filterFromVariant('linux-i386'))
end

function suite.testVariant_linux_i386_gcc41_debug()
    isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('linux-i386-gcc41-debug'))
end

function suite.testVariant_linux_i386_gcc41_release()
    isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('linux-i386-gcc41-release'))
end

function suite.testVariant_linux_i386_gcc44_debug()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('linux-i386-gcc44-debug'))
end

function suite.testVariant_linux_i386_gcc44_release()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('linux-i386-gcc44-release'))
end

function suite.testVariant_linux_i386_gcc47()
    isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86'}, packagemanager.filterFromVariant('linux-i386-gcc47'))
end

function suite.testVariant_linux_i386_gcc47_debug()
    isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('linux-i386-gcc47-debug'))
end

function suite.testVariant_linux_i386_gcc47_release()
    isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('linux-i386-gcc47-release'))
end

function suite.testVariant_linux_i386_gcc48_debug()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('linux-i386-gcc48-debug'))
end

function suite.testVariant_linux_i386_gcc48_release()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('linux-i386-gcc48-release'))
end

function suite.testVariant_linux_i386_gcc_debug()
    isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('linux-i386-gcc-debug'))
end

function suite.testVariant_linux_i386_gcc_release()
    isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('linux-i386-gcc-release'))
end

function suite.testVariant_linux_x64()
    isTableEqual({system = 'linux', architecture = 'x86_64'}, packagemanager.filterFromVariant('linux-x64'))
end

function suite.testVariant_linux_x86_64()
    isTableEqual({system = 'linux', architecture = 'x86_64'}, packagemanager.filterFromVariant('linux-x86_64'))
end

function suite.testVariant_linux_x86_64_debug()
    isTableEqual({system = 'linux', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-debug'))
end

function suite.testVariant_linux_x86_64_gcc4_4_debug()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc4.4-debug'))
end

function suite.testVariant_linux_x86_64_gcc4_4_release()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc4.4-release'))
end

function suite.testVariant_linux_x86_64_gcc4_8_debug()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc4.8-debug'))
end

function suite.testVariant_linux_x86_64_gcc4_8_release()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc4.8-release'))
end

function suite.testVariant_linux_x86_64_gcc41_debug()
    isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc41-debug'))
end

function suite.testVariant_linux_x86_64_gcc41_release()
    isTableEqual({system = 'linux', toolset = 'gcc41', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc41-release'))
end

function suite.testVariant_linux_x86_64_gcc44()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64'}, packagemanager.filterFromVariant('linux-x86_64-gcc44'))
end

function suite.testVariant_linux_x86_64_gcc44_debug()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc44-debug'))
end

function suite.testVariant_linux_x86_64_gcc44_debug_blz()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('linux-x86_64-gcc44-debug-blz'))
end

function suite.testVariant_linux_x86_64_gcc44_debug_stl()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug', tags = {'stl'}}, packagemanager.filterFromVariant('linux-x86_64-gcc44-debug-stl'))
end

function suite.testVariant_linux_x86_64_gcc44_release()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc44-release'))
end

function suite.testVariant_linux_x86_64_gcc44_release_()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', tags = {'release_'}}, packagemanager.filterFromVariant('linux-x86_64-gcc44-release_'))
end

function suite.testVariant_linux_x86_64_gcc44_release_blz()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('linux-x86_64-gcc44-release-blz'))
end

function suite.testVariant_linux_x86_64_gcc44_release_stl()
    isTableEqual({system = 'linux', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release', tags = {'stl'}}, packagemanager.filterFromVariant('linux-x86_64-gcc44-release-stl'))
end

function suite.testVariant_linux_x86_64_gcc47()
    isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86_64'}, packagemanager.filterFromVariant('linux-x86_64-gcc47'))
end

function suite.testVariant_linux_x86_64_gcc47_debug()
    isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc47-debug'))
end

function suite.testVariant_linux_x86_64_gcc47_release()
    isTableEqual({system = 'linux', toolset = 'gcc47', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc47-release'))
end

function suite.testVariant_linux_x86_64_gcc48()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64'}, packagemanager.filterFromVariant('linux-x86_64-gcc48'))
end

function suite.testVariant_linux_x86_64_gcc48_debug()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc48-debug'))
end

function suite.testVariant_linux_x86_64_gcc48_debug_blz()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('linux-x86_64-gcc48-debug-blz'))
end

function suite.testVariant_linux_x86_64_gcc48_release()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc48-release'))
end

function suite.testVariant_linux_x86_64_gcc48_release_blz()
    isTableEqual({system = 'linux', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('linux-x86_64-gcc48-release-blz'))
end

function suite.testVariant_linux_x86_64_gcc_debug()
    isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('linux-x86_64-gcc-debug'))
end

function suite.testVariant_linux_x86_64_gcc_release()
    isTableEqual({system = 'linux', toolset = 'gcc', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-gcc-release'))
end

function suite.testVariant_linux_x86_64_pic()
    isTableEqual({system = 'linux', architecture = 'x86_64', tags = {'pic'}}, packagemanager.filterFromVariant('linux-x86_64-pic'))
end

function suite.testVariant_linux_x86_64_release()
    isTableEqual({system = 'linux', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('linux-x86_64-release'))
end

-- Mips

function suite.testVariant_mips_gcc48_android9()
    isTableEqual({toolset = 'gcc48', architecture = 'mips', tags = {'android9'}}, packagemanager.filterFromVariant('mips-gcc48-android9'))
end

function suite.testVariant_ndk_r9c_windows_x86_64()
    isTableEqual({system = 'windows', architecture = 'x86_64', tags = {'ndk', 'r9c'}}, packagemanager.filterFromVariant('ndk-r9c-windows-x86_64'))
end

-- No Arch

function suite.testVariant_noarch()
    isTableEqual({}, packagemanager.filterFromVariant('noarch'))
end

function suite.testVariant_noarch_old()
    isTableEqual({tags = {'noarch_old'}}, packagemanager.filterFromVariant('noarch_old'))
end

function suite.testVariant_noarch_original()
    isTableEqual({tags = {'noarch_original'}}, packagemanager.filterFromVariant('noarch_original'))
end

function suite.testVariant_noarch_orig()
    isTableEqual({tags = {'orig'}}, packagemanager.filterFromVariant('noarch-orig'))
end

function suite.testVariant_noarch_src()
    isTableEqual({tags = {'src'}}, packagemanager.filterFromVariant('noarch-src'))
end

-- Orbis

function suite.testVariant_orbis___debug()
    isTableEqual({system = 'orbis', configurations = 'debug'}, packagemanager.filterFromVariant('orbis---debug'))
end

function suite.testVariant_orbis___release()
    isTableEqual({system = 'orbis', configurations = 'release'}, packagemanager.filterFromVariant('orbis---release'))
end

function suite.testVariant_orbis_vc110_debug()
    isTableEqual({system = 'orbis', toolset = 'msc-v110', configurations = 'debug'}, packagemanager.filterFromVariant('orbis-vc110-debug'))
end

function suite.testVariant_orbis_vc110_release()
    isTableEqual({system = 'orbis', toolset = 'msc-v110', configurations = 'release'}, packagemanager.filterFromVariant('orbis-vc110-release'))
end

function suite.testVariant_orbis_vc120_debug()
    isTableEqual({system = 'orbis', toolset = 'msc-v120', configurations = 'debug'}, packagemanager.filterFromVariant('orbis-vc120-debug'))
end

function suite.testVariant_orbis_vc120_release()
    isTableEqual({system = 'orbis', toolset = 'msc-v120', configurations = 'release'}, packagemanager.filterFromVariant('orbis-vc120-release'))
end

function suite.testVariant_orbis_vc140_debug()
    isTableEqual({system = 'orbis', toolset = 'msc-v140', configurations = 'debug'}, packagemanager.filterFromVariant('orbis-vc140-debug'))
end

function suite.testVariant_orbis_vc140_release()
    isTableEqual({system = 'orbis', toolset = 'msc-v140', configurations = 'release'}, packagemanager.filterFromVariant('orbis-vc140-release'))
end

function suite.testVariant_ps3()
    isTableEqual({tags = {'ps3'}}, packagemanager.filterFromVariant('ps3'))
end

function suite.testVariant_ps3_debug()
    isTableEqual({configurations = 'debug', tags = {'ps3'}}, packagemanager.filterFromVariant('ps3-debug'))
end

function suite.testVariant_ps3_release()
    isTableEqual({configurations = 'release', tags = {'ps3'}}, packagemanager.filterFromVariant('ps3-release'))
end

function suite.testVariant_ps4_debug()
    isTableEqual({system = 'orbis', configurations = 'debug'}, packagemanager.filterFromVariant('ps4-debug'))
end

function suite.testVariant_ps4_profile()
    isTableEqual({system = 'orbis', configurations = 'profile'}, packagemanager.filterFromVariant('ps4-profile'))
end

function suite.testVariant_ps4_release()
    isTableEqual({system = 'orbis', configurations = 'release'}, packagemanager.filterFromVariant('ps4-release'))
end

-- Posix

function suite.testVariant_posix_x86_64_gcc44_debug()
    isTableEqual({system = 'posix', toolset = 'gcc44', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('posix-x86_64-gcc44-debug'))
end

function suite.testVariant_posix_x86_64_gcc44_release()
    isTableEqual({system = 'posix', toolset = 'gcc44', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('posix-x86_64-gcc44-release'))
end

function suite.testVariant_posix_x86_64_gcc48_debug()
    isTableEqual({system = 'posix', toolset = 'gcc48', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('posix-x86_64-gcc48-debug'))
end

function suite.testVariant_posix_x86_64_gcc48_release()
    isTableEqual({system = 'posix', toolset = 'gcc48', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('posix-x86_64-gcc48-release'))
end

-- Windows

function suite.testVariant_win32()
    isTableEqual({system = 'windows'}, packagemanager.filterFromVariant('win32'))
end

function suite.testVariant_win32_i386()
    isTableEqual({system = 'windows', architecture = 'x86'}, packagemanager.filterFromVariant('win32-i386'))
end

function suite.testVariant_win32_i386_anticheat()
    isTableEqual({system = 'windows', architecture = 'x86', tags = {'anticheat'}}, packagemanager.filterFromVariant('win32-i386-anticheat'))
end

function suite.testVariant_win32_i386_debug()
    isTableEqual({system = 'windows', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('win32-i386-debug'))
end

function suite.testVariant_win32_i386_release()
    isTableEqual({system = 'windows', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('win32-i386-release'))
end

function suite.testVariant_win32_i386_vc100()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86'}, packagemanager.filterFromVariant('win32-i386-vc100'))
end

function suite.testVariant_win32_i386_vc100_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('win32-i386-vc100-debug'))
end

function suite.testVariant_win32_i386_vc100_debug_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-blz'))
end

function suite.testVariant_win32_i386_vc100_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-mt'))
end

function suite.testVariant_win32_i386_vc100_debug_mt_noidn()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'mt', 'noidn'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-mt-noidn'))
end

function suite.testVariant_win32_i386_vc100_debug_s()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'s'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-s'))
end

function suite.testVariant_win32_i386_vc100_debug_static()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'static'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-static'))
end

function suite.testVariant_win32_i386_vc100_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-std'))
end

function suite.testVariant_win32_i386_vc100_debug_stl()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'debug', tags = {'stl'}}, packagemanager.filterFromVariant('win32-i386-vc100-debug-stl'))
end

function suite.testVariant_win32_i386_vc100_release()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('win32-i386-vc100-release'))
end

function suite.testVariant_win32_i386_vc100_release_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-blz'))
end

function suite.testVariant_win32_i386_vc100_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-mt'))
end

function suite.testVariant_win32_i386_vc100_release_mt_noidn()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'mt', 'noidn'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-mt-noidn'))
end

function suite.testVariant_win32_i386_vc100_release_s()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'s'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-s'))
end

function suite.testVariant_win32_i386_vc100_release_static()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'static'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-static'))
end

function suite.testVariant_win32_i386_vc100_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-std'))
end

function suite.testVariant_win32_i386_vc100_release_stl()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86', configurations = 'release', tags = {'stl'}}, packagemanager.filterFromVariant('win32-i386-vc100-release-stl'))
end

function suite.testVariant_win32_i386_vc110()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86'}, packagemanager.filterFromVariant('win32-i386-vc110'))
end

function suite.testVariant_win32_i386_vc110_xp_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc110_xp-debug-std'))
end

function suite.testVariant_win32_i386_vc110_xp_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc110_xp-release-std'))
end

function suite.testVariant_win32_i386_vc110_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('win32-i386-vc110-debug'))
end

function suite.testVariant_win32_i386_vc110_debug_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('win32-i386-vc110-debug-blz'))
end

function suite.testVariant_win32_i386_vc110_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc110-debug-mt'))
end

function suite.testVariant_win32_i386_vc110_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc110-debug-std'))
end

function suite.testVariant_win32_i386_vc110_release()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('win32-i386-vc110-release'))
end

function suite.testVariant_win32_i386_vc110_release_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('win32-i386-vc110-release-blz'))
end

function suite.testVariant_win32_i386_vc110_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc110-release-mt'))
end

function suite.testVariant_win32_i386_vc110_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc110-release-std'))
end

function suite.testVariant_win32_i386_vc120_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('win32-i386-vc120-debug'))
end

function suite.testVariant_win32_i386_vc120_debug_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('win32-i386-vc120-debug-blz'))
end

function suite.testVariant_win32_i386_vc120_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc120-debug-mt'))
end

function suite.testVariant_win32_i386_vc120_release()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('win32-i386-vc120-release'))
end

function suite.testVariant_win32_i386_vc120_release_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('win32-i386-vc120-release-blz'))
end

function suite.testVariant_win32_i386_vc120_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc120-release-mt'))
end

function suite.testVariant_win32_i386_vc140()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86'}, packagemanager.filterFromVariant('win32-i386-vc140'))
end

function suite.testVariant_win32_i386_vc140_xp_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc140_xp-debug-std'))
end

function suite.testVariant_win32_i386_vc140_xp_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-i386-vc140_xp-release-std'))
end

function suite.testVariant_win32_i386_vc140_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'debug'}, packagemanager.filterFromVariant('win32-i386-vc140-debug'))
end

function suite.testVariant_win32_i386_vc140_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc140-debug-mt'))
end

function suite.testVariant_win32_i386_vc140_release()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'release'}, packagemanager.filterFromVariant('win32-i386-vc140-release'))
end

function suite.testVariant_win32_i386_vc140_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-i386-vc140-release-mt'))
end

function suite.testVariant_win32_i386_x64_debug()
    isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-i386-x64-debug'))
end

function suite.testVariant_win32_i386_x64_release()
    isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-i386-x64-release'))
end

function suite.testVariant_win32_vc100()
    isTableEqual({system = 'windows', toolset = 'msc-v100'}, packagemanager.filterFromVariant('win32-vc100'))
end

function suite.testVariant_win32_vc110()
    isTableEqual({system = 'windows', toolset = 'msc-v110'}, packagemanager.filterFromVariant('win32-vc110'))
end

function suite.testVariant_win32_vc120()
    isTableEqual({system = 'windows', toolset = 'msc-v120'}, packagemanager.filterFromVariant('win32-vc120'))
end

function suite.testVariant_win32_vc140()
    isTableEqual({system = 'windows', toolset = 'msc-v140'}, packagemanager.filterFromVariant('win32-vc140'))
end

function suite.testVariant_win32_x64_vc100_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x64-vc100-debug'))
end

function suite.testVariant_win32_x64_vc100_release()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x64-vc100-release'))
end

function suite.testVariant_win32_x64_vc110_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x64-vc110-debug'))
end

function suite.testVariant_win32_x64_vc110_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-x64-vc110-debug-std'))
end

function suite.testVariant_win32_x64_vc110_release()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x64-vc110-release'))
end

function suite.testVariant_win32_x64_vc110_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-x64-vc110-release-std'))
end

function suite.testVariant_win32_x64_vc140_xp_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-x64-vc140_xp-debug-std'))
end

function suite.testVariant_win32_x64_vc140_xp_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc140_xp', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-x64-vc140_xp-release-std'))
end

function suite.testVariant_win32_x64_vc140_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x64-vc140-debug'))
end

function suite.testVariant_win32_x64_vc140_release()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x64-vc140-release'))
end

function suite.testVariant_win32_x86_64()
    isTableEqual({system = 'windows', architecture = 'x86_64'}, packagemanager.filterFromVariant('win32-x86_64'))
end

function suite.testVariant_win32_x86_64_anticheat()
    isTableEqual({system = 'windows', architecture = 'x86_64', tags = {'anticheat'}}, packagemanager.filterFromVariant('win32-x86_64-anticheat'))
end

function suite.testVariant_win32_x86_64_debug()
    isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x86_64-debug'))
end

function suite.testVariant_win32_x86_64_profile()
    isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'profile'}, packagemanager.filterFromVariant('win32-x86_64-profile'))
end

function suite.testVariant_win32_x86_64_release()
    isTableEqual({system = 'windows', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x86_64-release'))
end

function suite.testVariant_win32_x86_64_vc100()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64'}, packagemanager.filterFromVariant('win32-x86_64-vc100'))
end

function suite.testVariant_win32_x86_64_vc100_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x86_64-vc100-debug'))
end

function suite.testVariant_win32_x86_64_vc100_debug_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-debug-blz'))
end

function suite.testVariant_win32_x86_64_vc100_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc100_debug_static()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'static'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-debug-static'))
end

function suite.testVariant_win32_x86_64_vc100_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-debug-std'))
end

function suite.testVariant_win32_x86_64_vc100_debug_stl()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug', tags = {'stl'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-debug-stl'))
end

function suite.testVariant_win32_x86_64_vc100_release()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x86_64-vc100-release'))
end

function suite.testVariant_win32_x86_64_vc100_release_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-release-blz'))
end

function suite.testVariant_win32_x86_64_vc100_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-release-mt'))
end

function suite.testVariant_win32_x86_64_vc100_release_static()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'static'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-release-static'))
end

function suite.testVariant_win32_x86_64_vc100_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-release-std'))
end

function suite.testVariant_win32_x86_64_vc100_release_stl()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release', tags = {'stl'}}, packagemanager.filterFromVariant('win32-x86_64-vc100-release-stl'))
end

function suite.testVariant_win32_x86_64_vc110_xp_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-x86_64-vc110_xp-debug-std'))
end

function suite.testVariant_win32_x86_64_vc110_xp_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-vc110_xp', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-x86_64-vc110_xp-release-std'))
end

function suite.testVariant_win32_x86_64_vc110_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x86_64-vc110-debug'))
end

function suite.testVariant_win32_x86_64_vc110_debug_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('win32-x86_64-vc110-debug-blz'))
end

function suite.testVariant_win32_x86_64_vc110_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc110-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc110_debug_std()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug', tags = {'std'}}, packagemanager.filterFromVariant('win32-x86_64-vc110-debug-std'))
end

function suite.testVariant_win32_x86_64_vc110_release()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x86_64-vc110-release'))
end

function suite.testVariant_win32_x86_64_vc110_release_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('win32-x86_64-vc110-release-blz'))
end

function suite.testVariant_win32_x86_64_vc110_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc110-release-mt'))
end

function suite.testVariant_win32_x86_64_vc110_release_std()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release', tags = {'std'}}, packagemanager.filterFromVariant('win32-x86_64-vc110-release-std'))
end

function suite.testVariant_win32_x86_64_vc120_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x86_64-vc120-debug'))
end

function suite.testVariant_win32_x86_64_vc120_debug_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'debug', tags = {'blz'}}, packagemanager.filterFromVariant('win32-x86_64-vc120-debug-blz'))
end

function suite.testVariant_win32_x86_64_vc120_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc120-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc120_release()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x86_64-vc120-release'))
end

function suite.testVariant_win32_x86_64_vc120_release_blz()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'release', tags = {'blz'}}, packagemanager.filterFromVariant('win32-x86_64-vc120-release-blz'))
end

function suite.testVariant_win32_x86_64_vc120_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v120', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc120-release-mt'))
end

function suite.testVariant_win32_x86_64_vc140_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win32-x86_64-vc140-debug'))
end

function suite.testVariant_win32_x86_64_vc140_debug_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc140-debug-mt'))
end

function suite.testVariant_win32_x86_64_vc140_release()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win32-x86_64-vc140-release'))
end

function suite.testVariant_win32_x86_64_vc140_release_mt()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release', tags = {'mt'}}, packagemanager.filterFromVariant('win32-x86_64-vc140-release-mt'))
end

function suite.testVariant_win32_xi386_vc120_release()
    isTableEqual({system = 'windows', toolset = 'msc-v120', configurations = 'release', tags = {'xi386'}}, packagemanager.filterFromVariant('win32-xi386-vc120-release'))
end

function suite.testVariant_win64()
    isTableEqual({system = 'windows'}, packagemanager.filterFromVariant('win64'))
end

function suite.testVariant_win64_x64()
    isTableEqual({system = 'windows', architecture = 'x86_64'}, packagemanager.filterFromVariant('win64-x64'))
end

function suite.testVariant_win64_x64_vc100()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64'}, packagemanager.filterFromVariant('win64-x64-vc100'))
end

function suite.testVariant_win64_x64_vc100_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win64-x64-vc100-debug'))
end

function suite.testVariant_win64_x64_vc100_release()
    isTableEqual({system = 'windows', toolset = 'msc-v100', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win64-x64-vc100-release'))
end

function suite.testVariant_win64_x64_vc110()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64'}, packagemanager.filterFromVariant('win64-x64-vc110'))
end

function suite.testVariant_win64_x64_vc110_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win64-x64-vc110-debug'))
end

function suite.testVariant_win64_x64_vc110_release()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win64-x64-vc110-release'))
end

function suite.testVariant_win64_x64_vc140()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64'}, packagemanager.filterFromVariant('win64-x64-vc140'))
end

function suite.testVariant_wind32_i386()
    isTableEqual({architecture = 'x86', tags = {'wind32'}}, packagemanager.filterFromVariant('wind32-i386'))
end

function suite.testVariant_windows()
    isTableEqual({system = 'windows'}, packagemanager.filterFromVariant('windows'))
end

function suite.testVariant_win_x64_vc110_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win-x64-vc110-debug'))
end

function suite.testVariant_win_x64_vc110_release()
    isTableEqual({system = 'windows', toolset = 'msc-v110', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win-x64-vc110-release'))
end

function suite.testVariant_win_x64_vc140_debug()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'debug'}, packagemanager.filterFromVariant('win-x64-vc140-debug'))
end

function suite.testVariant_win_x64_vc140_release()
    isTableEqual({system = 'windows', toolset = 'msc-v140', architecture = 'x86_64', configurations = 'release'}, packagemanager.filterFromVariant('win-x64-vc140-release'))
end

function suite.testVariant_x64()
    isTableEqual({architecture = 'x86_64'}, packagemanager.filterFromVariant('x64'))
end

function suite.testVariant_x86_gcc48_android9()
    isTableEqual({toolset = 'gcc48', architecture = 'x86', tags = {'android9'}}, packagemanager.filterFromVariant('x86-gcc48-android9'))
end

-- Xbox

function suite.testVariant_xbox()
    isTableEqual({tags = {'xbox'}}, packagemanager.filterFromVariant('xbox'))
end

function suite.testVariant_xbox360()
    isTableEqual({system = 'xbox360'}, packagemanager.filterFromVariant('xbox360'))
end

function suite.testVariant_xbox360_debug()
    isTableEqual({system = 'xbox360', configurations = 'debug'}, packagemanager.filterFromVariant('xbox360-debug'))
end

function suite.testVariant_xbox360_release()
    isTableEqual({system = 'xbox360', configurations = 'release'}, packagemanager.filterFromVariant('xbox360-release'))
end

function suite.testVariant_xboxone_debug()
    isTableEqual({system = 'xboxone', configurations = 'debug'}, packagemanager.filterFromVariant('xboxone-debug'))
end

function suite.testVariant_xboxone_release()
    isTableEqual({system = 'xboxone', configurations = 'release'}, packagemanager.filterFromVariant('xboxone-release'))
end

function suite.testVariant_xboxone_vc110_debug()
    isTableEqual({system = 'xboxone', toolset = 'msc-v110', configurations = 'debug'}, packagemanager.filterFromVariant('xboxone-vc110-debug'))
end

function suite.testVariant_xboxone_vc110_release()
    isTableEqual({system = 'xboxone', toolset = 'msc-v110', configurations = 'release'}, packagemanager.filterFromVariant('xboxone-vc110-release'))
end

function suite.testVariant_xboxone_vc140_debug()
    isTableEqual({system = 'xboxone', toolset = 'msc-v140', configurations = 'debug'}, packagemanager.filterFromVariant('xboxone-vc140-debug'))
end

function suite.testVariant_xboxone_vc140_profile()
    isTableEqual({system = 'xboxone', toolset = 'msc-v140', configurations = 'profile'}, packagemanager.filterFromVariant('xboxone-vc140-profile'))
end

function suite.testVariant_xboxone_vc140_release()
    isTableEqual({system = 'xboxone', toolset = 'msc-v140', configurations = 'release'}, packagemanager.filterFromVariant('xboxone-vc140-release'))
end

-- Tags

function suite.testVariant_package()
    isTableEqual({tags = {'package'}}, packagemanager.filterFromVariant('package'))
end

function suite.testVariant_example()
    isTableEqual({tags = {'example'}}, packagemanager.filterFromVariant('example'))
end

function suite.testVariant_xnoarch()
    isTableEqual({tags = {'xnoarch'}}, packagemanager.filterFromVariant('xnoarch'))
end

function suite.testVariant_Release_1_0_5576_39384()
    isTableEqual({tags = {'Release.1.0.5576.39384'}}, packagemanager.filterFromVariant('Release.1.0.5576.39384'))
end

function suite.testVariant_cell_ppu()
    isTableEqual({tags = {'cell', 'ppu'}}, packagemanager.filterFromVariant('cell-ppu'))
end

function suite.testVariant_curl_7_50_3()
    isTableEqual({tags = {'curl', '7.50.3'}}, packagemanager.filterFromVariant('curl-7.50.3'))
end

-- Premake

function suite.testVariant_premake_generated_vs2015()
    isTableEqual({toolset = 'msc-v140', tags = {'premake', 'generated'}}, packagemanager.filterFromVariant('premake-generated-vs2015'))
end

-- Universal

function suite.testVariant_universal()
    isTableEqual({}, packagemanager.filterFromVariant('universal'))
end