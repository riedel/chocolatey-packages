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

	$homepage = "https://smath.com/en-US"
	$releases =  Invoke-WebRequest -Uri "$homepage/view/SMathStudio/history"

	$stable = Get-FixedQuerySelectorAll $releases "div.stable" 

	$link = Get-FixedQuerySelectorAll $stable[0] "a[itemprop='downloadUrl']"
	$link.protocol="https"
	$link.host="smath.com"
	

	$stable[0].firstChild().firstChild().innerText -match '[0-9]*\.[0-9]*\.[0-9]*\.?[0-9]*'
	$version = $Matches[0]

	$releaseNotes = $stable[0].nextSibling().innerHtml|pandoc -f html -t markdown | Out-String

	$release =  Invoke-WebRequest -Uri $link.href

	$windows = Get-FixedQuerySelectorAll $release "div.platform-type" 

	$link = Get-FixedQuerySelectorAll $windows[0] "a"
	$link.protocol="https"
	$link.host="smath.com"

	


	return @{
		    readmeUrl  =  $homepage + "/view/SMathStudio/summary"
			URL32  = $link.href
			Version = $version
			releaseNotes = $releaseNotes
			Options = @{
				Headers = @{
				  referer = $homepage + "/view/SMathStudio/summary"
				}
			}
			packageSourceUrl   = 'https://github.com/' + $package_repository
	}

}

function global:au_BeforeUpdateHook($package) {
    $Latest.ChecksumType32 = 'sha256' # Not necessary, but just my preference to add it
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Algorithm $Latest.ChecksumType32 -Headers $Latest.Options.Headers # You can omit the algorithm, the function will use sha256 by default
}

. "$PSScriptRoot\..\update_include.ps1"




