$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'MSI'
  url                    = 'https://smath.com/en-US/files/Download/C8vUS/SMathStudioDesktop.1_3_0_9126.Setup.msi'
  checksum               = 'c7040fa9c9bcb8a5160738ba59b5ca5f25dd0e9881d35049e96a7151c5c90455'
  checksumType           = 'sha256'
  silentArgs 		 = '/quiet /qn'
  validExitCodes         = @(0)
  Options = @{
    Headers = @{
      referer = "https://en.smath.com/view/SMathStudio/summary"
    }
  }
}

Install-ChocolateyPackage @packageArgs

# $packageName = $packageArgs.packageName
# $installLocation = Get-AppInstallLocation $Env:ChocolateyPackageTitle
# if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
# Write-Host "$packageName installed to '$installLocation'"

# Register-Application "$installLocation\Solver.exe"

# Write-Host "$packageName registered"
