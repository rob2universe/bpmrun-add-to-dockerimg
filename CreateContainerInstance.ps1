az login
$rgName = Read-Host -Prompt 'Which resource group name should be used?'
$acrName = Read-Host -Prompt 'What is the registry name?'
$containerName = Read-Host -Prompt 'Which name should be used for the container?'
$dnsName = Read-Host -Prompt 'Which DNS name should be used for the unique container instance URL?'

$creds = Get-AzContainerRegistryCredential -ResourceGroup $rgName -Name $acrName
$regCred = New-Object System.Management.Automation.PSCredential ($creds.Username, (ConvertTo-SecureString $creds.Password -AsPlainText -Force))
$image = $acrName +'.azurecr.io/bpmrun-add-to-dockerimg:1.0'
New-AzContainerGroup -ResourceGroupName $rgName -Name $containerName -Image $image -DnsNameLabel $dnsName -RegistryCredential $regCred -OsType Linux -IpAddressType Public -Port @(8080) -Cpu 1 -MemoryInGB 0.5