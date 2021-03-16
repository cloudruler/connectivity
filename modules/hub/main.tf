provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-${var.name}"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_subnet" "snet_hub" {
  name                 = "snet-${var.name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = var.subnet_address_prefixes
}
