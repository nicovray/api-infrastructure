param location string
param prefix string
param vNetId string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${prefix}-la-workspace'
  location: location
  properties: {
    sku: {
      name:'Free'
    }
  }
}

resource env 'Microsoft.Web/kubeEnvironments@2022-03-01' = {
  name: '${prefix}-container-env'
  location: location
  kind: 'containerenvironment'
  properties: {
    environmentType: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      customerId: logAnalyticsWorkspace.properties.customerId
      sharedKey: logAnalyticsWorkspace.listkeys().primarySharedKey
    }
  containerAppsConfiguration: {
    appSubnetResourceId: '${vNetId}/subnets/acaAppSubnet'
    controlPlaneSubnetResourceId: '${vNetId}/subnets/acaControlPlaneSubnet'
    }
  }
}


