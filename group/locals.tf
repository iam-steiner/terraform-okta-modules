locals {
  // ugly "slugification"
  slug_name = lower(replace(replace(replace(var.group_name, "/(_|\\.|\\s|\\&)/", "-"), "--", "-"), "--", "-"))

  check_group_assignments = (
    compact(
      [okta_group.main_group.id,
        var.apps_assignment_group ?
        okta_group.apps_assignment_group[0].id : ""
      ]
    )
  )

  # Get the user objects from Okta if a list of group members is provided
  users_object = [
    for user in var.members : data.okta_user.user[user]
  ]

  # Get a list of users id from the user objects
  users_id = [
    for user in local.users_object : user.id
  ]

  # Check if there are any deprovisioned users in the list of group members and return them
  users_deprovisioned = [
    for user in local.users_object : user.email if user.status == "DEPROVISIONED"
  ]

}