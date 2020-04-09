variable subscription_id {}
variable tenant_id {}
variable client_id {}
variable client_secret {}
variable location {}
variable environment {}


provider "azurerm" {
 version = "~> 2.0.0"
 subscription_id = var.subscription_id
 tenant_id = var.tenant_id
 client_id = var.client_id
 client_secret = var.client_secret

 features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "terraform-iac"
  location = var.location
  
  tags = {
    environment = var.environment
  }
}


resource "azurerm_key_vault" "backend-api-vault" {
  name                        = "backend-api-vault"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tenant_id                   = var.tenant_id
  soft_delete_enabled         = false
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.client_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = {
    environment = var.environment
  }
}


resource "azurerm_application_insights" "Heimdall" {
  name                = "Heimdall"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"

  tags = {
    environment = var.environment
  }
}

output "heimdall_instrumentation_key" {
  value = azurerm_application_insights.Heimdall.instrumentation_key
}

output "heimdall_app_id" {
  value = azurerm_application_insights.Heimdall.app_id
}


resource "azurerm_container_registry" "gkamacr" {
  name                     = "gkamacr"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = false

  tags = {
    environment = var.environment
  }
}


resource "azurerm_storage_account" "gkama-storage-account" {
  name                     = "gkamastorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}


resource "azurerm_app_service_plan" "gkama-service-plan" {
  name                = "gkama-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags = {
    environment = var.environment
  }
}