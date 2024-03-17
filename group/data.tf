# Search user my email and returns the user object
data "okta_user" "user" {
  for_each = toset(var.members)
  search {
    name  = "profile.login"
    value = each.value
  }

}