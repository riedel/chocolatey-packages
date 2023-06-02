$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'MSI'
  url                    = 'https://smath.com/file/KHggH/SMathStudioDesktop.1_0_8348.Setup.msi'
  checksum               = 'a470f0e666755788e7894f7d290183fe3cae91ba1508d3d2f1d2c7ed57dd647a'
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
