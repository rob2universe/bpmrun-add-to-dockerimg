# bpmrun-add-to-dockerimg
Add user artefacts to Camunda BPM RUN docker image in a custom container image and deploy it to a container registry.

The directory structure in folder [*configuration*](./configuration) maps to folder in container according to [Camunda BPM Run product documentation](https://docs.camunda.org/manual/latest/user-guide/camunda-bpm-run/).

## Local Usage

### Build the Docker image

`mvn clean install`
### Build locally then push the image to a remote repository

`mvn clean deploy -Ddocker.users=<username> -Ddocker.password=<passwd> -Ddocker.url=<docker-registry-url>`
## Usage from within Azure console

1. Access console via [https://shell.azure.com/](https://shell.azure.com/)  
   (If required confirm to create storage if not used before. This may take a few minutes.)  
   Select *PowerShell*
1. Clone this repository using:  
    `git clone https://github.com/rob2universe/bpmrun-add-to-dockerimg`
2. Change into directory:  
   `cd ./bpmrun-add-to-dockerimg/`

3. Simply run the script:   
   `./CreateImage.ps1`  
   and enter the requested parameters when prompted

## Alternative: Manual configuration in Azure console
### Manual Azure Preparation
1. set values for location, resource group name and container regsitry name, for example:   
  - `$Env:rgName = "rg1"`   
  - `$Env:location = "southeastasia"`   
  - `$Env:acrName = "RobsACR"`
2. If required [Create an Azure resource group via the Azure portal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal) or via the shell using:   
`$resourceGroup = New-AzResourceGroup -Name $Env:rgName -Location $Env:location`  
(e.g. westus, eastus, brazilsouth, westeurope, northeurope, centralindia, westindia, southeastasia, japanwest, australiasoutheast))
3. If required [Create an Azure container registry using the Azure portal](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal) or via the shell using:  
  `$registry = New-AzContainerRegistry -ResourceGroupName $resourceGroup.ResourceGroupName -EnableAdminUser -Sku Basic -Name $Env:acrId`
 enabling admin user in production use an individual identity or service principal instead.   
 4. Get login credentials for your container registry  
`$creds = Get-AzContainerRegistryCredential -Registry $registry`

### Manual build and publish of the custom Camunda BPM Run image
  
1. Clone git repository by running:  
   `git clone https://github.com/rob2universe/bpmrun-add-to-dockerimg`
2. Change into cloned directory:  
    `cd ./bpmrun-add-to-dockerimg/`   
    (modify and add files if needed)
3. Download dependencies listed in POM (i.e. groovy jars) and create docker image by running:   
   `mvn clean install`  
   (append *-DacrName=\<registry name>* if you did not previously set the enviornment variable $Env:acrName)   

This will build your docker image and push it to your Azure container registy. Subsequently the image will be available under: **\<registry name>.azurecr.io/bpmrun-add-to-dockerimg:1.0**

## Creating an Azure container instance based on the published image
Once the image has been published to your Azure cointainer registry you can use it to create Azure container instances, e.g. as described [here for Azure cloud shell](
https://medium.com/@robert.emsbach/deploying-camunda-bpm-to-azure-container-service-via-cli-in-5-minutes-cab7fd14e50c) or [here for Azure portal](https://medium.com/@robert.emsbach/anyone-can-run-camunda-bpm-on-azure-in-10-minutes-4b4055cc8e9).

Example (this is still work in progress):
1. `$creds = Get-AzContainerRegistryCredential -ResourceGroup <resource group name> -Name <registry name>`  
2. `$acrcred = New-Object System.Management.Automation.PSCredential ($creds.Username, (ConvertTo-SecureString $creds.Password -AsPlainText -Force))`
3. `New-AzContainerGroup -ResourceGroupName <resource group name> -Name mybpmnrun -Image <registry name>.azurecr.io/bpmrun-add-to-dockerimg:1.0 -DnsNameLabel bpmrun -Location <location> -RegistryCredential $acrcred -OsType Linux -IpAddressType Public -Port @(8080) -Cpu 1 -MemoryInGB 0.5 -EnvironmentVariable @{SPRING_APPLICATION_JSON='{"camunda.bpm.run.auth.enabled":"true"}'}`

## Simple Test
This project contains an [example process model](./configuration/resources/groovyprocess.bpmn) which, if successfully included in your custom container image, will be automatically deployed during startup. This process makes use of the newly included Groovy jars. Start a process via Camunda modeler or tasklist. If the process instances starts / completes without error then the Groovy script output will be visible in the container instances console log.

To follow the container's console output in Azure cloud shell you can use  
`az container attach --resource-group <resource group name> --name <container instance name>`

## Cleanup

`Remove-AzResourceGroup -Name <resource group name>`

### Supporting Documentation
 [Camunda BPM Run product documentation](https://docs.camunda.org/manual/latest/user-guide/camunda-bpm-run/)

[Quickstart: Create a private container registry using Azure PowerShell](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-powershell)

[Quickstart: Create an Azure container registry using the Azure portal](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal)

 [Quickstart: Build and run a container image using Azure Container Registry Tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task)

 [Quickstart: Deploy a container instance in Azure using Azure PowerShell](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart-powershell)

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)


