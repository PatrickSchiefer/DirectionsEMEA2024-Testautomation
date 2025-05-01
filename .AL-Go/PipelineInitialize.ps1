$Needs=$ENV:NeedsContext | ConvertFrom-Json
$containerConfig = $Needs."CustomJob-CreateAlpaca-Container".outputs

$password = ConvertTo-SecureString -String $containerConfig.containerPassword -AsPlainText
$myAuthContext = @{"username"=$containerConfig.containerUser; "Password"=$password}
$myEnvironment = $containerConfig.containerURL

Set-Variable -Name 'bcAuthContext' -value $myAuthcontext -scope 1
Set-Variable -Name 'environment' -value $myEnvironment -scope 1

Write-Host -ForegroundColor Green 'INITIALIZE Auth context successful'

Import-Module (Join-Path $ENV:GITHUB_WORKSPACE "\.alpaca\PowerShell\module\alpaca-functions.psd1") -Scope Global -Force -DisableNameChecking

$bcContainerHelperConfig.doNotRemovePackagesFolderIfExists = $true

Write-Host Get packagesFolder Folder
$packagesFolder = CheckRelativePath -baseFolder $baseFolder -sharedFolder $sharedFolder -path $packagesFolder -name "packagesFolder"
if (Test-Path $packagesFolder) {
    Remove-Item $packagesFolder -Recurse -Force
}
New-Item $packagesFolder -ItemType Directory | Out-Null
Write-Host Packagefolder $packagesFolder

Get-Dependency-Apps -packageFolder $packagesFolder -token $Env:_token
