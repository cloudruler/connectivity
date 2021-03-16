#For resources in sandbox workspace
resource "azurerm_public_ip" "pip_k8s" {
  name                = "pip-k8s"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "cloudruler-k8s"
}

resource "azurerm_dns_a_record" "dns_a_k8s" {
  name                = "k8s"
  zone_name           = module.dns_zone_cloudruler_io.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  target_resource_id  = azurerm_public_ip.pip_k8s.id
}

resource "azurerm_application_security_group" "asg_k8s_master" {
  name                = "asg-k8s-master"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

}