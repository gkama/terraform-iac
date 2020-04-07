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


resource "azurerm_resource_group" "terraform-iac" {
 name     = "terraform-iac"
 location = var.location
}


resource "azurerm_service_fabric_cluster" "gkama-servicefabric" {
  name                 = "gkama-servicefabric"
  resource_group_name  = azurerm_resource_group.terraform-iac.name
  location             = azurerm_resource_group.example.location
  reliability_level    = "Bronze"
  upgrade_mode         = "Manual"
  cluster_code_version = "6.5.639.9590"
  vm_image             = "Linux"
  management_endpoint  = "https://example:80"

  node_type {
    name                 = "first"
    instance_count       = 3
    is_primary           = true
    client_endpoint_port = 2020
    http_endpoint_port   = 80
  }
}
