// az deployment group create --resource-group rg-lfclass --template-file vnet-lfclass.bicep

@description('The name of the Virtual Network')
param vnetName string = 'vnet-lfclass'

@description('The name of the subnet')
param subnetName string = 'snet-vm'

@description('Address prefix for the Virtual Network')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Address prefix for the subnet')
param subnetAddressPrefix string = '10.0.1.0/24'

@description('The name of the Network Security Group')
param nsgName string = 'nsg-lfclass'

@description('Location for all resources')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: []
  }
}

output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
output nsgId string = nsg.id
