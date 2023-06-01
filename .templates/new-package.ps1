$source=$args[0]
$target=$args[1]
Copy-Item -Path $source -Destination ../$target -Recurse
Rename-Item -Path ../$target/$source".nuspec.in" -NewName $target".nuspec.in" 
