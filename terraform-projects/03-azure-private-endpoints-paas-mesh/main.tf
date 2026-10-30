# ==============================================================================
# ENTERPRISE ZERO-TRUST AZURE PAAS PRIVATE ENDPOINT MESH
# Architect: Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)
# Pattern: Automated Private Endpoints & DNS Group Links via for_each over map(object)
# ==============================================================================

resource "azurerm_resource_group" "paas_mesh" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# 1. CENTRAL PRIVATE DNS ZONES & VNET LINKS
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "zones" {
  for_each = var.private_dns_zones

  name                = each.value.name
  resource_group_name = azurerm_resource_group.paas_mesh.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = var.private_dns_zones

  name                  = "link-${each.key}"
  resource_group_name   = azurerm_resource_group.paas_mesh.name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.key].name
  virtual_network_id    = each.value.link_vnet_id
  registration_enabled  = each.value.auto_registration
  tags                  = var.tags
}

# ------------------------------------------------------------------------------
# 2. PRIVATE ENDPOINTS DEPLOYMENT WITH DNS ZONE GROUPS
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "endpoints" {
  for_each = var.private_endpoints

  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.paas_mesh.name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.private_connection_resource_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = each.value.is_manual_connection
  }

  dynamic "private_dns_zone_group" {
    for_each = length(each.value.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "default-dns-zone-group"
      private_dns_zone_ids = each.value.private_dns_zone_ids
    }
  }
}
