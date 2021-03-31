targetScope = 'subscription'
param RGname string
param region string = 'SouthCentralUS'

param ContainerName string
param StoAccountName string
param sku string = 'Standard_LRS'

param WorkspaceName string

param VMname string
param VMsize string
param VMadminUsername string
@secure()
param VMadminPassword string
param vNetName string
param vNetRGname string
param vNetAddressSpace string
param vNetSubnetName string
param backendSubnet string
param osDiskType string

resource rg 'Microsoft.Resources/resourceGroups@2020-10-01' = {
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

module VmMod 'WindowsVM.bicep' = {
name: 'VmDeploy'
scope: rg
params: {
  virtualMachineName: VMname
  virtualMachineRG: RGname
  virtualMachineSize: VMsize
  adminUsername: VMadminUsername
  adminPassword: VMadminPassword
  region: region
  osDiskType: osDiskType
  vNetName: vNetName
  vNetRGname: vNetRGname
  subnetName: vNetSubnetName
  workspaceResourceId: LogWorkspaceMod.outputs.WorkspaceResourceId
}
}
