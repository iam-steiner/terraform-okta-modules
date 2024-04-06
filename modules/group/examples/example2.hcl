/*

  Utility group used in a target app, for example,
  to create a Slack handle `@storm-troopers`, the list of members is fixed
  and doesn't need to assign specific apps or roles.

*/

# Load the terraform module
terraform {
  source = "git::https://github.com/iam-steiner/terraform-okta-modules//modules/group?ref=v1.0.0"
}

# Load the root terragrunt default configuration
include "root" { path = find_in_parent_folders() }

inputs = {
  group_name        = "storm-troopers"
  group_description = "Group of terrible shooters"
  slack_handle      = "storm-troopers"

  members = [
    "john.doe@example.com",
    "jane.doe@example.com"
  ]

}
