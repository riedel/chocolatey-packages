$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/StreamWhatYouHear/SWYH/releases/download/1.5.0/SWYH_1.5.0.exe'
  checksum               = '267f72ff5ccb056855574a1eb9b52d7916a3057b79f687cd5e1cc0c113bbe9ca'
  checksumType           = 'sha256'
  silentArgs 		 = '/NORESTART /VERYSILENT /SUPPRESSMSGBOXES'
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"
