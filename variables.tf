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

variable "source_ip" {
  description = "Limit vm access to this ip_address"
  type = string
}

