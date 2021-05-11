terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "1.26.0"
    }
  }
  required_version = ">= 0.12"
}


# Defisnikan variable untuk menghubungkan ke vSphere vCenter
provider "vsphere" {
user = var.vsphere_username
password = var.vsphere_password
vsphere_server = "192.168.234.76"
# If you have a self-signed cert
allow_unverified_ssl = true
}


############ Defisikan Data Sources Data Center VMware vSphere

# Defisikan Data Sources Nama Datacenter VMware vSphere
data "vsphere_datacenter" "dc" {
  name = local.dc
}

# Defisikan Data Sources HOST ESXI Cluster VMware vSphere
data "vsphere_host" "hosts" {
  name          = local.compute_host
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Defisikan Data Sources Cluster VMware vSphere
data "vsphere_compute_cluster" "compute_cluster" {
  name          = local.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Defisikan Data Sources Resource Pool Cluster VMware vSphere
#data "vsphere_resource_pool" "pool" {
#  name          = local.resource_pool_id
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

# Defisikan Data Sources Datastrore VMware vSphere
data "vsphere_datastore" "datastore" {
  name          = local.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Defisikan Data Sources Network for Guest VM VMware vSphere
data "vsphere_network" "eth0" {
  name          = local.vnic
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Defisikan Data Sources VM Template VMware vSphere
data "vsphere_virtual_machine" "template" {
  name          = local.template
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
resource "vsphere_virtual_machine" "vm" {

for_each = var.vms

# Penamaan VM
name = each.value.name
#datacenter_id = data.vsphere_datacenter.dc.id
resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
datastore_id = data.vsphere_datastore.datastore.id

tags = [        
    "${vsphere_tag.environment.id}",
    "${vsphere_tag.lokasi.id}"   
  ]

#Definisikan resource VM cpu dan memory
num_cpus = each.value.cpu_count
memory = each.value.memory

guest_id = data.vsphere_virtual_machine.template.guest_id
cpu_hot_add_enabled        = local.cpu_hot_add_enabled
memory_hot_add_enabled     = local.memory_hot_add_enabled

scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
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
   label            = local.local_disk_label
   size             = data.vsphere_virtual_machine.template.disks.0.size
   eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
   thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
}

#Digunakan untuk disk app
disk {
    
    size = each.value.app_disk_size
    label = each.value.app_disk_label
    unit_number = 1
  }

clone {
  template_uuid = data.vsphere_virtual_machine.template.id
  timeout = 240
  customize {
    timeout = 240
    
    linux_options {
      host_name = each.value.name
      domain = local.domain
    }
    
     network_interface {
        ipv4_address = each.value.ipv4_data
        ipv4_netmask = local.ipv4_netmask
      }

      ipv4_gateway = local.ipv4_gw
	    dns_server_list = local.dns
      dns_suffix_list = local.domain
  }
}


  provisioner "file" {
    source      = "scripts_post_conf/part_second_disk.sh"
    destination = "/tmp/part_second_disk.sh"
    connection {
			host = each.value.ipv4_data
      type = "ssh"
			insecure = true
      timeout = "5m"
			user	= var.vm_username
			password = var.vm_password
      script_path = "/tmp/part_second_disk.sh"
      }  
}


   provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/part_second_disk.sh",
      "/bin/bash /tmp/part_second_disk.sh args",
    ]
  connection {
			host = each.value.ipv4_data
      type = "ssh"
			insecure = true
      agent = false
      timeout = "5m"
			user	= var.vm_username
			password = var.vm_password
      }  
    }

}





  



