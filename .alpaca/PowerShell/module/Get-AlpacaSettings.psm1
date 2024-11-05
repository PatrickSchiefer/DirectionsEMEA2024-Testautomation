function Get-AlpacaSettings {
    $AlpacaSettings = Get-Content -Path ".\.alpaca\alpaca.json" -Raw | ConvertFrom-Json
    return $AlpacaSettings
}

Export-ModuleMember -Function Get-AlpacaSettings