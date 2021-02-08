terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "= 0.8.2"
    }
  }
  required_version = ">= 0.13"
}
