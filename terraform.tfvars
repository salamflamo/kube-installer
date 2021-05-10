# VMware VMs configuration #
vm1-count = "2"
vm2-count = "2"
vm3-count = "1"
vm-name = "ansible"
vm-template-name = "ansible"
vm-cpu = "1"
vm-ram1 = "1024"
vm-ram2 = "2024"
vm-ram3 = "512"
vm-guest-id = "rhel8_64Guest"
# VMware vSphere configuration #
# VMware vCenter IP/FQDN
vsphere-vcenter = "192.168.234.76"
# VMware vSphere username used to deploy the infrastructure
vsphere-user = "administrator@vsphere.versasec.local"
# VMware vSphere password used to deploy the infrastructure
vsphere-password = "P@55w0rd1!!!"
# Skip the verification of the vCenter SSL certificate (true/false)
vsphere-unverified-ssl = "true"
# vSphere datacenter name where the infrastructure will be deployed 
vsphere-datacenter = "DC"
# vSphere cluster name where the infrastructure will be deployed
vsphere-cluster = "LAB MSI"
# vSphere Datastore used to deploy VMs 
vm-datastore = "EMC-DS1"
# vSphere Network used to deploy VMs 
vm-network = "VM Network"
# Linux virtual machine domain name
vm-domain = "loc"
# Login Account into VM
vm-user = "root"
vm-password = "server"
