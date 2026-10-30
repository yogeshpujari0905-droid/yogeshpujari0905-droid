variable "location" {
  description = "Azure region for private endpoint resources."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Resource group hosting private endpoints."
  type        = string
  default     = "rg-enterprise-paas-mesh-prod"
}

variable "subnet_id" {
  description = "Resource ID of the dedicated Private Endpoints subnet."
  type        = string
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default = {
    Environment = "Production"
    Architect   = "Yogesh Pujari"
    ManagedBy   = "Terraform"
    Tier        = "Private-PaaS-Mesh"
  }
}

variable "private_endpoints" {
  description = "Map of private endpoints deployed across PaaS services using for_each over map(object)."
  type = map(object({
    name                           = string
    private_connection_resource_id = string
    subresource_names              = list(string)
    is_manual_connection           = optional(bool, false)
    private_dns_zone_ids           = optional(list(string), [])
  }))
}

variable "private_dns_zones" {
  description = "Map of private DNS zones to deploy and link to the central hub VNet."
  type = map(object({
    name             = string
    link_vnet_id     = string
    auto_registration = optional(bool, false)
  }))
  default = {}
}
