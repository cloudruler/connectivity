resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain
  resource_group_name = var.resource_group_name
  #soa_record {
  #  email     = "azuredns-hostmaster.microsoft.com"
  #  host_name = "ns1-03.azure-dns.com."
  #}
  lifecycle {
    prevent_destroy = true
  }
}

# resource "azurerm_dns_ns_record" "dns_ns_root" {
#   name                = "@"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = var.resource_group_name
#   ttl                 = 172800
#   records             = var.nameservers
# }

resource "azurerm_dns_mx_record" "dns_mx_root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  record {
    preference = 0
    exchange   = "${var.domain_key}.mail.protection.outlook.com."
  }
}

resource "azurerm_dns_txt_record" "dns_txt_root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  #Required by Sender Policy Framework (SPF) to prevent spam e-mail using the domain
  record {
    value = "v=spf1 include:spf.protection.outlook.com -all"
  }

  #Old record, not sure why this would be here. Probably domain verification
  #record {
  #  value = "p20sqjgfv8e4ghqf3r1e9v7q7t"
  #}
}

#Required by Microsoft 365
resource "azurerm_dns_cname_record" "dns_cname_m365_autodiscover" {
  name                = "autodiscover"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "autodiscover.outlook.com."
}

#Required by Microsoft 365
resource "azurerm_dns_cname_record" "dns_cname_m365_sip" {
  name                = "sip"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "sipdir.online.lync.com."
}

#Required by Microsoft 365
resource "azurerm_dns_cname_record" "dns_cname_m365_lyncdiscover" {
  name                = "lyncdiscover"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "webdir.online.lync.com."
}

#Required by Mobile Device Management
resource "azurerm_dns_cname_record" "dns_cname_mdm_enterpriseregistration" {
  name                = "enterpriseregistration"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "enterpriseregistration.windows.net."
}

#Required by Mobile Device Management
resource "azurerm_dns_cname_record" "dns_cname_mdm_enterpriseenrollment" {
  name                = "enterpriseenrollment"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "enterpriseenrollment.manage.microsoft.com."
}

#Required by Microsoft
resource "azurerm_dns_srv_record" "dns_srv_m365_sip_tls" {
  name                = "_sip._tls"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  record {
    priority = 100
    weight   = 1
    port     = 443
    target   = "sipdir.online.lync.com."
  }
}

#Required by Microsoft
resource "azurerm_dns_srv_record" "dns_srv_m365_sip_fedtls" {
  name                = "_sipfederationtls._tcp"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  record {
    priority = 100
    weight   = 1
    port     = 5061
    target   = "sipfed.online.lync.com."
  }
}
