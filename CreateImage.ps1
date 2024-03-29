$rgName = Read-Host -Prompt 'Which resource group name should be used?'
$acrName = Read-Host -Prompt 'Azure container registry name to be used?'
Write-Host "`n Creating container registry '$acrName' in location '$location' in resource group '$rgName'`n"

$rgExists = az group exists -n $rgName
if ($rgExists -eq 'false') {
    $location = Read-Host -Prompt 'Which Azure location should be used? (e.g. westus, eastus, brazilsouth, westeurope, northeurope, centralindia, westindia, southeastasia, japanwest, australiasoutheast)'
    $resourceGroup = New-AzResourceGroup -Name $rgName -Location $location
    Write-Host "`n New resource group '$rgName' created in '$location'.`n"
}
else {
    $resourceGroup = Get-AzResourceGroup -Name $rgName
    Write-Host "`n Using existing resource group '$rgName'.`n"
}
Get-AzResourceGroup -Name $rgName

if ((az acr check-name -n $acrName) -match '.nameAvailable": true.') {
    $registry = New-AzContainerRegistry  -EnableAdminUser -Sku Basic -ResourceGroupName $rgName -Name $acrName 
    Write-Host "`n New container registry '$acrName' created in resource group '$rgName'."
}
else {
    $registry = Get-AzContainerRegistry -ResourceGroupName $rgName -Name $acrName
    Write-Host "`n Using existing registry '$acrName'."
}
Get-AzContainerRegistry -ResourceGroupName $rgName -Name $acrName

Write-Host "`n Getting credentails for registry '$acrName'."
$creds = Get-AzContainerRegistryCredential -Registry $registry

$Env:acrName = $acrName
mvn clean install -P !Docker,Azure

# to build locally and push the local image to ACR, first tag the image
# docker tag org.camunda.bpm.example/bpmrun-add-to-dockerimg:1.0 robsacr.azurecr.io/bpmrun-add-to-dockerimg:1.0
# docker push robsacr.azurecr.io/bpmrun-add-to-dockerimg:1.0