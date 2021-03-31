param region string = 'SouthCentralUS'

param WorkspaceName string = 'KevDemoLogWorkspace'

var vmInsights = {
  name: 'VMInsights(${WorkspaceName})'
  galleryName: 'VMInsights'
}

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: WorkspaceName
  location: region
  properties: {
    retentionInDays: 60
  }
}

resource VMInsightsSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: vmInsights.name
  location: region
  dependsOn: [
    logWorkspace
  ]
  plan: {
    name: vmInsights.name
    product: 'OMSGallery/${vmInsights.galleryName}'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logWorkspace.id
  }
}

resource logWorkspaceDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: logWorkspace
  name: 'diagnosticSettings'
  properties: {
    workspaceId: logWorkspace.id
    logs: [
      {
        category: 'Audit'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
  }
}

output WorkspaceId string = logWorkspace.properties.customerId
output WorkspaceResourceId string = logWorkspace.id
