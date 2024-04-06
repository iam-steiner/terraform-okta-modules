/*

  Team group that is automatically populated by users
  with the identity attribue `division = Security`,
  A list of specific applications for the team is included.

  Additionally, a Github team and Slack channel are created

*/

# Load the terraform module
terraform {
  source = "git::https://github.com/iam-steiner/terraform-okta-modules//modules/group?ref=v1.0.0"
}

# Load the root terragrunt default configuration
include "root" { path = find_in_parent_folders() }

inputs = {

  # Okta group configuration
  group_name             = "Security"
  group_description      = "Security Team"
  rule_expression        = "user.division=='Security'"
  apps_assignment_group  = true

  # Create and sync with Github team
  provision_github_group = true
  github_parent_team     = "main"

  # Create and sync with Slack channel
  slack_handle           = "security"

  # Okta Applications assignment
  apps = [
    "Atlassian Cloud",
    "Bugcrowd",
    "CloudFlare Zero Trust",
    "Crowdstrike Falcon",
    "Github",
    "Okta Access Requests",
  ]

  apps_with_profile = {

    "Lucid" = <<JSON
    {
      "roles": ["Team Admin", "Billing Admin"]
    }
    JSON

    "AWS ZH Security" = <<JSON
    {
      "role": "ecurity",
      "samlRoles": ["security"]
    }
    JSON
  }
}
