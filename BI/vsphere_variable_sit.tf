#Definisikan sensitive variable yang perlu diproteksi
variable "vsphere_username" {
  description = "Vsphere administrator username"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "Vsphere administrator password"
  type        = string
  sensitive   = true
}


variable "vm_username" {
  description = "Vsphere administrator username"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "Vsphere administrator password"
  type        = string
  sensitive   = true
}


#Definisikan variable static untuk setiap resource dari VM yang tidak adakn berubah - berubah
resources_static {
    datacenter          = "DC"
    compute_host        = "10.10.10.10"
    cluster             = "All_Cluster"
    resource_pool_id    = "sit_resource_pool"
    datastore           = "datastore"
    vnic                = "VM Network"
    template            = "/SIT"
    local_disk_label     = "OS_disk0"
    domain              = "corp.bi.go.id"
    ipv4_netmask        = "24"
    dns                 = ["10.0.226.251", "8.8.8.8"]
    ipv4_gw             = "10.0.222.1"
    }


# Definisikan variable untuk resources yang bersifat dinamis, seperti cpu, memory
variable "vms" {
    type = map
    default = {
      ICE-XS-UPF = {
        name            = "ICE-XS-UPF"
        ipv4_data       = "x.x.x.x"
        cpu_count       = "4"
        memory          = "32"
        app_disk_label  = "ICE-XS-UPF"
        app_disk_size   = "500"
      },
     CCENTER = {
        name            = "ICE-XS-UPF"
        ipv4_data       = "x.x.x.x"
        cpu_count       = "2"
        memory          = "24"
        app_disk_label  = "ICE-XS-UPF"
        app_disk_size   = "350"
      },
      RT-DB = {
        name            = "RT-DB"
        ipv4_data       = "x.x.x.x"
        cpu_count       = "4"
        memory          = "16"
        app_disk_label  = "RT-DB"
        app_disk_size   = "200"
      },
      NRT-UI-DB = {
        name            = "NRT-UI-DB"
        ipv4_data       = "x.x.x.x"
        cpu_count       = "4"
        memory          = "16"
        app_disk_label  =
        app_disk_size   = 
      },
    }
  }