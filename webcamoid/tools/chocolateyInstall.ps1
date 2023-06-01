$title = $Env:ChocolateyPackageName

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/webcamoid/webcamoid/releases/download/9.0.0/webcamoid-installer-windows-9.0.0-win32.exe'
  url64                    = 'https://github.com/webcamoid/webcamoid/releases/download/9.0.0/webcamoid-installer-windows-9.0.0-win64.exe'
  checksum               = '945cdbb56636997020c3d9fcc51456796d04f9d383b5b0393abe54208f1c7160'
  checksum64               = '615d73e343afc031682f877c73558243aba636fab67440afb368cbcef40e1904'
  checksumType           = 'sha256'
  silentArgs 		 = "/S"
  validExitCodes         = 0
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\bin\$packageName.exe"
Write-Host "$packageName registered as $packageName"
