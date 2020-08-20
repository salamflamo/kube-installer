# Tag Categories #
resource "vsphere_tag_category" "tag-environment" {    
  name = "Environment"    
  cardinality = "SINGLE"
  associable_types = [        
    "VirtualMachine"    
  ]
} 

# Tag Environment Variables #
resource "vsphere_tag" "tag-environment-dev" {    
  name = "LAB"    
  category_id = vsphere_tag_category.tag-environment.id
  description = "LAB-MSI"
} 