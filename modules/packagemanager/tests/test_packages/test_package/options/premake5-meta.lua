return {
    includedirs = { 'include' },
    links       = { 'test_package' },

    options     = {
        ['multithreading'] = { kind = 'boolean', default = 'off', define='ENABLE_MULTITHREADING' },
        ['stacksize']      = { kind = 'integer', default = 1024, define='STACK_SIZE' },
        ['folder']         = { kind = 'path' }
    },

    premake     = 'options.lua'
}
