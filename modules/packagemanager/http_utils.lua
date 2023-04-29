local p = premake

-- Make an html request
function http_get(url, auth, context)
    authHeader = ''
    if auth then
        authHeader = 'Authorization: token ' .. auth
    end

    local result, result_str, result_code = http.get(url, {
         progress = iif(_OPTIONS.verbose, http.reportProgress, nil),
         headers = { iif(auth, 'Authorization: token ' .. auth, '') }
         })

    if not result then
        p.error('%s retrieval of %s failed (%d)\n%s', context, url, result_code, result_str)
    end

    return result
end

-- Download from an http address
function http_download(url, destination, auth, context)
    print(' * DOWNLOAD: ' .. url)

    authHeader = ''
    if auth then
        authHeader = 'Authorization: token ' .. auth
    end

    local result_str, result_code = http.download(url, destination, {
         progress = iif(_OPTIONS.verbose, http.reportProgress, nil), 
         headers = { 'Accept: application/zip', authHeader }
         })

    if result_str ~= "OK" then
        os.remove(destination)

        p.error('%s retrieval of %s failed (%d)\n%s', context, url, result_code, result_str)
    end
end

-- The github api url
local function __git_api()
    return 'https://github.com/'
end

-- Make a github branch url
function makeBranchGitHubURL(organization, repository, branch)
    return path.join(__git_api(), organization, repository, 'archive/refs/heads', branch .. '.zip')
end

-- Make a github release url
function makeReleaseGitHubURL(organization, repository, version)
    return path.join(__git_api(), organization, repository, 'archive/refs/tags', version .. '.zip')
end