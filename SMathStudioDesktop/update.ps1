import-module au


#Source: https://www.reddit.com/user/midnightFreddie/ 
function Get-FixedQuerySelectorAll {
	param (
		[Parameter(ValueFromPipeline)]$HtmlWro,
		$CssSelector
	)
	# After assignment, $NodeList will crash powershell if enumerated in any way including Intellisense-completion while coding!
	if($HtmlWro.ParsedHtml)
	{
	    $NodeList = $HtmlWro.ParsedHtml.querySelectorAll($CssSelector)
	}
	else
	{
		$NodeList = $HtmlWro.querySelectorAll($CssSelector)
	}

	for ($i = 0; $i -lt $NodeList.length; $i++) {
		Write-Output $NodeList.item($i)
	}
}

function global:au_GetLatest {
	
    $package_repository= (git config remote.origin.url).split(":")[1].split(".")[0] 

	$homepage = "https://en.smath.com"
	$releases =  Invoke-WebRequest -Uri "$homepage/view/SMathStudio/history"

	$stable = Get-FixedQuerySelectorAll $releases "div.stable" 

	$file = Get-FixedQuerySelectorAll $stable[0] "span.file + a"
	$file[0].protocol="https"

	$stable[0].firstChild().firstChild().innerText -match '[0-9]*\.[0-9]*\.[0-9]*'
	$version = $Matches[0]
	

	return @{
		    readmeUrl  =  $homepage + "/view/SMathStudio/summary"
			URL32  = $file[0].href
			Version = $version
			releaseNotes = $stable[0].nextSibling().innerHtml
			Options = @{
				Headers = @{
				  referer = $homepage + "/view/SMathStudio/summary"
				}
			}
			packageSourceUrl   = 'https://github.com/' + $package_repository
	}

}

function global:au_BeforeUpdate($package) {
    $Latest.ChecksumType32 = 'sha256' # Not necessary, but just my preference to add it
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Algorithm $Latest.ChecksumType32 -Headers $Latest.Options.Headers # You can omit the algorithm, the function will use sha256 by default
	$package.NuspecXml.package.metadata.ChildNodes|ForEach-Object { $cn=$_ ; $cn.innerText|select-String '{([A-Za-z_]*)}' -AllMatches| % {$_.matches.groups} | where-object {$_.Name -eq 1} | % {$cn.InnerText = $cn.InnerText -replace ("{"+$_.Value+"}"),$Latest[$_.Value]}} 
}



function global:au_SearchReplace {
	@{
		".\tools\chocolateyInstall.ps1" = @{
			"(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
				"(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
		}
	}
}

function global:au_AfterUpdate($package) {

}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
	Get-ChildItem -Filter "*.in" -Recurse | Copy-Item -Destination {$_.name -replace '.in$','' }
	update -ChecksumFor none
}
