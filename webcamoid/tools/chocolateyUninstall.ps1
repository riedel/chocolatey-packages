$title = $Env:ChocolateyPackageName
$installLocation = Get-AppInstallLocation $Env:ChocolateyPackageName
Write-Debug "using UnInstaller at $installLocation"

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  silentArgs 		 = "/S"
  file 			 = "$installLocation\uninstall.exe"
  validExitCodes         = @(0)
}

Uninstall-ChocolateyPackage @packageArgs
