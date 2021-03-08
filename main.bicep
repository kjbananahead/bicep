param region string = 'SouthCentralUS'
@minLength(3)
@maxLength(24)
param StoAccountName string ='KevBicepStorageDemo'

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: StoAccountName
  location: region
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageId string = storage.id