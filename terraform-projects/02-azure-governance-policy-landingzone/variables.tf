variable "root_management_group_display_name" {
  description = "Display name for the root enterprise management group."
  type        = string
  default     = "Enterprise-Root-Org"
}

variable "management_groups" {
  description = "Hierarchical management group tree deployed via for_each over map(object)."
  type = map(object({
    display_name               = string
    parent_management_group_id = optional(string, null)
    subscription_ids           = optional(list(string), [])
  }))
}

variable "policy_assignments" {
  description = "Enterprise security policy initiatives assigned across management groups using for_each over map(object)."
  type = map(object({
    name                 = string
    display_name         = string
    policy_definition_id = string
    management_group_key = string
    enforce              = optional(bool, true)
    parameters           = optional(string, null)
  }))
  default = {}
}
