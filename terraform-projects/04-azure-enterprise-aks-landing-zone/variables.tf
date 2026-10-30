variable "location" {
  description = "Azure region for AKS deployment."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Resource group hosting the AKS cluster."
  type        = string
  default     = "rg-enterprise-aks-prod"
}

variable "cluster_name" {
  description = "Name of the production AKS cluster."
  type        = string
  default     = "aks-enterprise-core-prod"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS control plane."
  type        = string
  default     = "aks-prod-k8s"
}

variable "kubernetes_version" {
  description = "Kubernetes release version."
  type        = string
  default     = "1.28.5"
}

variable "vnet_subnet_id" {
  description = "Subnet ID hosting the AKS cluster nodes."
  type        = string
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default = {
    Environment = "Production"
    Architect   = "Yogesh Pujari"
    ManagedBy   = "Terraform"
    Tier        = "Container-Platform"
  }
}

variable "system_node_pool" {
  description = "Default critical system node pool specification."
  type = object({
    name                = string
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    os_disk_size_gb     = number
    zones               = list(string)
  })
  default = {
    name                = "syspool"
    vm_size             = "Standard_D4ds_v5"
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 5
    os_disk_size_gb     = 128
    zones               = ["1", "2", "3"]
  }
}

variable "user_node_pools" {
  description = "Map of user node pools (Compute, GPU, Spot) deployed via for_each over map(object)."
  type = map(object({
    name                = string
    vm_size             = string
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 2)
    max_count           = optional(number, 10)
    os_disk_size_gb     = optional(number, 128)
    os_type             = optional(string, "Linux")
    priority            = optional(string, "Regular")
    eviction_policy     = optional(string, null)
    spot_max_price      = optional(number, null)
    zones               = optional(list(string), ["1", "2", "3"])
    node_labels         = optional(map(string), {})
    node_taints         = optional(list(string), [])
  }))
}
