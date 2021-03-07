$title = $Env:ChocolateyPackageName
[array]$key = Get-UninstallRegistryKey -SoftwareName "*$title*"

if($key.DisplayName)
{
  $packageArgs = @{
    packageName          = $Env:ChocolateyPackageName
    fileType             = 'EXE'
    silentArgs 		 = "--script $Env:ChocolateyPackageFolder/tools/silentInstall.js"
    file 		 = $key.UninstallString
    validExitCodes       = 0,1
  }

  Uninstall-ChocolateyPackage @packageArgs
}

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  url                    = 'https://github.com/webcamoid/webcamoid/releases/download/8.8.0/webcamoid-8.8.0-win32.exe'
  url64                    = 'https://github.com/webcamoid/webcamoid/releases/download/8.8.0/webcamoid-8.8.0-win64.exe'
  checksum               = '3e04c3afa7ac33e7f4923b69e1d3d62256a7f29645d98a19537b3d7e2a88c37e'
  checksum64               = '0979046c5187325772fc73b3cfff7dc9462dc7c243df44db0f4df9c0f2ba8d77'
  checksumType           = 'sha256'
  silentArgs 		 = "--script $Env:ChocolateyPackageFolder/tools/silentInstall.js"
  validExitCodes         = 0,1
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\bin\$packageName.exe"
Write-Host "$packageName registered as $packageName"
