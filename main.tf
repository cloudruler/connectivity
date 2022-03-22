provider "azurerm" {
  features {}
}

module "common" {
  source  = "app.terraform.io/cloudruler/common/cloudruler"
  version = "1.0.0"
}

moved {
  from = module.dns_zone_cloudruler_dev.azurerm_public_ip.pip_domain
  to = azurerm_public_ip.pip_cloudruler_dev
}

moved {
  from = module.dns_zone_cloudruler_org.azurerm_public_ip.pip_domain
  to = azurerm_public_ip.pip_cloudruler_org
}

moved {
  from = module.dns_zone_cloudruler_io.azurerm_public_ip.pip_domain
  to = azurerm_public_ip.pip_cloudruler_io
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
  location            = var.location
}

resource "azurerm_public_ip" "pip_cloudruler_io" {
  name                = "pip-cloudruler-io"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  domain_name_label   = "cloudruler-io"
}

module "dns_zone_cloudruler_org" {
  source              = "./modules/dns_zone"
  resource_group_name = azurerm_resource_group.rg.name
  domain              = "cloudruler.org"
  domain_key          = "cloudruler-org"
  location            = var.location
}

resource "azurerm_public_ip" "pip_cloudruler_org" {
  name                = "pip-cloudruler-org"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  domain_name_label   = "cloudruler-org"
}

module "dns_zone_cloudruler_dev" {
  source              = "./modules/dns_zone"
  resource_group_name = azurerm_resource_group.rg.name
  domain              = "cloudruler.dev"
  domain_key          = "cloudruler-dev"
  location            = var.location
}

resource "azurerm_public_ip" "pip_cloudruler_dev" {
  name                = "pip-cloudruler-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  domain_name_label   = "cloudruler-dev"
}

# module "dns_zone_cloudruler_com" {
#   source              = "./modules/dns_zone"
#   resource_group_name = azurerm_resource_group.rg.name
#   domain              = "cloudruler.com"
#   domain_key          = "cloudruler-com"
#   location            = var.location
# }

module "hub1" {
  source                  = "./modules/hub"
  name                    = "hub1-${module.common.region_codes[var.location]}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip_cloudruler" {
  name                = "pip-cloudruler"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  domain_name_label   = "cloudruler"
}


# moved {
#   from = module.dns_zone_cloudruler_dev.azurerm_dns_a_record.dns_a_root
#   to = azurerm_dns_a_record.dns_a_root
# }

# moved {
#   from = module.dns_zone_cloudruler_dev.azurerm_dns_a_record.dns_a_wildcard
#   to = azurerm_dns_a_record.dns_a_wildcard
# }

# moved {
#   from = module.dns_zone_cloudruler_dev.azurerm_dns_a_record.dns_a_www
#   to = azurerm_dns_a_record.dns_a_www
# }

# moved {
#   from = module.dns_zone_cloudruler_org.azurerm_dns_a_record.dns_a_root
#   to = azurerm_dns_a_record.dns_a_root
# }

# moved {
#   from = module.dns_zone_cloudruler_org.azurerm_dns_a_record.dns_a_wildcard
#   to = azurerm_dns_a_record.dns_a_wildcard
# }

# moved {
#   from = module.dns_zone_cloudruler_org.azurerm_dns_a_record.dns_a_www
#   to = azurerm_dns_a_record.dns_a_www
# }


# moved {
#   from = module.dns_zone_cloudruler_io.azurerm_dns_a_record.dns_a_root
#   to = azurerm_dns_a_record.dns_a_root
# }

# moved {
#   from = module.dns_zone_cloudruler_io.azurerm_dns_a_record.dns_a_wildcard
#   to = azurerm_dns_a_record.dns_a_wildcard
# }

# moved {
#   from = module.dns_zone_cloudruler_io.azurerm_dns_a_record.dns_a_www
#   to = azurerm_dns_a_record.dns_a_www
# }


#Root record
resource "azurerm_dns_a_record" "dns_a_root_dev" {
  depends_on = [ module.dns_zone_cloudruler_dev ]
  name                = "@"
  zone_name           = module.dns_zone_cloudruler_dev.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_dev.id
}

#Handle www
resource "azurerm_dns_a_record" "dns_a_www_dev" {
  depends_on = [ module.dns_zone_cloudruler_dev ]
  name                = "www"
  zone_name           = module.dns_zone_cloudruler_dev.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_dev.id
}

#Handle *
resource "azurerm_dns_a_record" "dns_a_wildcard_dev" {
  depends_on = [ module.dns_zone_cloudruler_dev ]
  name                = "*"
  zone_name           = module.dns_zone_cloudruler_dev.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_dev.id
}

#Root record
resource "azurerm_dns_a_record" "dns_a_root_org" {
  name                = "@"
  zone_name           = module.dns_zone_cloudruler_org.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_org.id
}

#Handle www
resource "azurerm_dns_a_record" "dns_a_www_org" {
  name                = "www"
  zone_name           = module.dns_zone_cloudruler_org.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_org.id
}

#Handle *
resource "azurerm_dns_a_record" "dns_a_wildcard_org" {
  name                = "*"
  zone_name           = module.dns_zone_cloudruler_org.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_org.id
}


#Root record
resource "azurerm_dns_a_record" "dns_a_root_io" {
  name                = "@"
  zone_name           = module.dns_zone_cloudruler_io.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_io.id
}

#Handle www
resource "azurerm_dns_a_record" "dns_a_www_io" {
  name                = "www"
  zone_name           = module.dns_zone_cloudruler_io.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_io.id
}

#Handle *
resource "azurerm_dns_a_record" "dns_a_wildcard_io" {
  name                = "*"
  zone_name           = module.dns_zone_cloudruler_io.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_cloudruler_io.id
}

