variable subscription_id {}
variable tenant_id {}
variable client_id {}
variable client_secret {}
variable location {}

provider "azurerm" {
 version = "~> 2.0.0"
 features {}
 subscription_id = var.subscription_id
 tenant_id = var.tenant_id
 client_id = var.client_id
 client_secret = var.client_secret
}

locals {
  resource_group_name = "terraform_iac"
}

resource "azurerm_resource_group" "rg" {
 name     = local.resource_group_name
 location = var.location
}
