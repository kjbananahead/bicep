param region string

param subnetName string
param vNetName string
param vNetRGname string

@description('Workspace Resource ID.')
param workspaceResourceId string

param virtualMachineName string
param virtualMachineRG string
param osDiskType string
param virtualMachineSize string
param adminUsername string
@secure()
param adminPassword string

var VMvnetId = resourceId(vNetRGname, 'Microsoft.Network/virtualNetworks', vNetName)
var nicName = '${virtualMachineName}-nic'
var subnetRef = '${VMvnetId}/subnets/${subnetName}'
var osType = 'Windows'
var imagePublisher = 'MicrosoftWindowsServer'
var imageOffer = 'WindowsServer'
var windowsOSVersion = '2019-Datacenter'
var daExtensionName = ((toLower(osType) == 'windows') ? 'DependencyAgentWindows' : 'DependencyAgentLinux')
var daExtensionType = ((toLower(osType) == 'windows') ? 'DependencyAgentWindows' : 'DependencyAgentLinux')
var daExtensionVersion = '9.5'
var mmaExtensionName = ((toLower(osType) == 'windows') ? 'MMAExtension' : 'OMSExtension')
var mmaExtensionType = ((toLower(osType) == 'windows') ? 'MicrosoftMonitoringAgent' : 'OmsAgentForLinux')
var mmaExtensionVersion = ((toLower(osType) == 'windows') ? '1.0' : '1.4')

resource nic 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: nicName
  location: region
  tags: {}
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
  dependsOn: []
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: virtualMachineName
  location: region
  tags: {}
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: windowsOSVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
  }
}

resource virtualMachine_daExtensionName 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = {
  name: '${virtualMachine.name}/${daExtensionName}'
  location: region
  properties: {
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: daExtensionType
    typeHandlerVersion: daExtensionVersion
    autoUpgradeMinorVersion: true
  }
}

resource virtualMachine_mmaExtensionName 'Microsoft.Compute/virtualMachines/extensions@2017-12-01' = {
  name: '${virtualMachine.name}/${mmaExtensionName}'
  location: region
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: mmaExtensionType
    typeHandlerVersion: mmaExtensionVersion
    autoUpgradeMinorVersion: true
    settings: {
      workspaceId: reference(workspaceResourceId, '2015-03-20').customerId
      stopOnMultipleConnections: true
    }
    protectedSettings: {
      workspaceKey: listKeys(workspaceResourceId, '2015-03-20').primarySharedKey
    }
  }
}

resource AutoShutdown 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-${virtualMachine.name}'
  location: region
  properties:{
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence:{
      time: '1700'
    }
    notificationSettings:{
      status: 'Disabled'
      timeInMinutes: 30
      notificationLocale: 'en'
    }
    timeZoneId: 'Central Standard Time'
    targetResourceId: virtualMachine.id
  }
}
output adminUsername string = adminUsername
