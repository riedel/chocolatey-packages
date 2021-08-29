$title = $Env:ChocolateyPackageTitle
[array]$key = Get-UninstallRegistryKey -SoftwareName "*$title*"
$uninstallstring = $key.UninstallString
$file,$ignore = iex "echo $uninstallstring"

$silentArgs = @() 
$silentArgs += "/uninstall"
$silentArgs += $key.PSChildName  
$silentArgs += "/quiet"
$silentArgs += "/norestart"
$silentArgs += "/qn"


Write-Debug "using UnInstaller at $key.UninstallString"

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  silentArgs 		 = $silentArgs
  file 			 = $file
  validExitCodes         = @(0)
}

Uninstall-ChocolateyPackage @packageArgs
