[CmdletBinding()]
param(
  [switch]$force
)

import-module au

function global:au_GetLatest {
    $github_repository = "webcamoid/webcamoid"
    $github_build_repository = "riedel/webcamoid-build-for-chocolatey"

    $package_repository= (git config remote.origin.url).split(":")[1].split(".")[0] 

    $repo = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository)


    $release = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/releases/latest")     


    $buildrelease = Invoke-RestMethod ("https://api.github.com/repos/" + $github_build_repository + "/releases/tags/" + $release.tag_name)     



    $license = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/license")     


    $readme = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/readme")     


   $topics=(Invoke-RestMethod -Headers @{'Accept' = 'application/vnd.github.mercy-preview+json'} ("https://api.github.com/repos/" + $github_repository + "/topics")).names -join " "


   $release_author = Invoke-RestMethod $release.author.url


     @{
	readmeUrl  = $readme.download_url
        Version = $release.tag_name
        packageSourceUrl   = 'https://github.com/' + $package_repository
        projectUrl = $repo.homepage 
        projectSourceUrl   = $repo.html_url 
        githubRawUrl   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $release.tag_name 
        githubUrl   = 'https://github.com/' + $github_repository + '/tree/' + $release.tag_name 
        releaseNotes = $release.body 
        verification = $buildrelease.body 
        licenseUrl = $license.html_url 
        license = $license.download_url 
        summary = $repo.description
        authors = $release_author.name 
	tags = $topics
    }

}


function global:au_SearchReplace {
@{
        ".\tools\chocolateyInstall.ps1" = @{
        }
}
}

function global:au_BeforeUpdate($package) {
    "`n" + (Invoke-WebRequest -Uri $Latest.readmeUrl).Content |pandoc -f gfm -t gfm-raw_html --lua-filter=filter.lua |  Out-File -Encoding "UTF8" ($package.Path + "\README.md")
    "`n" + (Invoke-WebRequest -Uri $Latest.license).Content |  Out-File -Encoding "UTF8" ($package.Path + "\tools\LICENSE.txt")
    $Latest.verification | Out-File -Encoding "UTF8" ($package.Path + "\tools\VERIFICATION.txt")

$package.NuspecXml.package.metadata.ChildNodes|% { $cn=$_ ; $cn.innerText|select-String '{([A-Za-z_]*)}' -AllMatches| % {$_.matches.groups} | where-object {$_.Name -eq 1} | % {$cn.InnerText = $cn.InnerText -replace ("{"+$_.Value+"}"),$Latest[$_.Value]}} 
}

function global:au_AfterUpdate($package) {
    rm ($package.Path + "\README.md")
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    Get-ChildItem -Filter "*.in" -Recurse | Copy-Item -Destination {$_.name -replace '.in$','' }
    update -ChecksumFor:none -NoCheckChocoVersion:$force 
}
