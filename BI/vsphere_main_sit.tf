# Defisnikan variable untuk menghubungkan ke vSphere vCenter
provider "vsphere" {
user = var.vsphere_username
password = var.vsphere_username
vsphere_server = 10.101.101.10
# If you have a self-signed cert
allow_unverified_ssl = true
}


############ Defisikan Data Sources Data Center VMware vSphere

# Defisikan Data Sources Nama Datacenter VMware vSphere
data "vsphere_datacenter" "dc" {
  name = resources_static.dc
}
# Defisikan Data Sources HOST ESXI Cluster VMware vSphere
data "vsphere_host" "hosts" {
  name          = resources_static.compute_host
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Defisikan Data Sources Cluster VMware vSphere
data "vsphere_compute_cluster" "compute_cluster" {
  name          = resources_static.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Defisikan Data Sources Resource Pool Cluster VMware vSphere
data "vsphere_resource_pool" "pool" {
  name          = resources_static.resource_pool_id
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Defisikan Data Sources Datastrore VMware vSphere
data "vsphere_datastore" "datastore" {
  name          = resources_static.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Defisikan Data Sources Network for Guest VM VMware vSphere
data "vsphere_network" "eth0" {
  name          = resources_static.vnic
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Defisikan Data Sources VM Template VMware vSphere
data "vsphere_virtual_machine" "template" {
  name          = resources_static.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

################# Membuat Tags #####################33
resource "vsphere_tag_category" "environment" {
    name        = "Environment"
    cardinality = "SINGLE"
 
    associable_types = [
        "VirtualMachine"
    ]
}
 
resource "vsphere_tag_category" "lokasi" {
    name        = "Lokasi"
    cardinality = "SINGLE"
 
    associable_types = [
        "VirtualMachine"
    ]
}
 
resource "vsphere_tag" "environment" {
    name        = "SIT"
    category_id = "${vsphere_tag_category.environment.id}"
    description = "Managed by Terraform"
}
 
resource "vsphere_tag" "lokasi" {
    name         = "DC"
    category_id = "${vsphere_tag_category.lokasi.id}"
    description = "Managed by Terraform"
}

#Definisikan untuk pembuatan Virtual Machine
resource "vsphere_virtual_machine" "sit" {

for_each = var.vms

# Penamaan VM
name = each.value.name

resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
datastore_id = data.vsphere_datastore.datastore.id
datacenter_id = data.vsphere_datacenter.datacenter.id

tags = [        
    "${vsphere_tag.environment.id}",
    "${vsphere_tag.lokasi.id}"   
  ]

#Definisikan resource VM cpu dan memory
num_cpus = each.value.cpu_count
memory = each.value.memory

guest_id = data.vsphere_virtual_machine.template.guest_id

enable_disk_uuid = true
#Digunakan untuk waktu tunggu sampai dengan interface dan ip address up ketika pembuatan ke VM selanjutnya
wait_for_guest_ip_timeout = -1
wait_for_guest_net_timeout = -1
wait_for_guest_net_routable = false

network_interface {
  network_id = data.vsphere_network.eth0.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
}

#Digunakan untuk so resources_static disk
disk {
   label            = resources_static.local_disk_label
   size             = data.vsphere_virtual_machine.template.disks.0.size
   eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
   thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
}

#Digunakan untuk disk app
disk {
    name = each.value.app_disk_label
    size = each.value.app_disk_size
    unit_number = 1
  }

clone {
  template_uuid = data.vsphere_virtual_machine.template.id
  timeout = 240
  customize {
    timeout = 240
    
    linux_options {
      host_name = each.value.name
      domain = resources_static.domain
    }
    
     network_interface {
        ipv4_address = each.value.ipv4_data
        ipv4_netmask = resources_static.ipv4_netmask
      }

      ipv4_gateway = resources_static.ipv4_gw
	  dns_server_list = resources_static.dns
  }

#Digunakan untuk konfigurasi tambahan setelah VM Up
  provisioner "local-exec" {
    command = "start-sleep 120"
  interpreter = ["PowerShell", "-Command"]
  }
 
 provisioner "file" {
    source      = "scripts_post_conf/part_second_disk.sh"
    destination = "/tmp/part_second_disk.sh"
    connection {
			host = self.default_ip_address
      type = "ssh"
			insecure = true
      timeout = "5m"
			user	= root
			password = server
      script_path = "/tmp/part_second_disk.sh"
      }  
}

   provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/part_second_disk.sh",
      "/bin/bash /tmp/part_second_disk.sh args",
    ]
  connection {
			host = self.default_ip_address
      type = "ssh"
			insecure = true
      timeout = "5m"
			user	= var.vm_username
			password = var.vm_password
      }  

  }

}