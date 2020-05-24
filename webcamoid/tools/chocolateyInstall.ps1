$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/webcamoid/webcamoid/releases/download/8.7.1/webcamoid-8.7.1-win32.exe'
  url64                    = 'https://github.com/webcamoid/webcamoid/releases/download/8.7.1/webcamoid-8.7.1-win64.exe'
  checksum               = '84f6fb46446e8c6ced33899070655b7de089b47ca5412db84c8913a9e3ac2bce'
  checksum64               = '0ec1b61ca7d658d0111789bcc666f4821d19411e61c633a2c24d5d2108168d8f'
  checksumType           = 'sha256'
  silentArgs 		 = "--script $Env:ChocolateyPackageFolder/tools/silentInstall.js"
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\bin\$packageName.exe"
Write-Host "$packageName registered as $packageName"
