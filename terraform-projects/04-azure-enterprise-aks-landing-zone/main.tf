# ==============================================================================
# ENTERPRISE AZURE KUBERNETES SERVICE (AKS) LANDING ZONE
# Architect: Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)
# Pattern: Multi-Pool AKS Cluster with for_each over map(object) user node pools
# ==============================================================================

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# 1. CORE AKS CLUSTER WITH SYSTEM-CRITICAL NODE POOL
# ------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  private_cluster_enabled = true # Zero public control plane access
  oidc_issuer_enabled     = true
  workload_identity_enabled = true

  default_node_pool {
    name                = var.system_node_pool.name
    vm_size             = var.system_node_pool.vm_size
    enable_auto_scaling = var.system_node_pool.enable_auto_scaling
    min_count           = var.system_node_pool.min_count
    max_count           = var.system_node_pool.max_count
    os_disk_size_gb     = var.system_node_pool.os_disk_size_gb
    zones               = var.system_node_pool.zones
    vnet_subnet_id      = var.vnet_subnet_id
    only_critical_addons_enabled = true # System pods only
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay" # Modern Azure CNI Overlay
    network_policy      = "azure"
    load_balancer_sku   = "standard"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
  }
}

# ------------------------------------------------------------------------------
# 2. USER NODE POOLS DEPLOYED VIA FOR_EACH OVER MAP(OBJECT)
# ------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster_node_pool" "user_pools" {
  for_each = var.user_node_pools

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  vnet_subnet_id        = var.vnet_subnet_id
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_type               = each.value.os_type
  priority              = each.value.priority
  eviction_policy       = each.value.eviction_policy
  spot_max_price        = each.value.spot_max_price
  zones                 = each.value.zones
  node_labels           = each.value.node_labels
  node_taints           = each.value.node_taints
  tags                  = var.tags
}
