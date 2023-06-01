$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'MSI'
  url                    = 'https://smath.com/file/gFxHG/SMathStudioDesktop.1_0_8253.Setup.msi'
  checksum               = '53512fb151f6774f8453ca119baac09c3f8f977d8c435c7b09da3dd642b601d0'
  checksumType           = 'sha256'
  silentArgs 		 = '/quiet /qn /norestart'
  validExitCodes         = @(0)
  Options = @{
    Headers = @{
      referer = "https://en.smath.com/view/SMathStudio/summary"
    }
  }
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"
