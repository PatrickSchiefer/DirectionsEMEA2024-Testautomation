function Get-BackendURL {
    $AlpacaSettings = Get-AlpacaSettings
    $BackendURL= $AlpacaSettings.backendURL
    if ($BackendURL -notlike "*/") { $BackendURL = $BackendURL + "/"}
    return $BackendURL
}

function Get-k8sAPIUrl {
    $BackendURL=Get-BackendURL
    return $BackendURL + "api/docker/release/"
}

Export-ModuleMember -Function Get-k8sAPIUrl

function Get-K8sEndpointUrlWithParam {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$controller,
        [string]$endpoint,
        [string]$ressource,
        [string]$routeSuffix,
        [Hashtable] $QueryParams
        )
    $url = Get-k8sAPIUrl
    $url = $url + $controller  

    if ($endpoint) {
        $url = $url + "/" + $endpoint 
    }
    
    if ($ressource) {
        $url = $url + "/" + $ressource
    }

    if ($routeSuffix) {
        $url = $url + "/" + $routeSuffix
    }
    
    if ($QueryParams) {
        $url = $url + "?"
        $QueryParams.GetEnumerator() | ForEach-Object {
            $url = $url + $_.Key + "=" + $_.Value + "&"
        }
        $url = $url.TrimEnd("&")
    }
    return $url
}


Export-ModuleMember -Function Get-K8sEndpointUrlWithParam

function Get-AuthenticationHeader {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$token,
        [Parameter(Mandatory = $true)]
        [string]$owner,
        [Parameter(Mandatory = $true)]
        [string]$repository
        )
    $headers = @{
        Authorization="Bearer $token"
        "Authorization-GitHub"="$token"
        "Authorization-Owner"="$owner"
        "Authorization-Repository"="$repository"
    }
    return $headers
}

Export-ModuleMember -Function Get-AuthenticationHeader