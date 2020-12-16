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
# Define Data Sources VMware vSphere
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
#name = "${var.virtual_machine_template.["name"]}"
name = var.vm-template-name
datacenter_id = data.vsphere_datacenter.dc.id
}


# Define Provisioning  Scripts for Create VMs and looping instance so we can acchive multiple VM 
resource "vsphere_virtual_machine" "vm" {
count = var.vm-count
name = "${var.vm-name}${count.index + 1}"
resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
datastore_id = data.vsphere_datastore.datastore.id
num_cpus = var.vm-cpu
memory = var.vm-ram
guest_id = var.vm-guest-id
enable_disk_uuid = true
wait_for_guest_ip_timeout = 20
wait_for_guest_net_timeout = 20
wait_for_guest_net_routable = false
network_interface {
  network_id = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
}
disk {
  label = "${var.vm-name}-${count.index + 1}-disk"
   size             = data.vsphere_virtual_machine.template.disks.0.size
   eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
   thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
}

disk {
    size = 2
    name = "${var.vm-name}_2.vmdk"
    unit_number = 1
  }

clone {
  template_uuid = data.vsphere_virtual_machine.template.id
  customize {
    timeout = 20
    
    linux_options {
      host_name = "ansible${count.index + 1}"
      domain = var.vm-domain
    }
    
     network_interface {
        ipv4_address = "192.168.234.${108 + count.index}"
        ipv4_netmask = "25"
      }

      ipv4_gateway = "192.168.234.126"
	  dns_server_list = ["192.168.234.74"]
  }
  
 }

  provisioner "local-exec" {
    command = "start-sleep 120"
  interpreter = ["PowerShell", "-Command"]
  }
 
 provisioner "file" {
    source      = "scripts/status-deployment.sh"
    destination = "/tmp/status-deployment.sh"
    connection {
			host = self.default_ip_address
      type = "ssh"
			insecure = true
      timeout = "5m"
			user	= var.vm-user
			password = var.vm-password
      script_path = "/tmp/status-deployment.sh"
      }  
}

   provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/status-deployment.sh",
      "/tmp/status-deployment.sh args",
    ]
  connection {
			host = self.default_ip_address
      type = "ssh"
			insecure = true
      timeout = "5m"
			user	= var.vm-user
			password = var.vm-password
      }  

  }
}

resource "null_resource" "before" {
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "start-sleep 60"
  interpreter = ["PowerShell", "-Command"]
  }
  triggers = {
    "before" = "null_resource.before.id"
  }
}

resource "null_resource" "after" {
  depends_on = ["null_resource.delay"]
}
