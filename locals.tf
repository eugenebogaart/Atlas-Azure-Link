locals {
  # New empty Atlas project name to create in organization
  project_id            = "Azure-Linked-Project"
  # Atlas region, https://docs.atlas.mongodb.com/reference/microsoft-azure/#microsoft-azure
  region                = "EUROPE_WEST"
  # Atlas cluster name
  cluster_name		= "Sample"
  # Atlas Public providor
  provider_name         = "AZURE"
  # A Azure resource group
  resource_group_name   = "atlas-demo-link"
  # Associated Azure vnet
  vnet_name             = "atlas-link-vnet"
  # Azure location
  location              = "West Europe"
  # Azure alt location (ips and sec groups use this)
  location_alt          = "westeurope"
  # Azure cidr block for vnet
  address_space         = ["10.12.4.0/23"]
  # Azure subnet in vnet
  subnet                = "subnet2"
  # Azure subnet cidr
  subnet_address_space  = "10.12.4.192/26"
  # Azure vm admin_user
  admin_username        = "testuser"
  # Azure vm size
  azure_vm_size		= "Standard_F2"
  # Azure vm_name	
  azure_vm_name		= "demo-link"
}
 
