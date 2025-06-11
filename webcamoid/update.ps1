function global:au_GetLatest {
    $github_repository = "webcamoid/webcamoid"
    $github_build_repository = "riedel/webcamoid-build-for-chocolatey"


    $github = global:github_vars($github_repository)

    $installer="installer/webcamoid-installer-windows-" + $github.release.tag_name + "-win64.exe"


    $buildrelease = Invoke-RestMethod ("https://api.github.com/repos/" + $github_build_repository + "/releases/tags/" + $github.release.tag_name)     



    @{
	readmeUrl  = $github.readme.download_url
        Version = $github.release.tag_name
    	NuspecVersion = $Global:PackageVersion
        packageSourceUrl   = 'https://github.com/' +  ( global:git_getRepo ) 
        projectSourceUrl = $github.source_url
        projectUrl = $github.repo.html_url
        bugTrackerUrl   = $github.repo.html_url  + '/issues'
        docsUrl    = $github.repo.html_url  + '/wiki'
       	iconUrl = $github.raw_url + '/StandAlone/share/themes/WebcamoidTheme/icons/hicolor/scalable/webcamoid.svg'
        githubRawUrl   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $github.release.tag_name 
        githubUrl   = 'https://github.com/' + $github_repository + '/tree/' + $github.release.tag_name 
        releaseNotes = $github.release.body 
        verification = $buildrelease.body 
        licenseHTMLUrl = $github.license.html_url 
        licenseUrl = $github.license.download_url 
        summary = $github.repo.description
        authors = $github.release_author.login 
	tags = $github.topics
    }

}


function global:au_SearchReplace {
@{
        ".\tools\chocolateyInstall.ps1" = @{
        }
}
}

function global:au_BeforeUpdateHook($package) {
    gh attestation verify $installer --owner riedel 
    if ($LASTEXITCODE -ne 0) { throw "github attestation failed with exit code $LASTEXITCODE" }

    $Latest.verification | Out-File -Encoding "UTF8" ($package.Path + "\tools\VERIFICATION.txt")
}

. "$PSScriptRoot\..\update_include.ps1"
