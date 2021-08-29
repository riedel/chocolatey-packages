$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'MSI'
  url                    = 'https://smath.com/file/ewBDg/SMathStudioDesktop.0_99_7822.Setup.msi'
  checksum               = 'e45bcc82edfb5b224178e8695c674dfdd363903f9d1765071404790e934915cd'
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
