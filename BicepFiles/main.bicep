targetScope = 'subscription'
param RGname string
param region string = 'EastUS2'

param ContainerName string
param StoAccountName string
param sku string = 'Standard_LRS'

param WorkspaceName string

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

module LogWorkspaceMod 'LogWorkspace.bicep' = {
  name: 'LogWorkspaceDeploy'
  scope: rg
  params: {
    WorkspaceName: WorkspaceName
    region: region
  }
}
