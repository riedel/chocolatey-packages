[CmdletBinding()]
param(
  [switch]$force
)

$global:force=( $true -or !(!($force)) )

function global:au_GetLatest {
    $github_repository = "kopia/kopia"
    $github = global:github_vars($github_repository)
    $url = ($github.release.assets | `
	           where-object {
			   $_.content_type.StartsWith("application/x-ms") 
			   }
                  )[0].browser_download_url
    @{
	    URL32 = $url
        readmeUrl  = $github.readme.download_url
        Version = $github.release.tag_name.substring(1)
    	NuspecVersion = $Global:PackageVersion
        packageSourceUrl   = 'https://github.com/' + ( global:git_getRepo )
        projectUrl   = $github.repo.homepage 
        projectSourceUrl   = $github.repo.html_url 
        githubRawUrl   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $github.release.tag_name 
        githubUrl   = 'https://github.com/' + $github_repository + '/tree/' + $github.release.tag_name 
        releaseNotes = $github.release.body 
        licenseUrl = $github.license.html_url 
        summary = $github.repo.description 
        authors = $github.release_author.name 
	tags = 'admin ' + $github.topics
       	iconPath = 'icons/kopia.svg'
    }
}

function global:au_BeforeUpdateHook($package) {
    $readme = ((Invoke-WebRequest -Uri $Latest.readmeUrl).Content) -replace '\]\(([\w\./]+)\)',('](' + $Latest.githubRawUrl + '/$1)') 
    $readme.substring(0, $readme.indexOf('Pick the Cloud')) | Out-File -Encoding "UTF8" ($package.Path + "\README.md")
}

. "$PSScriptRoot\..\update.ps1"