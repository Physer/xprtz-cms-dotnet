targetScope = 'subscription'

param environment string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-xprtz-${environment}'
  location: deployment().location
}

module cmsWebApp 'modules/web-app.bicep' = {
  scope: resourceGroup
  name: 'deployCmsWebApp'
  params: {
    environment: environment
  }
}
