$title = $Env:ChocolateyPackageName
[array]$key = Get-UninstallRegistryKey -SoftwareName "*$title*"
Write-Debug "using UnInstaller at $key.UninstallString"

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  silentArgs 		 = '/S'
  file 			 = $key.UninstallString
  validExitCodes         = @(0)
}

Uninstall-ChocolateyPackage @packageArgs
