terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.45"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "=1.4.4"
    }
  }
  required_version = ">= 1.0"
}
