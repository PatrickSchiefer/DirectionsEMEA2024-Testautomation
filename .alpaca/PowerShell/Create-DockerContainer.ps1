param (
    [string]$token
)

Import-Module ".\.alpaca\PowerShell\module\alpaca-functions.psd1" -Scope Global -Force

$owner = $Env:GITHUB_REPOSITORY_OWNER
$repository = $Env:GITHUB_REPOSITORY
$repository = $repository.replace($owner, "")
$repository = $repository.replace("/", "")
$branch = $Env:GITHUB_REF_NAME

Write-Host "Starting container for $owner/$repository and ref $branch"


$headers = Get-AuthenticationHeader -token $token -owner $owner -repository $repository
$headers.add("Content-Type","application/json")

$body = @"
{
    "source": {
        "owner": "$owner",
        "repo": "$repository",
        "branch": "$branch"
    },
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
$apiUrl = Get-K8sEndpointUrlWithParam -controller "Container" -endpoint "GitHub/Build" -QueryParams $QueryParams
$containerConfig = Invoke-RestMethod $apiUrl -Method 'POST' -Headers $headers -Body $body -AllowInsecureRedirect
$containerID=$containerConfig.id
$containerUser=$containerConfig.username
$containerPassword=$containerConfig.Password
$containerURL=$containerConfig.webUrl




Write-Output containerID=$containerID >> $ENV:GITHUB_OUTPUT
Write-Output containerUser=$containerUser >> $ENV:GITHUB_OUTPUT
Write-Output containerPassword=$containerPassword >> $ENV:GITHUB_OUTPUT
Write-Output containerURL=$containerURL >> $ENV:GITHUB_OUTPUT
Write-Host Created container $containerID 