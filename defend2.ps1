# Function to pre-test Internet access
function testInternetAccess {
    Write-Host "Pre-test: Checking Internet access..."
    try {
        $response = Invoke-WebRequest -Uri "http://www.example.com" -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "Pre-test: Internet access test successful."
        } else {
            Write-Host "Pre-test: Internet access test failed."
        }
    } catch {
        Write-Host "Pre-test: Internet access test failed."
    }
}

# Function to enable restricting Internet access
function enableRestrictInternet {
    Write-Host "Enabling restriction of Internet access..."
    [System.Net.HttpWebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy("http://proxy",$true)
}

# Function to reset the fake web proxy and enable Internet access
function resetRestrictInternet {
    # Remove the fake proxy to enable Internet access
    [System.Net.HttpWebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy($null)

    # Output message indicating that Internet access has been reset
    Write-Host "Internet access has been reset. Proxy removed."
}

# Handle command line arguments
if ($args.Count -gt 0) {
    $argument = $args[0]
    if ($argument -eq "testInternetAccess") {
        testInternetAccess
    } elseif ($argument -eq "enableRestrictInternet") {
        enableRestrictInternet
    } elseif ($argument -eq "resetRestrictInternet") {
        resetRestrictInternet
    } else {
        Write-Host "Invalid argument. Supported arguments: testInternetAccess, enableRestrictInternet, resetRestrictInternet"
    }
} else {
    Write-Host "No argument provided. Supported arguments: testInternetAccess, enableRestrictInternet, resetRestrictInternet"
}
