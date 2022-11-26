terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "orchsky-storage"
    storage_account_name = "orchskystorage"
    container_name       = "orchsky-tf"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}