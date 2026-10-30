# ==============================================================================
# ENTERPRISE AZURE CAF HUB-AND-SPOKE NETWORK DEPLOYMENT
# Architect: Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)
# Pattern: Data-driven for_each over map(object) with dynamic blocks
# ==============================================================================

resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# 1. VIRTUAL NETWORKS DEPLOYMENT (FOR_EACH OVER MAP(OBJECT))
# ------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnets" {
  for_each = var.virtual_networks

  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# 2. FLATTENED SUBNET MAP GENERATION (FOR_EACH OVER COMPOSITE KEYS)
# ------------------------------------------------------------------------------
locals {
  subnets_flattened = merge([
    for vnet_key, vnet_val in var.virtual_networks : {
      for subnet_key, subnet_val in vnet_val.subnets :
      "${vnet_key}.${subnet_key}" => merge(subnet_val, {
        vnet_key  = vnet_key
        vnet_name = vnet_val.name
      })
    }
  ]...)
}

resource "azurerm_subnet" "subnets" {
  for_each = local.subnets_flattened

  name                                          = each.value.name
  resource_group_name                           = azurerm_resource_group.network.name
  virtual_network_name                          = azurerm_virtual_network.vnets[each.value.vnet_key].name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies            = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegations
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}

# ------------------------------------------------------------------------------
# 3. ROUTE TABLES WITH DYNAMIC UDR RULES (FOR_EACH OVER MAP(OBJECT))
# ------------------------------------------------------------------------------
resource "azurerm_route_table" "route_tables" {
  for_each = var.route_tables

  name                          = each.value.name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = var.tags

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

# ------------------------------------------------------------------------------
# 4. NETWORK SECURITY GROUPS WITH DYNAMIC SECURITY RULES
# ------------------------------------------------------------------------------
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.network_security_groups

  name                = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      source_address_prefixes    = security_rule.value.source_address_prefixes
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# ------------------------------------------------------------------------------
# 5. HUB-TO-SPOKE BI-DIRECTIONAL VNET PEERINGS (AUTOMATED FOR_EACH)
# ------------------------------------------------------------------------------
locals {
  spoke_vnet_keys = [for k in keys(var.virtual_networks) : k if k != "hub"]
}

resource "azurerm_virtual_network_peering" "hub_to_spokes" {
  for_each = toset(local.spoke_vnet_keys)

  name                         = "peer-hub-to-${each.value}"
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.vnets["hub"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets[each.value].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "spokes_to_hub" {
  for_each = toset(local.spoke_vnet_keys)

  name                         = "peer-${each.value}-to-hub"
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.vnets[each.value].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["hub"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}
