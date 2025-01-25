function global:au_GetLatest {
    $github_repository = "webcamoid/webcamoid"
    $github_build_repository = "riedel/webcamoid-build-for-chocolatey"

    $github = global:github_vars($github_repository)

    $buildrelease = Invoke-RestMethod ("https://api.github.com/repos/" + $github_build_repository + "/releases/tags/" + $github.release.tag_name)     

    @{
	    readmeUrl  = $github.readme.download_url
        Version = $github.release.tag_name
    	NuspecVersion = $Global:PackageVersion
        packageSourceUrl   = 'https://github.com/' +  ( global:git_getRepo ) 
        projectUrl = $github.repo.homepage 
        projectSourceUrl   = $github.repo.html_url 
        githubRawUrl   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $github.release.tag_name 
        githubUrl   = 'https://github.com/' + $github_repository + '/tree/' + $github.release.tag_name 
        releaseNotes = $github.release.body 
        verification = $buildrelease.body 
        licenseHTMLUrl = $github.license.html_url 
        licenseUrl = $github.license.download_url 
        summary = $github.repo.description
        authors = $github.release_author.name 
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
    $Latest.verification | Out-File -Encoding "UTF8" ($package.Path + "\tools\VERIFICATION.txt")
}

. "$PSScriptRoot\..\update.ps1"
