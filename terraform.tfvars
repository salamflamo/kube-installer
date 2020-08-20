# VMware VMs configuration #
vm-count = "2"
vm-name = "IDX"
vm-template-name = "IDX"
vm-cpu = "1"
vm-ram = "1024"
vm-guest-id = "rhel7_64Guest"
# VMware vSphere configuration #
# VMware vCenter IP/FQDN
vsphere-vcenter = "192.168.234.107"
# VMware vSphere username used to deploy the infrastructure
vsphere-user = "administrator@vsphere.local"
# VMware vSphere password used to deploy the infrastructure
vsphere-password = "P@ssw0rd"
# Skip the verification of the vCenter SSL certificate (true/false)
vsphere-unverified-ssl = "true"
# vSphere datacenter name where the infrastructure will be deployed 
vsphere-datacenter = "LAB-MSI"
# vSphere cluster name where the infrastructure will be deployed
vsphere-cluster = "Cluster02"
# vSphere Datastore used to deploy VMs 
vm-datastore = "datastore1"
# vSphere Network used to deploy VMs 
vm-network = "DPortGroup-LAB"
# Linux virtual machine domain name
vm-domain = "mastersystem.local"
# Login Account into VM
vm-user = "root"
vm-password = "server"
