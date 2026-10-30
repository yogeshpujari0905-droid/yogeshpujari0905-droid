output "resource_group_name" {
  description = "The deployed central networking resource group name."
  value       = azurerm_resource_group.network.name
}

output "virtual_network_ids" {
  description = "Map of virtual network names to their Azure resource IDs."
  value       = { for k, v in azurerm_virtual_network.vnets : k => v.id }
}

output "subnet_ids" {
  description = "Map of flattened subnet keys to their Azure resource IDs."
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "route_table_ids" {
  description = "Map of route table keys to their Azure resource IDs."
  value       = { for k, v in azurerm_route_table.route_tables : k => v.id }
}

output "network_security_group_ids" {
  description = "Map of NSG keys to their Azure resource IDs."
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}
