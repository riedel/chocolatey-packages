$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/kopia/kopia/releases/download/v0.20.1/KopiaUI-Setup-0.20.1.exe'
  checksum               = '095781FB378E0C59B885A3501CFB0ABE1BAD3A16F58C0A65C8D3F038A0921A040F1624E59CFB60DDF2E72500B4DDA803721A222C915613ABF20D8FD320FF5101'
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
