output "private_endpoint_ids" {
  description = "Map of private endpoint keys to their resource IDs."
  value       = { for k, v in azurerm_private_endpoint.endpoints : k => v.id }
}

output "private_ip_addresses" {
  description = "Map of private endpoint keys to their allocated private IP addresses."
  value = {
    for k, v in azurerm_private_endpoint.endpoints :
    k => v.private_service_connection[0].private_ip_address
  }
}

output "dns_zone_ids" {
  description = "Map of private DNS zone keys to their resource IDs."
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
}
