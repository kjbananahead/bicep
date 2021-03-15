targetScope = 'subscription'
param RGname string = '$(RGname)'
param region string = '$(region)'

param ContainerName string = '$(ContainerName)'
param StoAccountName string = '$(StoAccountName)'
param sku string = '$(sku)'


resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: RGname
  location: region
}

module StoAcctMod 'StoAcct.bicep' = {
name: 'StoAcctDeploy'
scope: rg
params: {
  ContainerName: ContainerName
  region: region
  sku: sku
  StoAccountName: StoAccountName
}
}