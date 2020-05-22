import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $github_repository = "StreamWhatYouHear/SWYH"
    $releases = "https://github.com/" + $github_repository + "/releases/latest"    
    $regex    = '/StreamWhatYouHear/SWYH/tree/(?<Version>[\d\.]+)'

    $download_page = (Invoke-WebRequest -Uri $releases).RawContent -match $regex
    $version = $matches.Version

    return @{
        Version = $version
        URL32   = 'https://github.com/' + $github_repository + '/releases/download/' + $version + '/SWYH_' + $version + '.exe'
        releaseNotes = 'https://github.com/' + $github_repository + '/releases/tag/' + $version + '/releaseNotes'
       	iconUrl = 'https://cdn.rawgit.com/' + $github_repository + '/' + $version +'/SWYH/Resources/Icons/swyh128.png'
        licenseUrl = 'https://rawcdn.githack.com/' + $github_repository + '/'+ $version + '/LICENSE'
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
            "(\<licenseUrl\>).*?(\</licenseUrl\>)" = "`${1}$($Latest.licenseUrl)`$2"
            "(\<iconUrl\>).*?(\</iconUrl\>)" = "`${1}$($Latest.iconUrl)`$2"
        }

}
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update -ChecksumFor none
}

