variable "attack_accounts" {
  description = "List of organizational accounts to create. Each entry becomes an organizational account."
  type = map(object({
    account_name                = string
    account_owner_email         = string
    terraform_state_bucket_name = string
  }))
}

variable "aws_profile" {
  description = "Profile to use for aws"
  type        = string

}

variable "users" {
  description = "List of IAM users to create. Each entry becomes a user in the IAM Identity Center."
  type = map(object({
    display_name = string
    user_name    = string
    name = object({
      given_name  = string
      family_name = string
    })
    is_management_admin = bool
    emails = object({
      value   = string
      primary = bool
    })
  }))

}

###########BILLING#########################
variable "sns_topic_name" {
  description = "The name of the SNS topic for billing alerts"
  type        = string
  default     = "billing-alert"
}

variable "alert_thresholds" {
  description = "List of billing thresholds to create alarms for"
  type        = list(number)
  default     = [100] # Default thresholds in USD
}

variable "billing_email" {
  description = "The email address to receive billing alerts"
  type        = string
}

#########TERRAFORM STATE##################
variable "terraform_state_bucket_name" {
  description = "The name of the terraform state S3 bucket"
  type        = string
}

