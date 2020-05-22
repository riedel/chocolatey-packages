import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $github_repository = "StreamWhatYouHear/SWYH"
    "`n" + (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/StreamWhatYouHear/SWYH/master/README.md') | Set-Content  README.md 

    $package_repository= (git config remote.origin.url).split(":")[1].split(".")[0] 

    $repos_api = "https://api.github.com/repos/" + $github_repository 
    $repo = Invoke-WebRequest -Uri $repos_api | ConvertFrom-Json 

    $releases_api = "https://api.github.com/repos/" + $github_repository + "/releases/latest"     
    $releases = Invoke-WebRequest -Uri $releases_api | ConvertFrom-Json 

    $license_api = "https://api.github.com/repos/" + $github_repository + "/license"     
    $license = Invoke-WebRequest -Uri $license_api | ConvertFrom-Json 

    $topics_api = "https://api.github.com/repos/" + $github_repository + "/topics"     
    $topics=(Invoke-WebRequest -Headers @{'Accept' = 'application/vnd.github.mercy-preview+json'} -Uri $topics_api | ConvertFrom-Json).names -join " "

    $author = Invoke-WebRequest -Uri $releases.author.url | ConvertFrom-Json 

    $version = $releases.tag_name

    return @{
        Version = $version
        URL32   = 'https://github.com/' + $github_repository + '/releases/download/' + $version + '/SWYH_' + $version + '.exe'
        packageSourceUrl   = 'https://github.com/' + $package_repository
        projectSourceUrl   = 'https://github.com/' + $github_repository
        bugTrackerUrl   = 'https://github.com/' + $package_repository + '/issues'
        releaseNotes = 'https://github.com/' + $github_repository + '/releases/tag/' + $version + '/releaseNotes'
       	iconUrl = 'https://cdn.rawgit.com/' + $github_repository + '/' + $version +'/SWYH/Resources/Icons/swyh128.png'
        licenseUrl = $license.html_url 
        authors = $author.name 
        summary = $repo.description 
	tags = 'admin ' + $topics
    }
}


function global:au_SearchReplace {
@{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.releaseNotes)`$2"
            "(\>).*?(\</licenseUrl\>)" = "`${1}$($Latest.licenseUrl)`$2"
            "(\>).*?(\</iconUrl\>)" = "`${1}$($Latest.iconUrl)`$2"
            "(\>).*?(\</tags\>)" = "`${1}$($Latest.tags)`$2"
            "(\>).*?(\</authors\>)" = "`${1}$($Latest.authors)`$2"
            "(\>).*?(\</projectSourceUrl\>)" = "`${1}$($Latest.projectSourceUrl)`$2"
            "(\>).*?(\</packageSourceUrl\>)" = "`${1}$($Latest.packageSourceUrl)`$2"
            "(\>).*?(\</bugTrackerUrl\>)" = "`${1}$($Latest.bugTrackerUrl)`$2"
            "(\>).*?(\</summary\>)" = "`${1}$($Latest.summary)`$2"
        }

}
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update -ChecksumFor none
}

