variable "group_name" {
  type = string
}

variable "group_description" {
  type = string
}

variable "rule_expression" {
  type    = string
  default = null
}

variable "rule_status" {
  type    = string
  default = "ACTIVE"
}

variable "members" {
  type    = list(string)
  default = []
}

variable "track_all_users" {
  type    = bool
  default = false
}

variable "apps_assignment_group" {
  type    = bool
  default = false
}