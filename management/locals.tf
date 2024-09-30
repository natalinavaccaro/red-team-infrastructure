locals {
  management_admin_users = {
    for name, user in var.users : name => user
    if user.is_management_admin
  }
  workloads_admin_users = {
    for name, user in var.users : name => user
    if !user.is_management_admin
  }
}