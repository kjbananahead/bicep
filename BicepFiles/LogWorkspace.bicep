param region string = 'SouthCentralUS'

param WorkspaceName string = 'KevDemoLogWorkspace'


resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: WorkspaceName
  location: region
}


output WorkspaceId string = logWorkspace.id