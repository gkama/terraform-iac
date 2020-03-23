variable subscription-id {}
variable tenant-id {}
variable client-id {}
variable client-secret {}
variable location {}

provider "azurerm" {
 version = "=2.0.0"
 features {}
 subscription_id = var.subscription-id
 tenant_id = var.tenant-id
 client_id = var.client-id
 client_secret = var.client-secret
}

locals {
  resource_group_name = "terraform-iac"
}

resource "azurerm_resource_group" "rg" {
 name     = local.resource_group_name
 location = var.location
}
