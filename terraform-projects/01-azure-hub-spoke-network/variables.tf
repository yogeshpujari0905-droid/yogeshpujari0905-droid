variable "location" {
  description = "Azure region for resource deployment."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the central networking resource group."
  type        = string
  default     = "rg-enterprise-network-hub-prod"
}

variable "tags" {
  description = "Resource tags applied to all networking resources."
  type        = map(string)
  default = {
    Environment = "Production"
    Architect   = "Yogesh Pujari"
    ManagedBy   = "Terraform"
    Framework   = "Azure-CAF"
  }
}

variable "virtual_networks" {
  description = "Map of virtual networks to deploy using for_each with map(object)."
  type = map(object({
    name          = string
    address_space = list(string)
    dns_servers   = optional(list(string), [])
    subnets = map(object({
      name                                          = string
      address_prefixes                              = list(string)
      service_endpoints                             = optional(list(string), [])
      private_endpoint_network_policies            = optional(string, "Disabled")
      private_link_service_network_policies_enabled = optional(bool, false)
      delegations = optional(map(object({
        service_name = string
        actions      = list(string)
      })), {})
    }))
  }))
}

variable "route_tables" {
  description = "Map of User Defined Route (UDR) tables enforcing zero-trust traffic redirection to Azure Firewall."
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = optional(bool, false)
    routes = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string, null)
    }))
  }))
  default = {}
}

variable "network_security_groups" {
  description = "Map of Network Security Groups (NSGs) with dynamic security rules."
  type = map(object({
    name = string
    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string, null)
      destination_port_ranges    = optional(list(string), null)
      source_address_prefix      = optional(string, null)
      source_address_prefixes    = optional(list(string), null)
      destination_address_prefix = optional(string, null)
    }))
  }))
  default = {}
}
