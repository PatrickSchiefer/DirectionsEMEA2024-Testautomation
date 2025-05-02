function Get-AlpacaSettings {
    $AlpacaSettings = Get-Content -Path (Join-Path $ENV:GITHUB_WORKSPACE "\.alpaca\alpaca.json") -Raw | ConvertFrom-Json
    return $AlpacaSettings
}

Export-ModuleMember -Function Get-AlpacaSettings