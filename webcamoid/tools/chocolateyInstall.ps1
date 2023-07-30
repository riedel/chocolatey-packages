$title = $Env:ChocolateyPackageName

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/webcamoid/webcamoid/releases/download/9.1.1/webcamoid-installer-windows-9.1.1-win32.exe'
  url64                    = 'https://github.com/webcamoid/webcamoid/releases/download/9.1.1/webcamoid-installer-windows-9.1.1-win64.exe'
  checksum               = 'b55a175e32edc4f31ca58050bfecd168ef7447ed27e6ecb94027e1605fb23476'
  checksum64               = 'd9d36a67d3320f217059f1c3775fe9e2e434080c93e6db9cbac73763fe7aeb63'
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
