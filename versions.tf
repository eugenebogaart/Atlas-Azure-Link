terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.45"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "=1.0.2"
    }
  }
  required_version = ">= 1.0"
}
