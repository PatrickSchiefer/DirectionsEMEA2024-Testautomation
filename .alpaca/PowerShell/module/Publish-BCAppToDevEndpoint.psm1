
function Publish-BCAppToDevEndpoint {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$containerUrl,
        [Parameter(Mandatory = $true)]
        [string]$containerUser,
        [Parameter(Mandatory = $true)]
        [string]$containerPassword,
        [Parameter(Mandatory = $true)]
        [string]$path,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Development','Clean','ForceSync')]
        [string]$syncMode='Development',
        [Parameter(Mandatory = $false)]
        [string]$tenant='default') 
    
    $tries=0
    $maxtries=5
    $appName = [System.IO.Path]::GetFileName($Path)    
    Write-Host "::group::Publish app $appName"
    while (!$success -and $tries -lt $maxTries)
    {
        if ($tries -gt 0) {
            Write-Host "::group::Publish attempt $($tries + 1) / $maxtries"
        }
        $handler = New-Object System.Net.Http.HttpClientHandler
        $HttpClient = [System.Net.Http.HttpClient]::new($handler)
        $pair = "$($ContainerUser):$ContainerPassword"
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
        $base64 = [System.Convert]::ToBase64String($bytes)
        $HttpClient.DefaultRequestHeaders.Authorization = New-Object System.Net.Http.Headers.AuthenticationHeaderValue("Basic", $base64)
        $HttpClient.Timeout = [System.Threading.Timeout]::InfiniteTimeSpan
        $HttpClient.DefaultRequestHeaders.ExpectContinue = $false
        $schemaUpdateMode = "synchronize"
        if ($syncMode -eq "Clean") {
            $schemaUpdateMode = "recreate";
        } elseif ($syncMode -eq "ForceSync") {
            $schemaUpdateMode = "forcesync"
        }
        $devServerUrl = $ContainerUrl + "dev/dev/apps?SchemaUpdateMode=$schemaUpdateMode&tenant=$tenant"
    
        $multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
        $FileStream = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Open)
        try {
            $fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
            $fileHeader.Name = "$appName"
            $fileHeader.FileName = "$appName"
            $fileHeader.FileNameStar = "$appName"
            $fileContent = [System.Net.Http.StreamContent]::new($FileStream)
            $fileContent.Headers.ContentDisposition = $fileHeader
            $multipartContent.Add($fileContent)
            Write-Host "Publishing $appName to $devServerUrl"
            $result = $HttpClient.PostAsync($devServerUrl, $multipartContent).GetAwaiter().GetResult()
            $status = $result.StatusCode
            Write-Host "Returned $status from $devServerUrl"
            if (!$result.IsSuccessStatusCode) {
                Write-Host "Error Publishing App $appName"
                $message = "Status Code $($result.StatusCode) : $($result.ReasonPhrase)"
                try {
                    $resultMsg = $result.Content.ReadAsStringAsync().Result
                    try {
                        $json = $resultMsg | ConvertFrom-Json
                        $message += "`n$($json.Message)"
                    }
                    catch {
                        $message += "`n$resultMsg"
                    }
                }
                catch {}
                throw $message
            }
            $success = $true
        }
        catch {
            $tries = $tries + 1
            if ($tries -ge $maxTries) {
                $ErrorMessage = Get-ExtendedErrorMessage -errorRecord $_
                $ErrorMessage -split [Environment]::NewLine | % { Write-Host "::error::$_" }
                throw "Error Publishing App $appName"
            }
            else {
                Write-Host "Failed to publish app, retry after 15 sec"
                Start-Sleep 15
            }
        }
        finally {
            $FileStream.Close()
            Write-Host "::endgroup::"
        }
    }
}

Export-ModuleMember -Function Publish-BCAppToDevEndpoint