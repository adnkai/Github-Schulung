param vmName string
param vmSize string
param osDiskSizeGb int
param dataDiskSizeGb int
param adminUsername string = 'kingKai'

@secure()
param adminPassword string = 'Password1234!'

param location string = resourceGroup().location

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: osDiskSizeGb
      }
      dataDisks: [
        {
          createOption: 'Empty'
          diskSizeGB: dataDiskSizeGb
          lun: 0
        },
        {
          createOption: 'Empty'
          diskSizeGB: dataDiskSizeGb
          lun: 1
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${vmName}-nic')
        }
      ]
    }
  }
}

output vmName string = vm.name
