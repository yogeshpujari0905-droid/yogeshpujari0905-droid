output "cluster_id" {
  description = "The Azure resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for Workload Identity integration."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "user_node_pool_ids" {
  description = "Map of user node pool keys to their resource IDs."
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.user_pools : k => v.id }
}
