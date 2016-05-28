#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

#Items that could be replaced based on what you call chocopkgup.exe with
#{{PackageName}} - Package Name (should be same as nuspec file and folder) |/p
#{{PackageVersion}} - The updated version | /v
#{{DownloadUrl}} - The url for the native file | /u
#{{PackageFilePath}} - Downloaded file if including it in package | /pp
#{{PackageGuid}} - This will be used later | /pg
#{{DownloadUrlx64}} - The 64bit url for the native file | /u64

$packageName = 'swyh'# arbitrary name for the package, used in messages
$packageVersionMajorMinor= ([regex] '^[0-9]+\.[0-9]+').Match("{{PackageVersion}}").Value
$softwareName = "Stream What You Hear (SWYH) version $packageVersionMajorMinor"

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

Write-Debug "using UnInstaller at $key.UninstallString"

$installerType = 'exe' #only one of these: exe, msi, msu
$silentArgs = '/NORESTART /VERYSILENT' # "/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet

# main helpers - these have error handling tucked into them already
# installer, will assert administrative rights
Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $key.UninstallString
