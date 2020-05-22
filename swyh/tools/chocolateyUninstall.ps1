#swyh package uninstaller
$packageName    = $Env:ChocolateyPackageName

$softwareName = "Stream What You Hear*"

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

Write-Debug "using UnInstaller at $key.UninstallString"

$installerType = 'exe' 
$silentArgs = '/NORESTART /VERYSILENT' 

Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $key.UninstallString
