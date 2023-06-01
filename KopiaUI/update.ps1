import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $github_repository = "kopia/kopia"

    $package_repository= (git config remote.origin.url).split(":")[1].split(".")[0] 

    $repo = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository)

    $release = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/releases/latest")     

    $license = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/license")     

    $readme = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/readme")     

    $topics=(Invoke-RestMethod -Headers @{'Accept' = 'application/vnd.github.mercy-preview+json'} ("https://api.github.com/repos/" + $github_repository + "/topics")).names -join " "

    $release_author = Invoke-RestMethod $release.author.url

    $url32=($release.assets | where-object {$_.content_type -eq "application/x-ms-dos-executable" })[0].browser_download_url 

    $ret=@{
	    readmeUrl  = $readme.download_url
        URL32   = $url32
        Version = $release.tag_name.substring(1)
        packageSourceUrl   = 'https://github.com/' + $package_repository
        projectUrl   = $repo.homepage 
        projectSourceUrl   = $repo.html_url 
        githubRawUrl   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $release.tag_name 
        githubUrl   = 'https://github.com/' + $github_repository + '/tree/' + $release.tag_name 
        releaseNotes = $release.body 
        licenseUrl = $license.html_url 
        summary = $repo.description 
        authors = $release_author.name 
	    tags = 'admin ' + $topics
       	iconPath = 'icons/kopia.svg'
    }
    return $ret
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
    $readme = ((Invoke-WebRequest -Uri $Latest.readmeUrl).Content) -replace '\]\(([\w\./]+)\)',('](' + $Latest.githubRawUrl + '/$1)') 
    $readme.substring(0, $readme.indexOf('Pick the Cloud')) | Out-File -Encoding "UTF8" ($package.Path + "\README.md")

    $package.NuspecXml.package.metadata.ChildNodes|% { $cn=$_ ; $cn.innerText|select-String '{([A-Za-z_]*)}' -AllMatches| % {$_.matches.groups} | where-object {$_.Name -eq 1} | % {$cn.InnerText = $cn.InnerText -replace ("{"+$_.Value+"}"),$Latest[$_.Value]}} 
}

function global:au_AfterUpdate($package) {
    rm ($package.Path + "\README.md")
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    Get-ChildItem -Filter "*.in" -Recurse | Copy-Item -Destination {$_.name -replace '.in$','' }
    update
}
update
