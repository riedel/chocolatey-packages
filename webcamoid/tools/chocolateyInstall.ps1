$title = $Env:ChocolateyPackageName

$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'EXE'
  file64                 = (Get-ChocolateyPath -PathType 'PackagePath') + '\installer\webcamoid-installer-windows-9.2.3-win64.exe'
  silentArgs 		 = "/S"
  validExitCodes         = 0
}

Install-ChocolateyPackage @packageArgs

"!!Notice!!: The author request 1.50 USD for prebuild installers, please consider a regular donation at https://webcamoid.github.io/donations"

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\bin\$packageName.exe"
Write-Host "$packageName registered as $packageName"
