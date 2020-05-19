# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

# Get the Service Principal name
$SP_DEFAULT="myLUISDevOpsApp-" + (-join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}))
$spname = Read-Host "Enter the Service Principal name [$($SP_DEFAULT)]: "
$spname = ($SP_DEFAULT,$spname)[[bool]$spname]

# Get the resource group name
$resourceGroup = Read-Host "Enter the Azure Resource Group name: "

# get our subscriptionId
$subscriptionId=$(az account show --query id -o tsv)

# create the SP
$RBAC_TOKEN=$(az ad sp create-for-rbac --name "$spname" `
        --role "contributor" `
        --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup" `
        --sdk-auth)

# get the app id of the service principal
$servicePrincipalAppId=$(az ad sp list --display-name $spname --query "[].appId" -o tsv)

# grant Storage Blob Data Contributor access just to this resource group
az role assignment create --assignee $servicePrincipalAppId `
        --role "Storage Blob Data Contributor" `
        --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup" 

# Show token
Write-Host ""
Write-Host "Copy the following JSON and paste into a GitHub Secret called AZURE_CREDENTIALS:" -ForegroundColor Yellow
Write-Host ""
Write-Host $RBAC_TOKEN -ForegroundColor Gray
Write-Host ""