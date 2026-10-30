variable "location" {
  description = "Azure region for compute workloads."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Resource group hosting the VMSS workloads."
  type        = string
  default     = "rg-enterprise-workload-vmss-prod"
}

variable "subnet_id" {
  description = "Subnet ID hosting the VMSS instances."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for Linux VM instances."
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for instance authentication."
  type        = string
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default = {
    Environment = "Production"
    Architect   = "Yogesh Pujari"
    ManagedBy   = "Terraform"
    Tier        = "Compute-ScaleSets"
  }
}

variable "vm_scale_sets" {
  description = "Map of VM Scale Sets deployed across availability zones using for_each over map(object)."
  type = map(object({
    name             = string
    sku              = string
    instances        = number
    zones            = list(string)
    upgrade_mode     = optional(string, "Automatic")
    os_disk_type     = optional(string, "Premium_LRS")
    os_disk_size_gb  = optional(number, 128)
    custom_data      = optional(string, null)
    autoscale_config = optional(object({
      min_instances     = number
      max_instances     = number
      default_instances = number
      cpu_scale_out_pct = number
      cpu_scale_in_pct  = number
    }), null)
  }))
}
