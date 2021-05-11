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
    dc                  = "LAB-MSI"
    compute_host        = "192.168.230.11"
    cluster             = "LAB-MSI"
   # resource_pool_id    = "sit_resource_pool"
    datastore           = "EMC-DS1"
    vnic                = "VM Network"
    template            = "os_images_sit"
    local_disk_label     = "OS-disk0"
    domain              = "corp.bi.go.id"
    ipv4_netmask        = "25"
    dns                 = ["192.168.234.74", "8.8.8.8"]
    ipv4_gw             = "192.168.234.126"
    cpu_hot_add_enabled        = "true"
    memory_hot_add_enabled     = "true"
    
}


# Definisikan variable untuk resources yang bersifat dinamis, seperti cpu, memory
variable "vms" {
    type = map
    default = {
      ICE-XS-UPF = {
        name            = "ICE-XS-UPF"
        ipv4_data       = "192.168.234.77"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "ICE-XS-UPF-disk1.vmdk"
        app_disk_size   = "2"
      },
     CCENTER = {
        name            = "CCENTER"
        ipv4_data       = "192.168.234.78"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "CCENTER-disk1.vmdk"
        app_disk_size   = "1"
      },
      RT-DB = {
        name            = "RT-DB"
        ipv4_data       = "192.168.234.79"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "RT-DB-disk1.vmdk"
        app_disk_size   = "3"
      },
      NRT-UI-DB = {
        name            = "NRT-UI-DB"
        ipv4_data       = "192.168.234.81"
        cpu_count       = "1"
        memory          = "1024"
        app_disk_label  = "NRT-UI-DB-disk1.vmdk"
        app_disk_size   = "1"
      },
    }
  }