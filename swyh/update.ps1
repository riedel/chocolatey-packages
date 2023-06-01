import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $github_repository = "StreamWhatYouHear/SWYH"

    $package_repository= (git config remote.origin.url).split(":")[1].split(".")[0] 

    $repo = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository)

    $release = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/releases/latest")     

    $license = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/license")     

    $readme = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/readme")     


    $topics=(Invoke-RestMethod -Headers @{'Accept' = 'application/vnd.github.mercy-preview+json'} ("https://api.github.com/repos/" + $github_repository + "/topics")).names -join " "

    $release_author = Invoke-RestMethod $release.author.url



    return @{
	readmeUrl  = $readme.download_url
        URL32   = ($release.assets | where-object {$_.content_type -eq "application/x-msdownload" })[0].browser_download_url 
        Version = $release.tag_name
        packageSourceUrl   = 'https://github.com/' + $package_repository
        projectSourceUrl   = $repo.html_url 
        projectUrl   = $repo.homepage 
        bugTrackerUrl   = 'https://github.com/' + $package_repository + '/issues'
        releaseNotes = $release.html_url 
        licenseUrl = $license.html_url 
        summary = $repo.description 
        authors = $release_author.name 
	tags = 'admin ' + $topics
       	iconUrl = 'https://cdn.rawgit.com/' + $github_repository + '/' + $release.tag_name +'/SWYH/Resources/Icons/swyh128.png'
    }

}


function global:au_SearchReplace {
@{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
        }
}
}

function global:au_BeforeUpdate($package) {
    "`n" + (Invoke-WebRequest -Uri $Latest.readmeUrl).Content | Out-File -Encoding "UTF8" ($package.Path + "\README.md")

    $Latest.Keys | % {
        if ($package.NuspecXml.package.metadata."$_") {
            $package.NuspecXml.package.metadata."$_" = $Latest.Item($_)
        }
    }

}

function global:au_AfterUpdate($package) {
    rm ($package.Path + "\README.md")
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update
}
