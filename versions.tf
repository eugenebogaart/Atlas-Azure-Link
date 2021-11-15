terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.45"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "=10.0.2"
    }
  }
  required_version = ">= 0.13"
}
