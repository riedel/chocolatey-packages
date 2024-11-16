$packageArgs = @{
  packageName            = $Env:ChocolateyPackageName
  fileType               = 'MSI'
  url                    = 'https://smath.com/en-US/files/Download/gbNh3/SMathStudioDesktop.1_2_9018.Setup.msi'
  checksum               = '893adb211eb0bb4f774372ce8ba9ea6a648e98cbbeda830db523e004f174da0c'
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
