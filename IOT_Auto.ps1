# IOT setup and Message Queue/ route/ Custom endpoint coniguration
# Parameters to create IOT
#az login
#az account show --query id

# Parameters to include

$subscriptionID='0481ebf7-2bf5-4d97-b9e9-65faea2964fe'
$location='East us'
$resourceGroup='Autodeploy_final'
$iotHubName = 'iotakshub1213'

# parameters to create Route and Custome endpoints
# Storage Account and containers details

$storageAccountName = 'strgtest123'
$containername='bolbnm145'
$condition='level="storage"'

#storage endpoint details
$endpointName='aksstgEndpoint'

#provide eventhub details
$ehnamespace ='EventhubaksNS12'
$ehubname='hubakst11'
$SASname='policy-16'

# Eventhub endpoint details
$endpointname1='aksevenhub'


# Route parameters
$routeNM1='Route123'
$routeNM2='Route456'


# creating the IOT in XXX resource group at XXX location

az iot hub create --name $iotHubName --resource-group $resourceGroup --sku S1 --location $location



# Read the keys/connection string of storage

$storageConnectionString=(az storage account show-connection-string --name $storageAccountName --query connectionString -o tsv)

#read the keys/connectionstring of eventhub

$hubConnectionString=(az eventhubs eventhub authorization-rule keys list --resource-group $resourceGroup --namespace-name $ehnamespace --eventhub-name $ehubname --name $SASname --query "primaryConnectionString")

# Create Custom endpoints Storage and Eventhub
az iot hub routing-endpoint create --resource-group $resourceGroup --hub-name $iotHubName --endpoint-name $endpointName --endpoint-type azurestoragecontainer --endpoint-resource-group $resourceGroup  --connection-string $storageConnectionString  --container-name $containername --endpoint-subscription-id $subscriptionID

az iot hub routing-endpoint create --resource-group $resourceGroup --hub-name $iotHubName --endpoint-name $endpointName1 --endpoint-type eventhub --endpoint-resource-group $resourceGroup --connection-string $hubConnectionString  --endpoint-subscription-id $subscriptionID



# Create Routes based on custom endpoints
az iot hub route create -g $resourceGroup --hub-name $iotHubName --endpoint-name $endpointName --source-type DeviceMessages --condition "$body.MsgType = 'MSG_HEARTBEAT'" --route-name $routeNM1

az iot hub route create -g $resourceGroup --hub-name $iotHubName --endpoint-name $endpointName1 --source-type DeviceMessages --condition "$body.MsgType = 'MSG_HEARTBEAT'" --route-name $routeNM2
