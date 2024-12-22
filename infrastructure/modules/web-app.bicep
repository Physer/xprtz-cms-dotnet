param environment string

param skuName string = 'B1'
param skuTier string = 'Basic'
param skuSize string = skuName
param skuFamily string = 'B'
param skuCapacity int = 1
param stack string = 'DOTNETCORE|9.0'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'plan-xprtz-${environment}'
  location: resourceGroup().location
  sku: {
    capacity: skuCapacity
    family: skuFamily
    name: skuName
    tier: skuTier
    size: skuSize
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: 'app-plan-xprtz-${environment}'
  location: resourceGroup().location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    reserved: true
    siteConfig: {
      linuxFxVersion: stack
    }
    httpsOnly: true
  }
}

output appServiceName string = appService.name
