﻿$title = $Env:ChocolateyPackageName
[array]$key = Get-UninstallRegistryKey -SoftwareName "*$title*"
$uninstallstring = $key.QuietUninstallString
$file,$silentArgs = iex "echo $uninstallstring"


Write-Debug "using UnInstaller at $key.UninstallString"

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  silentArgs 		 = $silentArgs
  file 			 = $file
  validExitCodes         = @(0)
}

Uninstall-ChocolateyPackage @packageArgs
