$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/kopia/kopia/releases/download/v0.23.0/KopiaUI-Setup-0.23.0.exe'
  checksum               = '2BCAA6AEA138DCA21E1A4C957AE2A5AD68AC6044D0902A0E1B072CF2955361559CD045D476F9258004A7FE681FF63A7A4BEF74CD89A2E3EF507A00B0C3299EFC'
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
