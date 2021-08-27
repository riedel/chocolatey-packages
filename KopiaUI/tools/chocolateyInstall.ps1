$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/kopia/kopia/releases/download/v0.8.4/KopiaUI-Setup-0.8.4.exe'
  checksum               = '67764e0786a2c0aa4ca218d980ac3e9fc1dcc166de1c802ff84fca8a1910323b'
  checksumType           = 'sha256'
  silentArgs 		 = '/S'
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"
