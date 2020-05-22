$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/StreamWhatYouHear/SWYH/releases/download/1.5.0/SWYH_1.5.0.exe'
  checksum               = '267F72FF5CCB056855574A1EB9B52D7916A3057B79F687CD5E1CC0C113BBE9CA'
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
