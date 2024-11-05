function Wait-ForImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][string]$token,
        [Parameter(Mandatory = $true)][string]$containerName
    )
    process {
        Write-Host ("[info]Checking status of service: {0}" -f $containerName)
        
        $SleepSeconds = 60
        $SleepSecondsPending = 10
        $TimeoutInMinutes = 50
        $WaitMessage = "Image is building. Going to sleep for {0} seconds." 
        $ContainerStatusCode  = @("Running", "Healthy")
        $success= $true

        $owner = $Env:GITHUB_REPOSITORY_OWNER
        $repository = $Env:GITHUB_REPOSITORY
        $repository = $repository.replace($owner, "")
        $repository = $repository.replace("/", "")

        $headers = Get-AuthenticationHeader -token $token -owner $owner -repository $repository
        $headers.add("Content-Type","application/json")

        $apiUrl = Get-K8sEndpointUrlWithParam -controller "service" -ressource $containerName -routeSuffix "status"  -QueryParams $QueryParams
        
        Write-Host "Get status from $apiUrl"

        $time = New-TimeSpan -Seconds ($TimeoutInMinutes * 60)
        $stoptime = (Get-Date).Add($time)

        $attemps = 1
        do {
            $serviceResult = Invoke-RestMethod $apiUrl -Method 'Get' -Headers $headers -AllowInsecureRedirect -StatusCodeVariable 'StatusCode'
            if ($statusCode -ne 200) {
                $success = $false
                return 
            }
            $currentStatus = $serviceResult.statusCode
            Write-Host "[info] Response: $serviceResult"
            Write-Host ("[info] Status is: {0}" -f $currentStatus)
            $CurrentSleepSeconds = $SleepSeconds
            if($currentStatus -in @("Unknown", "Pending")) {
                $CurrentSleepSeconds = $SleepSecondsPending
            }
            $CurrentWaitMessage = $WaitMessage
            if (!$serviceResult.imageBuilding){
                $CurrentWaitMessage = 'Waiting for service to start. Going to sleep for {0} seconds.'
            }
            Write-Host ("Attempt {0}: {1}" -f $attemps, $($CurrentWaitMessage -f $CurrentSleepSeconds))
            Write-Host
            if ($currentStatus -notin $ContainerStatusCode) {
                switch ($currentStatus) {
                    "Error" { 
                        $success = $false
                        Write-Host "##[Error]An error occured during building the image."
                        return
                    }
                    Default {                    
                        Start-Sleep -Seconds $CurrentSleepSeconds
                    }
                }
            }
            $attemps += 1
            if ((Get-Date) -gt $stoptime) {
                $success= $false
                Write-Host "::error::Timeout waiting for image build."
                return
            }
        } until ($currentStatus -in $ContainerStatusCode)
        Write-Host "##[info] Reached desired status: $currentStatus"
        $success= $true
    }

    end {
        if(! $success) {
            throw "Error during image build"
        } else {
            Write-Host "Task Completed."
        }
    }

}
Export-ModuleMember -Function Wait-ForImage