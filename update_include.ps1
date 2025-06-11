import-module au

function global:github_vars($github_repository) {
	$release = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/releases/latest")     
	@{
    	repo = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository)
		release = $release
    	license = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/license")     
		topics=(Invoke-RestMethod -Headers @{'Accept' = 'application/vnd.github.mercy-preview+json'} ("https://api.github.com/repos/" + $github_repository + "/topics")).names -join " "
		readme = Invoke-RestMethod ("https://api.github.com/repos/" + $github_repository + "/readme")     
		release_author = Invoke-RestMethod $release.author.url
        raw_url   = 'https://raw.githubusercontent.com/' + $github_repository + '/' + $release.tag_name 
        source_url  = 'https://github.com/' + $github_repository + '/tree/' + $github.release.tag_name 
	}
}

function global:git_getRepo ($package) {
    (git config remote.origin.url).split(":")[1].split(".")[0] 
}

function global:au_SearchReplace {

	if ($Latest.containsKey("URL32") -and -not $Latest.containsKey("Checksum32")) {

		$Latest.ChecksumType32 = 'sha256'
		$Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Algorithm $Latest.ChecksumType32 -Headers $Latest.Options.Headers
	}

	if ($Latest.containsKey("URL32")) {
		@{
			".\tools\chocolateyInstall.ps1" = @{
				"(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
				"(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
				"(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
			}
		}
	}else{
		@{
		}
	}
}

function global:au_BeforeUpdate ($package) {
  if (  (Test-Path "pandoc.lua") -and `
	($Latest.containsKey("readmeUrl"))
     ) {
    "`n" + (Invoke-WebRequest -Uri $Latest.readmeUrl).Content | `
       pandoc -f gfm -t gfm-raw_html --lua-filter=filter.lua | `
       Out-File -Encoding "UTF8" ($package.Path + "\README.md")
  }

  if ($Latest.PSObject.Properties.Name -contains "licenseUrl") {
    "`n" + (Invoke-WebRequest -Uri $Latest.licenseUrl).Content |  Out-File -Encoding "UTF8" ($package.Path + "\tools\LICENSE.txt")
  }

  if (Get-Command -Scope Global -Name au_BeforeUpdateHook -ErrorAction SilentlyContinue) {
    global:au_BeforeUpdateHook ($package)
  }

  $package.NuspecXml.package.metadata.ChildNodes | ForEach-Object {
    $nodeName = $_.Name
    if ($Latest.ContainsKey($nodeName)) {
      $_.innerText = $Latest[$nodeName]
    }
  }
   return global:au_BeforeUpdateHook ($package)
}

function global:au_AfterUpdate ($package) {
  if (Get-Command -Scope Global -Name au_AfterUpdateHook -ErrorAction SilentlyContinue) {
    return global:au_AfterUpdateHook ($package)
  }
}

if ( $MyInvocation.PSCommandPath -like "*update.ps1") { # run the update only if script is not sourced
#$Global:PackageVersion = ([xml](Get-Content .\*.nuspec)).package.metadata.version
#Get-ChildItem -Filter "*.nuspec" -Recurse | Copy-Item -Destination { $_.Name -replace '.nuspec$','.nuspec.bak' }
	Set-Location (Split-Path $MyInvocation.PSCommandPath)
	$package = update -ChecksumFor:none -NoCheckChocoVersion:$global:force -Force:$global:force
	$package
#if (!$package.updated)
#{
#  Get-ChildItem -Filter "*.nuspec.bak" -Recurse | Copy-Item -Destination { $_.Name -replace '.nuspec.bak$','.nuspec' }
#}
}
