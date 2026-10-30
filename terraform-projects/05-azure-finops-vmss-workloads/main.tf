# ==============================================================================
# ENTERPRISE FINOPS & HIGH-AVAILABILITY VM SCALE SETS (VMSS)
# Architect: Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)
# Pattern: Multi-AZ VMSS with dynamic auto-scaling via for_each over map(object)
# ==============================================================================

resource "azurerm_resource_group" "vmss" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------
# 1. LINUX VIRTUAL MACHINE SCALE SETS (FOR_EACH OVER MAP(OBJECT))
# ------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine_scale_set" "scale_sets" {
  for_each = var.vm_scale_sets

  name                = each.value.name
  resource_group_name = azurerm_resource_group.vmss.name
  location            = var.location
  sku                 = each.value.sku
  instances           = each.value.instances
  admin_username      = var.admin_username
  zones               = each.value.zones
  upgrade_mode        = each.value.upgrade_mode
  custom_data         = each.value.custom_data
  tags                = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = each.value.os_disk_type
    caching              = "ReadWrite"
    disk_size_gb         = each.value.os_disk_size_gb
  }

  network_interface {
    name    = "nic-${each.key}"
    primary = true

    ip_configuration {
      name      = "ipconfig-primary"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

# ------------------------------------------------------------------------------
# 2. DYNAMIC FINOPS METRIC-BASED AUTOSCALE MONITORING RULES
# ------------------------------------------------------------------------------
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  for_each = {
    for k, v in var.vm_scale_sets : k => v
    if v.autoscale_config != null
  }

  name                = "autoscale-${each.value.name}"
  resource_group_name = azurerm_resource_group.vmss.name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.scale_sets[each.key].id
  tags                = var.tags

  profile {
    name = "defaultProfile"

    capacity {
      default = each.value.autoscale_config.default_instances
      minimum = each.value.autoscale_config.min_instances
      maximum = each.value.autoscale_config.max_instances
    }

    # SCALE OUT RULE (HIGH CPU LOAD)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.scale_sets[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = each.value.autoscale_config.cpu_scale_out_pct
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT5M"
      }
    }

    # SCALE IN RULE (LOW CPU LOAD - FINOPS OPTIMIZATION)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.scale_sets[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = each.value.autoscale_config.cpu_scale_in_pct
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
