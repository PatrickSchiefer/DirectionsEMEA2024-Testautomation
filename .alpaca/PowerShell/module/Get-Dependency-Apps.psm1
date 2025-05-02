function Get-Dependency-Apps {
    Param(
        $packageFolder,
        $token
    )

    $owner = $Env:GITHUB_REPOSITORY_OWNER
    $repository = $Env:GITHUB_REPOSITORY
    $repository = $repository.replace($owner, "")
    $repository = $repository.replace("/", "")
    $branch = $Env:GITHUB_REF_NAME

    Write-Host "Starting container for $owner/$repository and ref $branch"

    $headers = Get-AuthenticationHeader -token $token -owner $owner -repository $repository
    $headers.add("Content-Type", "application/json")

    $config = Translate-WorkflowName-To-ConfigName 

    $body = @"
    {
        "source": {
            "owner": "$owner",
            "repo": "$repository",
            "branch": "$branch"
        },
        "containerConfiguration": "$config",
        "workflow": {
            "actor": "$($Env:GITHUB_ACTOR)",
            "workflowName": "$($Env:GITHUB_WORKFLOW)",
            "WorkflowRef": "$($Env:GITHUB_WORKFLOW_REF)",
            "RunID": "$($Env:GITHUB_RUN_ID)",
            "Repository": "$($Env:GITHUB_REPOSITORY)"
        }
    }
"@


    $QueryParams = @{
        "api-version" = "0.12"
    }
    $apiUrl = Get-K8sEndpointUrlWithParam -controller "Container" -endpoint "GitHub/GetBuildContainerArtifacts" -QueryParams $QueryParams
    $artifacts = Invoke-RestMethod $apiUrl -Method 'GET' -Headers $headers -Body $body -AllowInsecureRedirect

    foreach ($artifact in $artifacts) {
        if ($artifact.target -eq 'App') {
            if ($artifact.type -eq 'Url') {
                Write-Host "Downloading $($artifact.name) from $($artifact.url)"
                
                $tempFolder = (Join-Path ([System.IO.Path]::GetTempPath()) 'packages')
                if (-not (Test-Path $tempFolder)) {
                    New-Item -ItemType Directory -Path $tempFolder
                }
                Invoke-WebRequest -Uri $artifact.url -OutFile "$tempFolder\$($artifact.name).zip"
                Expand-Archive -Path "$tempFolder\$($artifact.name).zip" -DestinationPath $packageFolder -Force
            } else {
                Write-Host "Nuget handled by AL:Go $($artifact.name)"
            }
        }
    }

}


Export-ModuleMember -Function Get-Dependency-Apps