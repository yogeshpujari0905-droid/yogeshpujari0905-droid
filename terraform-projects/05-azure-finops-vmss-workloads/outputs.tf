output "scale_set_ids" {
  description = "Map of VMSS keys to their Azure resource IDs."
  value       = { for k, v in azurerm_linux_virtual_machine_scale_set.scale_sets : k => v.id }
}

output "autoscale_setting_ids" {
  description = "Map of VMSS keys to their autoscale setting IDs."
  value       = { for k, v in azurerm_monitor_autoscale_setting.autoscale : k => v.id }
}
