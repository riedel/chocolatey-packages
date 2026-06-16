$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/kopia/kopia/releases/download/v0.23.1/KopiaUI-Setup-0.23.1.exe'
  checksum               = '1E5A644738B6825B25F812FE414D9FCD73D18B8ED5214FDA2EC785566D179EC44035532D423A7FE24542BBCCC833DCBEE2697CC0FA0BBDC4E15F9A3864BC56C1'
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
