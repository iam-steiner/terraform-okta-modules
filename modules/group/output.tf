output "group_members" {
  value       = data.okta_group.group.users
  description = "List of users email addresses in the group, this is retreived after the group is created and includes members added from a rule"
}
