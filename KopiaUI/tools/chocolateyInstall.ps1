$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/kopia/kopia/releases/download/v0.22.0/KopiaUI-Setup-0.22.0.exe'
  checksum               = 'D9A1C683BEA1419BA7A467107EF3FE01945D94BD17E3650EBFC4ADCAD04B4A71FA1F32C97E78837FCEC6E7552DDA4E7E7AF82BB9EBD4EB29D265E0F5D9FD52DC'
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
