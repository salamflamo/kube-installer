# =================== #
# Deploying VMware VM #
# =================== #
# Connect to VMware vSphere vCenter
provider "vsphere" {
user = var.vsphere-user
password = var.vsphere-password
vsphere_server = var.vsphere-vcenter
# If you have a self-signed cert
allow_unverified_ssl = var.vsphere-unverified-ssl
}
# Define VMware vSphere
data "vsphere_datacenter" "dc" {
name = var.vsphere-datacenter
}
data "vsphere_datastore" "datastore" {
name = var.vm-datastore
datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_compute_cluster" "cluster" {
name = var.vsphere-cluster
datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
name = var.vm-network
datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
name = "${var.vm-template-name}"
datacenter_id = data.vsphere_datacenter.dc.id
}



# Create VMs
resource "vsphere_virtual_machine" "vm" {
count = var.vm-count
name = "${var.vm-name}-${count.index + 1}"
resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
datastore_id = data.vsphere_datastore.datastore.id
num_cpus = var.vm-cpu
memory = var.vm-ram
guest_id = var.vm-guest-id
network_interface {
  network_id = data.vsphere_network.network.id
#  adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
}
disk {
  label = "${var.vm-name}-${count.index + 1}-disk"
   size             = data.vsphere_virtual_machine.template.disks.0.size
   eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
   thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
}
clone {
  template_uuid = data.vsphere_virtual_machine.template.id
  customize {
    timeout = 0
    
    linux_options {
      host_name = "idx-${count.index + 1}"
      domain = var.vm-domain
    }
    
     network_interface {
        ipv4_address = "192.168.234.${39 + count.index}"
        ipv4_netmask = "25"
      }

      ipv4_gateway = "192.168.234.126"
	  dns_server_list = ["8.8.8.8","8.8.4.4"]
	  dns_suffix_list = ["${var.vm-domain}"]
  }
  
 }

 tags = [        
    "${vsphere_tag.tag-environment-dev.id}",
    "${vsphere_tag.tag-environment-dev.id}"   
  ]

  provisioner "remote-exec" {
    script = "scripts/status-deployment.sh"
    connection {
			host = self.default_ip_address
			type	= "ssh"
			insecure = true
			user	= var.vm-user
			password = var.vm-password
			script_path = "/root/status-deployment.sh"
      }    
  }
}


