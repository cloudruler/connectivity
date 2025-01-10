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

#MX record from MXroute
resource "azurerm_dns_mx_record" "dns_mx_root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  record {
    preference = 10
    exchange   = "glacier.mxrouting.net"
  }

  record {
    preference = 20
    exchange   = "glacier-relay.mxrouting.net"
  }
}

resource "azurerm_dns_txt_record" "dns_txt_root" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  #SPF record from MXroute
  record {
    value = "v=spf1 include:mxlogin.com -all"
  }
}

resource "azurerm_dns_txt_record" "dns_txt_dkim" {
  name                = "x._domainkey"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600

  #DKIM from MXroute control panel
  record {
    value = "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3e14pVzgLEtvZxPUDqSMZcR7y4KaAX3JvPlE26zcNsu2b5yzeSs+86y23sdI2esgRIs9tV3cLZ49xWi4NpLC5uQQDiTUn8DiU/2lKgF2MdvtG/R2dsCU8SeYPZpSs6xUM7icNDAMKti+UTJLTujComgcgBI7vyJqTjCqv/qq4GYgc8OoCg3Bl2exqlko319dtcn+0j2lft6hMXWl9yUlk0fuV/C5uyivx4OgoxzOD9cT8BA3yE/i8xN5H7N5vXMIzl/lxDucYU/I3PyT0wQj1tHDQiUjsOYsoe+cZXGSTnt+ILPbhbO/bt9DzxPxVgllvq0pxCPrlxcRfDgcEALSTwIDAQAB"
  }
}

