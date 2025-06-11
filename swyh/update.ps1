[CmdletBinding()]
param(
  [switch]$force
)

$global:force=!(!($force))

function global:au_GetLatest {
    $github_repository = "StreamWhatYouHear/SWYH"
    $github = global:github_vars($github_repository)


    @{
        URL32  = ($github.release.assets | where-object {$_.content_type -eq "application/x-msdownload" })[0].browser_download_url 
        Version = $github.release.tag_name
    	NuspecVersion = $Global:PackageVersion
        authors = $github.release_author.name 
        projectUrl   = $github.repo.homepage 
        bugTrackerUrl   = $github.repo.html_url  + '/issues'
        projectSourceUrl  = 'https://github.com/' + $github_repository + '/tree/' + $github.release.tag_name 
       	iconUrl = $github.raw_url + '/SWYH/Resources/Icons/swyh128.png'
        readmeUrl  = $github.readme.download_url
        summary = $github.repo.description 
	    tags = 'admin ' + $github.topics
        releaseNotes = ( $github.release.body -split "`n" | Select-Object -skip 2 ) -join "`r`n" 
        licenseUrl = $github.license.html_url 
        packageSourceUrl   = 'https://github.com/' + ( global:git_getRepo )
	    githubRawUrl= $github.raw_url
    }
}

. "$PSScriptRoot\..\update_include.ps1"