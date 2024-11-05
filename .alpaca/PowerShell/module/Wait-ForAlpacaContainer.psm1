function Wait-ForAlpacaContainer {
    param (
        [Parameter(Mandatory = $true)][string]       $token,
        [Parameter(Mandatory = $true)][string]       $containerName,
        [Parameter(Mandatory = $false)][System.Collections.ArrayList]    $readyString = @("Ready for connections!"),
        [Parameter(Mandatory = $false)][System.Collections.ArrayList]    $errorString = @("[ERROR]"),
        [Parameter(Mandatory = $false)][System.Collections.ArrayList]    $warningString = @("[WARN]"),
        [Parameter(Mandatory = $false)][bool]         $printLog = $true,
        [Parameter(Mandatory = $false)][int]          $maxTries = 30,
        [Parameter(Mandatory = $false)][int]          $sleepSeconds = 5,
        [Parameter(Mandatory = $false)][int]          $initialSleepSeconds = 15
    )
    process {
        try {
            $success = $true
            # Wait for Read-String & Handle Exceptions
            # - Warnings
            # - Errors
            # - Log Messages
            $warnRegex = [string]::Join("|", (@() + $warningString | ForEach-Object { [System.Text.RegularExpressions.Regex]::Escape($_) }) )
            $errorRegex = [string]::Join("|", (@() + $errorString | ForEach-Object { [System.Text.RegularExpressions.Regex]::Escape($_) }) )
            $readyRegex = [string]::Join("|", (@() + $readyString | ForEach-Object { [System.Text.RegularExpressions.Regex]::Escape($_) }) )
            $tries = 0
            $waitForContainer = $true
            $takenLines = 0

            if ($initialSleepSeconds) {
                Write-Host "Wait for container connection ($initialSleepSeconds sec)"
                Start-Sleep -Seconds $initialSleepSeconds
            }

            $owner = $Env:GITHUB_REPOSITORY_OWNER
            $repository = $Env:GITHUB_REPOSITORY
            $repository = $repository.replace($owner, "")
            $repository = $repository.replace("/", "")

            
            $headers = Get-AuthenticationHeader -token $token -owner $owner -repository $repository
            $headers.add("accept","application/text")

            $QueryParams = @{
                "api-version" = "0.12"
                tail = 5000
            }
            $apiUrl = Get-K8sEndpointUrlWithParam -controller "task" -ressource $containerName -routeSuffix "logs"  -QueryParams $QueryParams
                
            while ($waitForContainer) {  

                $result = Invoke-RestMethod $apiUrl -Method 'Get' -Headers $headers -AllowInsecureRedirect -StatusCodeVariable 'StatusCode'

                $content = $result -split "\n"

                if ($StatusCode -ne 200) {
                        
                    if ($tries -lt $maxTries) {
                        $tries = $tries + 1
                    }
                    else {
                        Write-Host "::error::Error while getting logs from container"
                        Write-Host "::error::Content: $($content)"
                        $waitForContainer = $false
                        $success = $false
                        return
                    }
                }
                    
                # Check for Errors, Warnings, Ready-String
                foreach ($line in ($content | Select-Object -Skip $takenLines -First ($content.Length - 1))) {
                    if ($errorRegex -and ($line -match $errorRegex)) {
                        Write-Host "::error::$line"
                        $success = $false                                
                        $waitForContainer = $false
                    }
                    elseif ($warnRegex -and ($line -match $warnRegex)) {
                        Write-Host "::warning::$line"
                        $warning = $true
                    }
                    elseif ($readyRegex -and ($line -match $readyRegex)) {
                        Write-Host "$($line)"
                        $waitForContainer = $false
                    }
                    elseif (! [string]::IsNullOrWhiteSpace($line)) {
                        #Avoid Empty lines in logfile
                        Write-Host "$($line)"
                    }
                }
                $takenLines = $content.Length - 1

                if ($waitForContainer -and $sleepSeconds) {
                    Start-Sleep -Seconds $sleepSeconds
                }
                elseif ($takenLines -lt $content.Length) {
                    Write-Host "$($content | Select-Object -Last 1)"
                }
            }

        }
        catch {
            $ErrorMessage = Get-ExtendedErrorMessage -errorRecord $_
            $ErrorMessage -split [Environment]::NewLine | % { Write-Host "::error::$_" }
            $success = $false
            return
        }
    }
    
    end {
        if (! $success) {
            throw "Errors found during container start"
        }
        elseif ($warning) {
            Write-Host "::warning::container started with warnings"
        }
        else {
            Write-Host "Container is ready."
        }
    }
}

Export-ModuleMember -Function Wait-ForAlpacaContainer