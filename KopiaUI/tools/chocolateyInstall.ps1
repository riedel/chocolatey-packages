$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/kopia/kopia/releases/download/v0.22.2/KopiaUI-Setup-0.22.2.exe'
  checksum               = '90B622019DDC4CC4A857A375EBD6AB8E71405C811AB5A88485CBC3EB16BA3973BB364FD6EEB02B6416EC8171333BBC5EB2BDA8F37BFC646BD25F9748D24642B4'
  checksumType           = 'sha512'
  silentArgs 		 = '/S /allusers /disableAutoUpdates'
  validExitCodes         = @(0)
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName

#chocolatey-core.extension (TODO: check if we need this?)
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"

Install-BinFile -Name "kopia" "$installLocation\resources\server\kopia.exe"
