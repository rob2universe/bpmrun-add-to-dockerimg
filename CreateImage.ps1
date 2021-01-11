$rgName = Read-Host -Prompt 'Which resource group name should be use?'
$location = Read-Host -Prompt 'Which Azure location should be used? (e.g. westus, eastus, brazilsouth, westeurope, northeurope, centralindia, westindia, southeastasia, japanwest, australiasoutheast)'
$acrName = Read-Host -Prompt 'Azure container registry name to be used?'
Write-Host "`n Creating container registry '$acrName' in location '$location' in resource group '$rgName'`n"

$rgExists = az group exists -n $rgName
if ($rgExists -eq 'false') {
    $resourceGroup = New-AzResourceGroup -Name $rgName -Location $location
    Write-Host "`n New resource group '$rgName' created in '$location'.`n"
}
else {
    $resourceGroup = Get-AzResourceGroup -Name $rgName
    Write-Host "`n Using existing resource group '$rgName'.`n"
}
Get-AzResourceGroup -Name $rgName

$acrCheck = az acr check-name -n $acrName
if ($acrCheck -like '*nameAvailable": true*') {$registryExists="false"} else {$registryExists="true"}
if (!$registryExists) {
    $registry = New-AzContainerRegistry  -EnableAdminUser -Sku Basic -ResourceGroupName $rgName -Name $acrName 
    Write-Host "`n New container registry '$acrName' created in resource group '$rgName'."
}
else {
    $registry = Get-AzContainerRegistry -ResourceGroupName $rgName -Name $acrName
    Write-Host "`n Using existing registry '$acrName'."
}
Get-AzContainerRegistry -ResourceGroupName $rgName -Name $acrName

$creds = Get-AzContainerRegistryCredential -Registry $registry

$Env:acrName = $acrName
mvn clean install -P !Docker