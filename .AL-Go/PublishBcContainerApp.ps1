Param([Hashtable]$parameters) 

$Needs=$ENV:NeedsContext | ConvertFrom-Json
$containerConfig = $Needs."CustomJob-CreateAlpaca-Container".outputs

if ($parameters.appFile.GetType().BaseType.Name -eq 'Array') {
    # Check if current run is installing dependenciy apps
    # Dependency apps are already installed and should be skipped
    $equal = $true
    for ($i = 0; $i -lt $appsBeforeApps.Count; $i++) {
        if ($appsBeforeApps[$i] -ne $parameters.appFile[$i]) {
            $equal = $false
            break
        }
    }

    if (-not $equal) {
        #check second dependency array
        $equal = $true
        for ($i = 0; $i -lt $appsBeforeTestApps.Count; $i++) {
            if ($appsBeforeTestApps[$i] -ne $parameters.appFile[$i]) {
                $equal = $false
                break
            }
        }
    }

    if ($equal) {
        Write-Host "Skip apps before apps/testapps because they are already handled by Alpaca"
        return
    }
}

if (!$Env:ContainerStarted){
    Write-Host "::group::Wait for image to be ready"
    Wait-ForImage -token $Env:_token -containerName $containerConfig.containerID
    Write-Host "::endgroup::"
    Write-Host "::group::Wait for container start"
    Wait-ForAlpacaContainer -token $Env:_token -containerName $containerConfig.containerID
    Write-Host "::endgroup::"
}

Write-Host Get password from SecureString
$password=ConvertFrom-SecureString -SecureString $parameters.bcAuthContext.Password -AsPlainText

Publish-BCAppToDevEndpoint -containerUrl $parameters.Environment `
                           -containerUser $parameters.bcAuthContext.username `
                           -containerPassword $password `
                           -path $parameters.appFile
