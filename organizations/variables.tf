variable "attack_accounts" {
  description = "List of organizational accounts to create. Each entry becomes an organizational account."
  type = map(object({
    account_name                = string
    account_owner_email         = string
    terraform_state_bucket_name = string
  }))
}

variable "attack_users" {
  description = "List of IAM users to create. Each entry becomes a user in the IAM Identity Center."
  type = map(object({
    display_name = string
    user_name    = string
    name = object({
      given_name  = string
      family_name = string
    })
    emails = object({
      value   = string
      primary = bool
    })
  }))

}
