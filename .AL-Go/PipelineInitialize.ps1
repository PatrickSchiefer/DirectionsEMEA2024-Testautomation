$Needs=$ENV:NeedsContext | ConvertFrom-Json
$containerConfig = $Needs."CUSTOM-CreateAlpaca-Container".outputs

$password = ConvertTo-SecureString -String $containerConfig.containerPassword -AsPlainText
$myAuthContext = @{"username"=$containerConfig.containerUser; "Password"=$password}
$myEnvironment = $containerConfig.containerURL

Set-Variable -Name 'bcAuthContext' -value $myAuthcontext -scope 1
Set-Variable -Name 'environment' -value $myEnvironment -scope 1

Write-Host -ForegroundColor Green 'INITIALIZE Auth context successful'

Import-Module ".\.alpaca\PowerShell\module\alpaca-functions.psd1" -Scope Global -Force
