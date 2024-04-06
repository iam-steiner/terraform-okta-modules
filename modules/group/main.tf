/**
  * # Terraform Module - Okta Group
  *
  * Create a group in Okta with some extended functionality.
  *
  * ## Features
  * - Manage the group membership from a [group rule](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-create-group-rules.htm)
  * - Manage the group membership from a list of users
  * - Create an additional group `apps-[group-name]`. This additional group is required
  *   by Okta for application assignments as described [here](https://help.okta.com/oie/en-us/content/topics/users-groups-profiles/app-assignments-group-push.htm)
  * - Assign applications to the group
  * - Provision and sync the group with Github
  * - Provision and sync the group with a Slack handle (depends on the Slack Handle Sync daily job)
  */

# Create a group with the provided name and description.
# Names will be converted to lowercase and use a dash `-` as a separator per naming convention
resource "okta_group" "main_group" {
  name        = local.slug_name
  description = var.group_description

  custom_profile_attributes = jsonencode(local.group_attributes_merged)

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

  custom_profile_attributes = jsonencode((local.group_attributes_merged))

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
  count                 = var.rule_expression != null ? 1 : 0
  name                  = local.slug_name
  status                = var.rule_status
  remove_assigned_users = var.remove_assigned_users
  group_assignments     = local.check_group_assignments
  expression_type       = "urn:okta:expression:1.0"
  expression_value      = var.rule_expression

}

# Assign applications to the applications assignment group
resource "okta_app_group_assignment" "app_assignments" {
  for_each = toset(var.apps)
  app_id   = data.okta_app.app[each.value].id
  group_id = okta_group.apps_assignment_group[0].id
}

# Assign applications to the applications assignment group
resource "okta_app_group_assignment" "app_with_profile_assignments" {
  for_each = var.apps_with_profile
  app_id   = data.okta_app.app_with_profile[each.key].id
  group_id = okta_group.apps_assignment_group[0].id
  profile  = each.value
}

# Provision the group in Github
resource "github_team" "team" {
  count          = var.provision_github_group ? 1 : 0
  name           = local.slug_name
  description    = var.group_description
  privacy        = "closed"
  parent_team_id = var.github_parent_team
}

# Create group mapping between Okta and Github
resource "github_team_sync_group_mapping" "group_mapping" {
  count     = var.provision_github_group ? 1 : 0
  team_slug = github_team.team[count.index].slug

  dynamic "group" {
    for_each = var.provision_github_group ? [for g in data.github_organization_team_sync_groups.okta_groups[count.index].groups : g
    if g.group_name == local.slug_name] : []
    content {
      group_id          = group.value.group_id
      group_name        = group.value.group_name
      group_description = group.value.group_description
    }
  }
}
