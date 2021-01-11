If (!$rgName) {
    $rgName = Read-Host -Prompt 'Which resource group name should be used?'
}
If (!$containerName) {
    $containerName = Read-Host -Prompt 'Which name should be used for the container?'
}
If (!$acrName) {
    $acrName = Read-Host -Prompt 'What is the registry name?'
}
If (!$dnsName) {
    $acrName = Read-Host -Prompt 'Which DNS name should be used for the unique container instance URL?'
}

$creds = Get-AzContainerRegistryCredential -ResourceGroup $rgName -Name $containerName

$acrcred = New-Object System.Management.Automation.PSCredential ($creds.Username, (ConvertTo-SecureString $creds.Password -AsPlainText -Force))

New-AzContainerGroup -ResourceGroupName $rgName -Name $containerName -Image $acrName.azurecr.io/bpmrun-add-to-dockerimg:1.0 -DnsNameLabel $dnsName -RegistryCredential $acrcred -OsType Linux -IpAddressType Public -Port @(8080) -Cpu 1 -MemoryInGB 0.5 -EnvironmentVariable @{"SPRING_APPLICATION_JSON"='{"camunda.bpm.run.auth.enabled":"true"}'}