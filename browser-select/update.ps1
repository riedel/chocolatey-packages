[CmdletBinding()]
param(
  [switch]$force
)

$global:force=!(!($force))


function global:au_GetLatest {
    $github_repository = "zumoshi/BrowserSelect"
    $github = global:github_vars($github_repository)

    return @{
        URL32           = ($github.release.assets | where-object {$_.content_type -eq "application/x-msdownload" })[0].browser_download_url 
        Version         = $github.release.tag_name
    	NuspecVersion   = $Global:PackageVersion
        authors         = $github.release_author.name 
	readmeUrl       = $github.readme.download_url
        projectUrl      = $github.repo.html_url
        bugTrackerUrl   = $github.repo.html_url  + '/issues'
        packageSourceUrl = 'https://github.com/' + ( global:git_getRepo )
        projectSourceUrl = $github.source_url
        releaseNotes    = $github.release.body 
        licenseUrl      = $github.license.html_url 
        summary         = $github.repo.description 
    	tags            = 'admin ' + $github.topics
       	iconUrl         = $github.raw_url + '/BrowserSelect/bs.ico'
        docsUrl         = $github.source_url  + '/help/filters.md'
    }

}

. "$PSScriptRoot\..\update_include.ps1"
