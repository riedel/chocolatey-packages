$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/zumoshi/BrowserSelect/releases/download/1.4.1/BrowserSelect.exe'
  checksum               = '42a8f7ea2f79106f24c6657891b1c940cd98961c469e280c768f6eb354d6e0bd'
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
