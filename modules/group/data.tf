# Search user my email and return the user object
data "okta_user" "user_email" {
  for_each = toset(var.members)
  search {
    name  = "profile.login"
    value = each.value
  }
}

# Search app by name and return the app object
data "okta_app" "app" {
  for_each = toset(var.apps)
  label    = each.value
}

# Search app by name and return the app object
data "okta_app" "app_with_profile" {
  for_each = var.apps_with_profile
  label    = each.key
}

# Search GitHub Identity Provider (Okta) Groups
data "github_organization_team_sync_groups" "okta_groups" {
  count = var.provision_github_group ? 1 : 0
}

# # Get group information
data "okta_group" "group" {
  name               = var.group_name
  type               = "OKTA_GROUP"
  include_users      = true
  delay_read_seconds = 5

  depends_on = [
    okta_group.main_group
  ]
}
