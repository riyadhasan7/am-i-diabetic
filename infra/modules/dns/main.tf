# private dns zone for mysql flexible server
resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
  tags               = var.tags
}

# link private dns zone to vnet
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
    name                  = "azure-private-dnslink"
    resource_group_name   = var.resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.dns.name
    virtual_network_id    = var.vnet.id
    registration_enabled  = true
    tags                  = var.tags
    }