targetScope = 'subscription'
param RGname string = 'kev-bicep-demo'
param region string = 'SouthCentralUS'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: RGname
  location: region
}

module StoAcctMod './StoAcct.bicep' = {
name: 'StoAcctDeploy'
scope: resourceGroup(rg.name)
params: {
  ContainerName: ''
  region: 'SouthCentralUS'
  sku: 'Standard_LRS'
  StoAccountName: 'kevbicepstodemo'
}
}