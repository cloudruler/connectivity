provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "common" {
  source  = "app.terraform.io/cloudruler/common/cloudruler"
  version = "1.0.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-connectivity"
  location = var.location
}

module "hub1" {
  source                  = "./modules/hub"
  name                    = "hub1-${module.common.region_codes[var.location]}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]
}
