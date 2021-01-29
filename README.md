# MongoDB Atlas project private linked into Azure VNet 

## Background
Based on an small Proof of Concept to make Atlas available via Private linking in Azure in the same region, this script was generalized to automate all steps. 
The documentation on how to do this in several manual steps is here: https://docs.atlas.mongodb.com/security-private-endpoint 

The end result of the Terraform script is a project in Atlas + a Cluster + provisioned user, private linked to Azure with a 1 vm with public interface (ssh/key).
The vm has already MongoDB client tools installed.

## Prerequisites:
* Authenticate into Azure via CLI with:  az login
* Have Terraform 0.13+ installed
* Run: terraform init 

```
Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "azurerm" (hashicorp/azurerm) 2.1.0...
- Downloading plugin for provider "mongodbatlas" (terraform-providers/mongodbatlas) 0.8
```

## Config:
* Set up credential, as in section: "Configure Script - Credentials"
* Change basic parameters, as in file : locals.tf
* Run: terraform apply

## Todo:
* Test with terrafrom 14. and mongodb/atlas provider 0.8.1+ (does not work yet)
* Print out private connection string when script finishes. (wait for > 0.8.2)

## Basic Terraform resources in script
* mongodbatlas_project,  creates an empty project in your Atlas account
* mongodbatlas_privatelink_endpoint, create privatelink endpoint
* mongodbatlas_privatelink_endpoint_service, create private link service in Atlas
* mongodbatlas_private_ip_mode,  switches new project to private IP mode so it can be used for peering
* azurerm_resource_group, create a Azure resource group to hold vnet and other resources
* azurerm_virtual_network, create a Azure Virtual Network to peer into
* azurerm_private_endpoint, creates the endpoint in Azure

## In order to provision a Atlas cluster and an Azure VM:
* azurerm_subnet, 
* azurerm_public_ip,
* azurerm_network_security_group,
* azurerm_network_interface,
* azurerm_network_interface_security_group_association,
* azurerm_linux_virtual_machine,
* mongodbatlas_cluster, finally create cluster 

 
## Configure Script - Credentials: "variables.tf"

To configure the providers, such as Atlas and Azure, one needs credentials to gain access.
In case of MongoDB Atlas a public and private key pair is required. 
How to create an API key pair for an existing Atlas organization can be found here:
https://docs.atlas.mongodb.com/configure-api-access/#programmatic-api-keys
These keys are read in environment variables for safety. Alternatively these parameters
can be provide on the command line of the terraform invocation. The MONGODBATLAS provider will read
the 2 distinct variable, as below:

* MONGODB_ATLAS_PUBLIC_KEY=<PUBLICKEY>
* MONGODB_ATLAS_PRIVATE_KEY=<PRIVATEKEY>

Second a Azure subscription is required.  The primary attributes are also expected 
as environment variables. Values need to be provided in TF_VAR_ format.

* TF_VAR_azure_subscription_id=<SUBSCRIPTION_ID>
* TF_VAR_azure_tenant_id=<DIRECTORY_ID>

Third there are several other parameters that are trusted, which should be provided via environment variables.
```
variable "atlas_organization_id" {
  description = "Atlas organization id where to create project & link & project"
  type = string
}

variable "azure_subscription_id" {
  description = "Azure subscription for peering with ..."
  type = string
}

variable "azure_tenant_id" {
  description = "Azure subscription Directory ID"
  type = string
}

variable "ssh_keys_data" {
  description = "Public key"
  type = string
}

variable "public_key_path" {
  description = "Access path to public key"
  type = string
}

variable "private_key_path" {
  description = "Access path to private key"
  type = string
}

variable "admin_password" {
  description = "Generic password for demo resources"
  type = string
}
```

## Other configuration: "locals.tf"

In the locals resource of the locals.tf file, several parameters should be adapted to your needs
```
locals {
  # New empty Atlas project name to create in organization
  project_id            = "Azure-Linked-Project"
  # Atlas region, https://docs.atlas.mongodb.com/reference/microsoft-azure/#microsoft-azure
  region                = "EUROPE_WEST"
  # Atlas cluster name
  cluster_name          = "Sample"
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
  azure_vm_size         = "Standard_F2"
  # Azure vm_name       
  azure_vm_name         = "demo-link"
}
 
terraform {
  required_version = ">= 0.13.5"
}
```


## Give a go

In you favorite shell, run terraform apply and review the execution plan on what will be added, changed and detroyed. Acknowledge by typing: yes 

```
%>  terraform apply
```

Your final result should look like:
```
Apply complete! Resources: 14 added, 0 changed, 0 destroyed.

Outputs:

atlasclusterstring = [
  {
    "aws_private_link" = {}
    "aws_private_link_srv" = {}
    "private" = ""
    "private_srv" = ""
    "standard" = "mongodb://sample-shard-00-00.XXXXX.mongodb.net:27017,sample-shard-00-01.XXXXX.mongodb.net:27017,sample-shard-00-02.XXXXX.mongodb.net:27017/?ssl=true&authSource=admin&replicaSet=atlas-XXXXX-shard-0"
    "standard_srv" = "mongodb+srv://sample.XXXXX.mongodb.net"
  },
]
user1 = testuser
```

Please note that the above endpoints do not include the private string.  It looks like an omission in the version 0.8 of the provider (mongodb/atlas). 

## Known Bugs
* let me know
