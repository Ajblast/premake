local p = premake
local packagemanager = p.modules.packagemanager

local project = p.project

local import_filter = {}

-- Return an iterator function of a tabled sorted
local function sortedpairs(t)
    -- Collect all the keys for entries that are not numbers.
    -- and store the values for entries that are numbers.
    local keys = {}
    local values = {}
    for k, v in pairs(t) do
        if tonumber(k) ~= nil then
            table.insert(values, v)
        else
            table.insert(keys, k)
        end
    end

    -- Sort the keys.
    table.sort(keys)

    -- Return the iterator function
    local i = 0
    local n = #values
    return function()
        i = i + 1
        if (i <= n) then
            return values[i], nil
        else
            local k = keys[i-n]
            if k then
                return k, t[k]
            end
        end
    end
end

-- Insert each value into a table and associate a key with it
local function insertkeyed(tbl, values)
    for _, value in ipairs(values) do
        table.insertkeyed(tbl, value)
    end
end

local function __matchLink(filename, match)
    if type(match) == 'function' then
        return match(filename)
    end
    return string.match(filename, match)
end

-- Filter to link only those libs that are mentioned.
local function __createFilter(t)
    if t then
        return function(l)
            local matches = {}
            local nonmatches = {}
            local all_index = nil

            for k, link in ipairs(l) do
                local filename = path.getname(link)
                for index, match in ipairs(t) do
                    if match == '*' then
                        all_index = index
                    elseif __matchLink(filename, match) then
                        if matches[index] then
                            table.insert(matches[index], link)
                        else
                            matches[index] = { link }
                        end
                        break
                    else
                        table.insert(nonmatches, link)
                    end
                end
            end

            if all_index then
                matches[all_index] = nonmatches
            end

            local linres = {}

            for key, val in ipairs(matches) do
                if t[key] == '*' then
                    table.insertflat(linres, val)
                elseif #val > 0 then
                    table.insert(linres, val[1])
                end
            end

            return linres;
        end
    else
        return function(l)
            return l
        end
    end
end

--- Gets the default import filter
local function __defaultImportFilter(name)
    if import_filter[name] then
        return import_filter[name]
    end
    return nil
end

-- Add or move a value to the bottom of the list
local function addOrMoveToBottom(tbl, values)
    for _, value in ipairs(values) do
        if not table.insertkeyed(tbl, value) then
            local idx = table.indexof(tbl, value)
            table.remove(tbl, idx)
            table.insert(tbl, value)
        end
    end
end

-- Get a package from the package manager and check its dependencies
local function getpackage(ctx, wks, name)
    local result = p.packagemanager.getPackage(name)
    if not result then
        local prjname = iif(ctx.project, ctx.project.name, ctx.name)
        p.error("Package '" .. name .. "' was not imported, but the project '" .. prjname .. "' has a dependency on it.")
    end
    return result
end

-- Solve include dependencies
local function recursiveIncludeDependencies(ctx, dependencies)
    -- For each dependency
    for name, _ in sortedpairs(dependencies) do
        -- Get that package
        local pkg = getpackage(ctx, ctx.workspace, name)

        -- Get the package includes, defines, and depends
        insertkeyed(ctx.includedirs, pkg.auto_includes(ctx))
        insertkeyed(ctx.defines,     pkg.auto_defines(ctx))
        insertkeyed(ctx.dependson,   pkg.auto_dependson(ctx))

        -- Iterate over the packages own include dependencies
        recursiveIncludeDependencies(ctx, pkg.auto_includedependencies(ctx))
    end
end

-- Solve link dependencies
local function recursiveLinkDependencies(ctx, dependencies)
    -- For each dependency
    for name, value in sortedpairs(dependencies) do
        local filter = nil
        if type(value) == 'table' then
            filter = __createFilter(value)
        else
            filter = __createFilter(__defaultImportFilter(name))
        end

        local pkg = getpackage(ctx, ctx.workspace, name)

        -- Add the links to the bottom of the links list
        -- Links have to be in order
        addOrMoveToBottom(ctx.links, filter(pkg.auto_links(ctx)))

        -- Get library directories to link with
        insertkeyed(ctx.libdirs, pkg.auto_libdirs(ctx))
        recursiveLinkDependencies(ctx, pkg.auto_linkdependencies(ctx))
    end
end

local function __resolvePackages(ctx)
    if ctx.packages_resolved then
        return
    end

    -- Resolve package includes and defines
    if ctx.includedependencies then
        verbosef("Resolve include dependencies")
        recursiveIncludeDependencies(ctx, ctx.includedependencies)
    end

    -- Resolve package package bin path
    if ctx.bindirdependencies then
        verbosef("Resolve bin dependencies")

        -- Add bin dir dependencies
        for name, _ in sortedpairs(ctx.bindirdependencies) do
            local pkg = getpackage(ctx, ctx.workspace, name)
            insertkeyed(ctx.bindirs, pkg.auto_bindirs(ctx))
        end
    end

    -- Resolve package includes.
    if ctx.copybindependencies then
        verbosef("Resolve includes")

        -- Get target directory
        local seperator = package.config:sub(1,1)
        local info = premake.config.gettargetinfo(ctx)
        local targetDir = ctx.copybintarget or info.directory

        -- For each bin dependency
        for name, value in sortedpairs(ctx.copybindependencies) do
            -- Get the package bin dirs
            local pkg = getpackage(ctx, ctx.workspace, name)
            for _, dir in ipairs(pkg.auto_bindirs(ctx)) do
                local src = project.getrelative(ctx.project, dir)
                local dst = project.getrelative(ctx.project, targetDir)

                -- Add command to copy the items
                local command = string.format('{COPY} "%s" "%s"',
                    path.translate(src, seperator),
                    path.translate(dst, seperator))

                table.insert(ctx.postbuildcommands, command)
            end
        end
    end

    -- Don't allow static libraries to have links
    if ctx.links and next(ctx.links) and ctx.kind == p.STATICLIB then
        local prjname = iif(ctx.project, ctx.project.name, ctx.name)
        p.warnOnce(prjname..'l', "The project '" .. prjname .. "' is a static library, but uses 'links', for buildorder use 'dependson'.")
    end

    -- Resolve package links.
    if ctx.linkdependencies and next(ctx.linkdependencies) then
        verbosef("Resolve Link Dependencies")

        -- Static libraries cannot have link dependencies
        if ctx.kind == p.STATICLIB then
            local prjname = iif(ctx.project, ctx.project.name, ctx.name)
            p.warnOnce(prjname..'d', "The project '" .. prjname .. "' is a static library, but uses 'use/linkdependencies'.")
        end

        recursiveLinkDependencies(ctx, ctx.linkdependencies)
    end

    ctx.packages_resolved = true
end

-- Inject the package resolver
p.override(p.oven, 'bake', function(base)
    -- Run base first
    base()

    -- Resolve package dependencies
    print("Resolving Packages")
    verbosef("Package Cache Location: %s", packagemanager.getCacheLocation())

    for wks in p.global.eachWorkspace() do
        verbosef("Resolve workspace: %s", wks.name)

        for prj in p.workspace.eachproject(wks) do
            if not prj.external then
                verbosef("\nResolving: '%s'", prj.name)

                -- xcode is special
                if _ACTION == 'xcode' then
                    if not cfg then
                        cfg = prj
                    end
                    __resolvePackages(prj)
                end

                for cfg in project.eachconfig(prj) do
                    __resolvePackages(cfg)
                end
            end
        end
    end

    print("\nResolved Packages\n")

    -- Write package metadata.
    print('Generate Package Manifests')
    for wks in p.global.eachWorkspace() do
        -- Generate the workspace manifests
        local mantbl = packagemanager.generateManifest(wks)

        -- Encode the table
        local manifest, err = json.encode_pretty(mantbl)
        if manifest == nil then
            p.error(err)
        end

        -- Output the manifest
        if #manifest > 2 then
            p.generate(wks, ".pmanifest", function()
                p.utf8()
                p.outln(manifest)
            end)
        end
    end

    -- Force a lua garbage collect
    collectgarbage()
end)

-- Import lib filter for a set of packages.
function importlibfilter(table)
    if not table then
        return nil
    end

    -- import packages.
    for name, filter in pairs(table) do
        if not import_filter[name:lower()] then
            import_filter[name:lower()] = filter
        end
    end
end
