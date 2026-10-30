# ==============================================================================
# ENTERPRISE AZURE CAF GOVERNANCE & POLICY AS CODE
# Architect: Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)
# Pattern: Hierarchical Management Group Tree & Policy as Code via for_each
# ==============================================================================

resource "azurerm_management_group" "mg_tree" {
  for_each = var.management_groups

  name                       = each.key
  display_name               = each.value.display_name
  parent_management_group_id = each.value.parent_management_group_id != null ? (
    can(azurerm_management_group.mg_tree[each.value.parent_management_group_id].id) ? 
    azurerm_management_group.mg_tree[each.value.parent_management_group_id].id : 
    each.value.parent_management_group_id
  ) : null

  subscription_ids = each.value.subscription_ids
}

resource "azurerm_management_group_policy_assignment" "initiatives" {
  for_each = var.policy_assignments

  name                 = each.value.name
  display_name         = each.value.display_name
  management_group_id  = azurerm_management_group.mg_tree[each.value.management_group_key].id
  policy_definition_id = each.value.policy_definition_id
  enforce              = each.value.enforce
  parameters           = each.value.parameters

  location = "eastus2"
  identity {
    type = "SystemAssigned"
  }
}
