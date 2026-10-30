output "management_group_ids" {
  description = "Map of management group keys to their Azure resource IDs."
  value       = { for k, v in azurerm_management_group.mg_tree : k => v.id }
}

output "policy_assignment_ids" {
  description = "Map of policy assignment keys to their assignment resource IDs."
  value       = { for k, v in azurerm_management_group_policy_assignment.initiatives : k => v.id }
}
