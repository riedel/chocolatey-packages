#swyh package uninstaller
$packageName = '{{PackageName}}'
$packageVersionMajorMinor= ([regex] '^[0-9]+\.[0-9]+').Match("{{PackageVersion}}").Value
$softwareName = "Stream What You Hear (SWYH) version $packageVersionMajorMinor"

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

Write-Debug "using UnInstaller at $key.UninstallString"

$installerType = 'exe' 
$silentArgs = '/NORESTART /VERYSILENT' 

Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $key.UninstallString
