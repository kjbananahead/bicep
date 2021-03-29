param region string = 'SouthCentralUS'

param WorkspaceName string = 'KevDemoLogWorkspace'


resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: WorkspaceName
  location: region
}

resource VMInsightsSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'VMInsightsSolution'
  location: region
  plan: {
   name: 'VMInsights'
   product: 'OMSGallery/VMInsights'
   publisher: 'Microsoft'
  }
  properties:{
    workspaceResourceId: logWorkspace.id
  }
}


output WorkspaceId string = logWorkspace.properties.customerId
