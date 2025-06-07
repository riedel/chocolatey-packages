[CmdletBinding()]
param(
  [switch]$force
)

$global:force=( $true -or !(!($force)) )

function global:au_GetLatest {
    $github_repository = "kopia/kopia"
    $github = global:github_vars($github_repository)
    $latest_url = ($github.release.assets | `
	           where-object {
			   $_.name -eq "latest.yml" 
			   }
                  )[0].browser_download_url
    $latest =  ([System.Text.Encoding]::UTF8).GetString((Invoke-WebRequest $latest_url -UseBasicParsing).Content) | ConvertFrom-Yaml

    $url = ($github.release.assets | `
	           where-object {
			   $_.name -eq $latest.files[0].url 
			   }
                  )[0].browser_download_url

    @{
	    URL32 = $url
        ChecksumType32 = "sha512"
        Checksum32= ([System.Convert]::FromBase64String($latest.files[0].sha512) | ForEach-Object { "{0:X2}" -f $_ }) -join ""
        readmeUrl  = $github.readme.download_url
        Version = $github.release.tag_name.substring(1)
    	NuspecVersion = $Global:PackageVersion
        packageSourceUrl   = 'https://github.com/' + ( global:git_getRepo )
        projectUrl   = $github.repo.homepage 
        projectSourceUrl   = $github.repo.html_url 
        githubRawUrl   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $github.release.tag_name 
        githubUrl   = 'https://github.com/' + $github_repository + '/tree/' + $github.release.tag_name 
        releaseNotes = ( $github.release.body -split "`n" | Select-Object -skip 2 ) -join "`r`n" 
        licenseUrl = $github.license.html_url 
        summary = $github.repo.description 
        authors = $github.release_author.name 
	    tags = 'admin ' + $github.topics
       	iconPath = 'icons/kopia.svg'
    }
}

function global:au_BeforeUpdateHook($package) {
    $readme = ((Invoke-WebRequest -Uri $Latest.readmeUrl).Content) -replace '\]\(([\w\./]+)\)',('](' + $Latest.githubRawUrl + '/$1)') 
    $readme.substring(0, $readme.indexOf('When ready')) | Out-File -Encoding "UTF8" ($package.Path + "\README.md")
}

. "$PSScriptRoot\..\update.ps1"