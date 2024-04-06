variable "group_name" {
  type        = string
  description = "Value of the group name. It is converted to lowercase with a dash `-` as separator per convention"
}

variable "group_description" {
  description = "Value of the group description"
  type        = string
}

variable "rule_expression" {
  description = "A rule that determines the group membership"
  type        = string
  default     = null
}

variable "rule_status" {
  description = "Status of the group rule, either ACTIVE or INACTIVE"
  type        = string
  default     = "ACTIVE"
}

variable "remove_assigned_users" {
  description = "Remove users from the group if the rule is deleted"
  type        = bool
  default     = false
}

variable "members" {
  description = "Value of the group members email addresses"
  type        = list(string)
  default     = []
}

variable "track_all_users" {
  description = "Ensure only the users on the list are members of the group, will remove any manually added users"
  type        = bool
  default     = false
}

variable "apps_assignment_group" {
  description = "Create a dedicated application assignment group with the name `apps-[group-name]`, members are the same as the main group"
  type        = bool
  default     = false
}

variable "apps" {
  description = "Value of the applications to assign to the group"
  type        = list(any)
  default     = []
}

variable "apps_with_profile" {
  description = "Value of the applications to assign to the group with profile attributes"
  type        = map(string)
  default     = {}
}

variable "group_attributes" {
  description = "Value of the group attributes to set on the group object in Okta"
  type        = map(string)
  default     = {}
}

variable "slack_handle" {
  description = "Value of the slack handle to set on the group object in Okta"
  type        = string
  default     = null
}

variable "provision_github_group" {
  description = "Provision the group in Github"
  type        = bool
  default     = false
}

variable "github_parent_team" {
  description = "Parent team in Github"
  type        = string
  default     = null
}
