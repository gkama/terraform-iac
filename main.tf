variable subscription_id {}
variable tenant_id {}
variable client_id {}
variable client_secret {}
variable location {}
variable environment {}


provider "azurerm" {
 version = "~> 2.0.0"
 features {}
 subscription_id = var.subscription_id
 tenant_id = var.tenant_id
 client_id = var.client_id
 client_secret = var.client_secret
}


resource "azurerm_resource_group" "rg" {
 name     = "terraform-iac"
 location = var.location

 tags     = {
    environment = var.environment
  }
}


resource "azurerm_application_insights" "Heimdall" {
  name                = "Heimdall"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"

  tags                = {
    environment = var.environment
  }
}

output "heimdall_instrumentation_key" {
  value = azurerm_application_insights.Heimdall.instrumentation_key
}

output "heimdall_app_id" {
  value = azurerm_application_insights.Heimdall.app_id
}


resource "azurerm_container_registry" "gkama" {
  name                     = "gkama"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = false

  tags                     = {
    environment = var.environment
  }
}