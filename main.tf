provider "azurerm" {
  features {}
}

module "common" {
  source  = "app.terraform.io/cloudruler/common/cloudruler"
  version = "1.0.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-connectivity"
  location = var.location
}

module "dns_zone_cloudruler_io" {
  source              = "./modules/dns_zone"
  resource_group_name = azurerm_resource_group.rg.name
  domain              = "cloudruler.io"
  domain_key          = "cloudruler-io"
  #nameservers         = ["ns1-03.azure-dns.com.", "ns2-03.azure-dns.net.", "ns3-03.azure-dns.org.", "ns4-03.azure-dns.info."]
}

module "dns_zone_cloudruler_org" {
  source              = "./modules/dns_zone"
  resource_group_name = azurerm_resource_group.rg.name
  domain              = "cloudruler.org"
  domain_key          = "cloudruler-org"
  #nameservers         = []
}

module "dns_zone_cloudruler_dev" {
  source              = "./modules/dns_zone"
  resource_group_name = azurerm_resource_group.rg.name
  domain              = "cloudruler.dev"
  domain_key          = "cloudruler-dev"
  #nameservers         = []
}

module "hub1" {
  source                  = "./modules/hub"
  name                    = "hub1-${module.common.region_codes[var.location]}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]
}
