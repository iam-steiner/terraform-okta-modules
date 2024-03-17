
# Create a group with the provided name and description. 
# Names will be converted to lowercase and use a dash `-` as a separator per naming convention
resource "okta_group" "main_group" {
  name        = local.slug_name
  description = var.group_description

  custom_profile_attributes = jsonencode({
    "terraform" = true
  })

}

# Assign users to the main group if provided
resource "okta_group_memberships" "main_group_members" {
  group_id        = okta_group.main_group.id
  users           = local.users_id
  track_all_users = var.track_all_users

  lifecycle {
    precondition {
      condition     = length(local.users_deprovisioned) == 0
      error_message = "Please remove the disabled user(s) ${jsonencode(local.users_deprovisioned)} from the members list and try again"
    }
  }

}

# Create an applications assignment group with prefix apps- if required
resource "okta_group" "apps_assignment_group" {
  count       = var.apps_assignment_group ? 1 : 0
  name        = "apps-${local.slug_name}"
  description = var.group_description

  custom_profile_attributes = jsonencode({
    "terraform" = true
  })

}

# Assign same users from main group to the applications assignment group for consistency
resource "okta_group_memberships" "assignment_group_members" {
  count           = var.apps_assignment_group ? 1 : 0
  group_id        = okta_group.apps_assignment_group[count.index].id
  users           = local.users_id
  track_all_users = var.track_all_users

}

# Add a group rule only if a rule expression is provided
# The rule will include the main group and the applications assignment group if required
resource "okta_group_rule" "group_rule" {
  count             = var.rule_expression != null ? 1 : 0
  name              = local.slug_name
  status            = var.rule_status
  group_assignments = local.check_group_assignments
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = var.rule_expression

}