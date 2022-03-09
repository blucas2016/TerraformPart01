terraform {
  required_providers {
    azurerm = {
      version = ">=2.76.0"
    }
    random = {
      version = "3.1.0"
    }
  }
}

locals {
  resource_prefix_name = "TForm2022Example01"  
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = local.resource_prefix_name
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "${local.resource_prefix_name}-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "${local.resource_prefix_name}-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}