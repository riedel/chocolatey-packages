#generic InnoSetup package installer
$packageName = '{{PackageName}}'
$installerType = 'exe'
$url = '{{DownloadUrl}}'
$silentArgs = '/NORESTART /VERYSILENT /SUPPRESSMSGBOXES'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"  -validExitCodes $validExitCodes
