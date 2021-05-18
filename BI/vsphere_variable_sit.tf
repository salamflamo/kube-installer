#Definisikan sensitive variable yang perlu diproteksi
variable "vsphere_username" {
  description = "Vsphere administrator username"
  type        = string
  #sensitive   = true
}

variable "vsphere_password" {
  description = "Vsphere administrator password"
  type        = string
  #sensitive   = true
}


variable "vm_username" {
  description = "Vsphere administrator username"
  type        = string
  #sensitive   = true
}

variable "vm_password" {
  description = "Vsphere administrator password"
  type        = string
  #sensitive   = true
}


#Definisikan variable static untuk setiap resource dari VM yang tidak adakn berubah - berubah
locals {
    dc                  = "Datacenter"
    compute_host        = "esx1.example.com"
    cluster             = "Clus1"
   # resource_pool_id    = "sit_resource_pool"
    datastore           = "ds1"
    vnic                = "DSwitch-VM Network"
    template            = "rhel-7.8-template"
    local_disk_label     = "OS-disk0"
    domain              = "corp.bi.go.id"
    ipv4_netmask        = "24"
    dns                 = ["192.168.16.253", "8.8.8.8"]
    dns_suffix          = ["corp.bi.go.id"]
    ipv4_gw             = "192.168.16.1"
    cpu_hot_add_enabled        = "true"
    memory_hot_add_enabled     = "true"
}


# Definisikan variable untuk resources yang bersifat dinamis, seperti cpu, memory
variable "vms" {
    type = map
    default = {
      ICE-XS-UPF = {
        name            = "ICE-XS-UPF"
        ipv4_data       = "192.168.16.77"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "ICE-XS-UPF-app-disk1"
        app_disk_size   = "1"
      },
     CCENTER = {
        name            = "CCENTER"
        ipv4_data       = "192.168.16.78"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "CCENTER-app-disk1"
        app_disk_size   = "1"
      }
    }
  }

  variable "vms_with_shared_disk" {
    type = map
    default = {
      DB-RT-NRT = {
        name            = "DB-RT-NRT"
        ipv4_data       = "192.168.16.87"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "DB-RT-NRT-app-disk1"
        app_disk_size   = "1"
        shared_disk_label = "DB-RT-NRT-shared-disk1"
        shared_disk_size   = "2"
      }
    }
  }