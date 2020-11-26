# Tag Categories #
resource "vsphere_tag_category" "tag-environment" {    
  name = "Environment"    
  cardinality = "SINGLE"
  associable_types = [        
    "VirtualMachine"    
  ]
} 

resource "vsphere_tag_category" "tag-role" {    
  name = "ROLES"    
  cardinality = "SINGLE"
  associable_types = [        
    "VirtualMachine"    
  ]
} 

# Tag Environment Variables #
resource "vsphere_tag" "tag-environment-dev" {    
  name = "LAB"    
  category_id = vsphere_tag_category.tag-environment.id
  description = "ENVIRONMENT LAB FOR ANSIBLE"
}

resource "vsphere_tag" "tag-role-ansible" {    
  name = "MASTER NODE"    
  category_id = vsphere_tag_category.tag-role.id
  description = "ENVIRONMENT LAB FOR ANSIBLE"
}