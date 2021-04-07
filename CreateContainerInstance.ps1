az login
$rgName = Read-Host -Prompt 'Which resource group name should be used?'
$acrName = Read-Host -Prompt 'What is the registry name?'
$containerName = Read-Host -Prompt 'Which name should be used for the container?'
$dnsName = Read-Host -Prompt 'Which DNS name should be used for the unique container URL?'

$creds = Get-AzContainerRegistryCredential -ResourceGroup $rgName -Name $acrName
$regCred = New-Object System.Management.Automation.PSCredential ($creds.Username, (ConvertTo-SecureString $creds.Password -AsPlainText -Force))
$image = $acrName +'.azurecr.io/bpmrun-add-to-dockerimg:1.0'

# https://docs.microsoft.com/en-us/powershell/module/az.containerinstance/new-azcontainergroup?view=azps-5.7.0
New-AzContainerGroup -ResourceGroupName $rgName -Name $containerName -Image $image -DnsNameLabel $dnsName -RegistryCredential $regCred -OsType Linux -IpAddressType Public -Port @(8080) -Cpu 1 -MemoryInGB 0.5
# az container create -g cam-containers --name camunda-run --image robsacr.azurecr.io/bpmrun-add-to-dockerimg:1.0 --dns-name-label apac-camunda --ports 8080 --protocol TCP --cpu 1 --memory 0.5