# Introduction 
This is the connectivity module. All foundational networking for the enterpise is located here.

#Migrating state
terraform import azurerm_resource_group.rg /subscriptions/2fb80bcc-8430-4b66-868b-8253e48a8317/resourceGroups/rg-connectivity
terraform import module.dns_zone_cloudruler_io.azurerm_dns_zone.dns_zone /subscriptions/2fb80bcc-8430-4b66-868b-8253e48a8317/resourceGroups/rg-connectivity/providers/Microsoft.Network/dnszones/cloudruler.io
terraform import module.dns_zone_cloudruler_dev.azurerm_dns_zone.dns_zone /subscriptions/2fb80bcc-8430-4b66-868b-8253e48a8317/resourceGroups/rg-connectivity/providers/Microsoft.Network/dnszones/cloudruler.dev
terraform import module.dns_zone_cloudruler_org.azurerm_dns_zone.dns_zone /subscriptions/2fb80bcc-8430-4b66-868b-8253e48a8317/resourceGroups/rg-connectivity/providers/Microsoft.Network/dnszones/cloudruler.org



https://portal.azure.com/#@cloudruler.io/resource/subscriptions/2fb80bcc-8430-4b66-868b-8253e48a8317/resourceGroups/rg-connectivity/providers/Microsoft.Network/dnszones/cloudruler.io/overview