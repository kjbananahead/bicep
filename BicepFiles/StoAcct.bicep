param region string = 'SouthCentralUS'

@minLength(3)
@maxLength(24)
param StoAccountName string = 'kevbicepstodemo'

param ContainerName string = 'images'

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_ZRS'
])
param sku string = 'Standard_LRS'

resource stoAcct 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: StoAccountName
  location: region
  kind: 'StorageV2'
  sku: {
    name: sku
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2020-08-01-preview' = {
  name: '${stoAcct.name}/default/${ContainerName}'
}

output storageId string = stoAcct.id