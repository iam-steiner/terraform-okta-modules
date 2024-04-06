<!-- BEGIN_TF_DOCS -->
# Terraform Module - Okta Group

Create a group in Okta with some extended functionality.

## Features
- Manage the group membership from a [group rule](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-create-group-rules.htm)
- Manage the group membership from a list of users
- Create an additional group `apps-[group-name]`. This additional group is required
  by Okta for application assignments as described [here](https://help.okta.com/oie/en-us/content/topics/users-groups-profiles/app-assignments-group-push.htm)
- Assign applications to the group
- Provision and sync the group with Github
<<<<<<< HEAD
- Provision and sync the group with a Slack handle (depends on the Slack Handle Sync daily job)
=======
- Provision and sync the group with a Slack handle (depends on the [Slack Handle Sync](https://seedcx.atlassian.net/wiki/spaces/SEC/pages/3783360545/Slack+Handle+Sync) daily job)
>>>>>>> main

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0, < 2.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 4.8.0 |

## Example 1

```hcl
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
```

## Example 2

```hcl
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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apps"></a> [apps](#input\_apps) | Value of the applications to assign to the group | `list(any)` | `[]` | no |
| <a name="input_apps_assignment_group"></a> [apps\_assignment\_group](#input\_apps\_assignment\_group) | Create a dedicated application assignment group with the name `apps-[group-name]`, members are the same as the main group | `bool` | `false` | no |
| <a name="input_apps_with_profile"></a> [apps\_with\_profile](#input\_apps\_with\_profile) | Value of the applications to assign to the group with profile attributes | `map(string)` | `{}` | no |
| <a name="input_github_parent_team"></a> [github\_parent\_team](#input\_github\_parent\_team) | Parent team in Github | `string` | `null` | no |
| <a name="input_group_attributes"></a> [group\_attributes](#input\_group\_attributes) | Value of the group attributes to set on the group object in Okta | `map(string)` | `{}` | no |
| <a name="input_group_description"></a> [group\_description](#input\_group\_description) | Value of the group description | `string` | n/a | yes |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Value of the group name. It is converted to lowercase with a dash `-` as separator per convention | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | Value of the group members email addresses | `list(string)` | `[]` | no |
| <a name="input_provision_github_group"></a> [provision\_github\_group](#input\_provision\_github\_group) | Provision the group in Github | `bool` | `false` | no |
| <a name="input_remove_assigned_users"></a> [remove\_assigned\_users](#input\_remove\_assigned\_users) | Remove users from the group if the rule is deleted | `bool` | `false` | no |
| <a name="input_rule_expression"></a> [rule\_expression](#input\_rule\_expression) | A rule that determines the group membership | `string` | `null` | no |
| <a name="input_rule_status"></a> [rule\_status](#input\_rule\_status) | Status of the group rule, either ACTIVE or INACTIVE | `string` | `"ACTIVE"` | no |
| <a name="input_slack_handle"></a> [slack\_handle](#input\_slack\_handle) | Value of the slack handle to set on the group object in Okta | `string` | `null` | no |
| <a name="input_track_all_users"></a> [track\_all\_users](#input\_track\_all\_users) | Ensure only the users on the list are members of the group, will remove any manually added users | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_members"></a> [group\_members](#output\_group\_members) | List of users email addresses in the group, this is retreived after the group is created and includes members added from a rule |
<!-- END_TF_DOCS -->
