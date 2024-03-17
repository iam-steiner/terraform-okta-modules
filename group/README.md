# Okta Group

Use this module to create an Okta group

Optional:

- Assign a group rule
- Generate an applications assignment group with prefix `apps-`
- Manage specific members on both the group and the assignment group

## Usage

### Terraform

```terraform
module "group" {
  source            = "https://github.com/iam-steiner/terraform-okta-modules/group?ref=v1.0.0"

  group_name        = "Fancy Group"
  group_description = "Group of nice people"
}
```

```terraform
module "group" {
  source                = "https://github.com/iam-steiner/terraform-okta-modules/group?ref=v1.0.0"

  group_name            = "team-security"
  group_description     = "Security Team Group"
  rule_expression       = "user.division==\"Security\""
  apps_assignment_group = true
}
```

```terraform
module "group" {
  source            = "https://github.com/iam-steiner/terraform-okta-modules/group?ref=v1.0.0"

  group_name        = "squad-storm-troopers"
  group_description = "Group of terrible shooters"

  members = [
    "user1@example.com",
    "user2@example.com"
  ]
}
```

### Terragrunt

```terragrunt
# Load the terraform module
terraform {
  source = "https://github.com/iam-steiner/terraform-okta-modules/group?ref=v1.0.0"
}

# Load the root terragrunt default configuration
include "root" { path = find_in_parent_folders() }

inputs = {
   group_name            = "team-security"
   group_description     = "Security Team Group"
   
   rule_expression       = "user.division==\"Security\""
   apps_assignment_group = true
}
```

### Inputs

| Parameter | Type | Description |
|---|---|---|
| group_name | string| Per convention, the name is converted to lowercase and use dash `-` as separator |
| group_description | string | Group description |
| rule_expression | string | [Okta Group Rule]( https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-create-group-rules.htm ) |
| rule_status | bool | Enable or disable the group rule, Values: ACTIVE (default) \| INACTIVE |
| members | list(string) | List of users' email address.  for example: ['user1@example.com', "user2@example.com", 'user3@example.com'] |
| track_all_users | bool | Set governance of the group with this module, every user manually added through the Okta GUI will be removed if it is not included in the list of users from this module. Default is `false` |
| apps_assignment_group | bool | Create a dedicated application assignment group with prefix `apps-` per Okta requirements described [here](https://help.okta.com/oie/en-us/content/topics/users-groups-profiles/app-assignments-group-push.htm). Default is `false` |

## TODO

- Include applications assignment
