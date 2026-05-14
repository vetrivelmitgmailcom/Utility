while ($true) {
    Get-Variable | Remove-Variable -Force -ErrorAction SilentlyContinue
    Clear-Host
    
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "     Tool to Get Values from Keyvault" -ForegroundColor Cyan 
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host ""

    # Ask Tenant ID
    $tenantId = Read-Host "Enter Azure KeyVault Tenant ID"

    # Check if the user is already logged in to the specified tenant
    $loginCheck = az account list --query "[?tenantId=='$tenantId']" --output json

    # Parse the login check output to see if there's any matching tenant
    $isLoggedIn = $loginCheck | ConvertFrom-Json

    if ($isLoggedIn) {
        Write-Host "Already logged in to the tenant $tenantId. Skipping login." -ForegroundColor Green
    } else {
        # Perform Azure login with the provided tenant ID if not already logged in
        Write-Host "Logging into Azure with Tenant ID: $tenantId..." -ForegroundColor Yellow
        $loginOutput = az login --tenant $tenantId --output json

        # Parse loginOutput and check if it's successful
        $loginStatus = $loginOutput | ConvertFrom-Json

        if ($loginStatus) {
            Write-Host "Successfully logged in!" -ForegroundColor Green
        } else {
            Write-Host "Failed to log in. Exiting tool." -ForegroundColor Red
            Write-Host "Error details: $loginOutput"
            break
        }
    }

    # Ask Vault Name
    $vaultName = Read-Host "Enter Key Vault Name"

    # Ask if JSON Output is needed
    $isJson = Read-Host "Do you want the output in JSON format? (Y/N)"

    # Ask if all keys are required
    $isAllKeys = Read-Host "Do you want to fetch all keys? (Y/N)"

    if ($isAllKeys -match "^[Yy]$") {
        # Get all enabled secrets
        $secrets = az keyvault secret list --vault-name $vaultName --query "[?attributes.enabled].name" -o tsv
        $total = $secrets.Count

        # Build a hashtable
        $result = @{}
        $index = 0

        foreach ($secret in $secrets) {
            $index++

            # Show progress bar
            Write-Progress -Activity "Fetching secrets from Key Vault" `
                           -Status "Processing $secret ($index of $total)" `
                           -PercentComplete (($index / $total) * 100)

            # Fetch the secret value
            $value = az keyvault secret show --vault-name $vaultName --name $secret --query value -o tsv
            $result[$secret] = $value
        }

        # Complete the progress bar
        Write-Progress -Activity "Fetching secrets from Key Vault" -Completed

        # Print output based on JSON flag
        if ($isJson -match "^[Yy]$") {
            # Print as JSON
            $result | ConvertTo-Json -Depth 3
        } else {
            # Print key-value pairs
            foreach ($key in $result.Keys) {
                Write-Output "$key = $($result[$key])"
            }
        }

    } else {
        # Ask for specific keys if not all
        $keysInput = Read-Host "Enter the keys (comma-separated) you want to fetch"
        $keys = $keysInput -split ',' | ForEach-Object { $_.Trim() }

        $total = $keys.Count
        $result = @{}
        $index = 0

        foreach ($secret in $keys) {
            $index++

            # Show progress bar
            Write-Progress -Activity "Fetching secrets from Key Vault" `
                           -Status "Processing $secret ($index of $total)" `
                           -PercentComplete (($index / $total) * 100)

            # Fetch secret value
            $value = az keyvault secret show --vault-name $vaultName --name $secret --query value -o tsv
            $result[$secret] = $value
        }

        # Complete the progress bar
        Write-Progress -Activity "Fetching secrets from Key Vault" -Completed

        # Print output based on JSON flag
        if ($isJson -match "^[Yy]$") {
            # Print as JSON
            $result | ConvertTo-Json -Depth 3
        } else {
            # Print key-value pairs
            foreach ($key in $result.Keys) {
                Write-Output "$key = $($result[$key])"
            }
        }
    }

    # Ask to run again
    $again = Read-Host "Do you want to generate another set? (Y/N)"

    if ($again -notmatch "^[Yy]$") {
        Write-Host ""
        Write-Host "Exiting Tool..." -ForegroundColor Yellow
        break
    }
}