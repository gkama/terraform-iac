provider "azurerm" {
 version = "=2.0.0"
 features { }  
}

locals {
  resource_group_name = "terraform-iac"
  location = "eastus"
}


resource "azurerm_resource_group" "rg" {
 name     = local.resource_group_name
 location = local.location
}
