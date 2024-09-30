

resource "aws_organizations_account" "attack_accounts" {
  for_each = var.attack_accounts
  name     = each.value.account_name
  email    = each.value.account_owner_email
}

resource "aws_organizations_policy" "aiservices_opt_out_policy" {
  content = jsonencode({
    services = {
      "@@operators_allowed_for_child_policies" = ["@@none"]
      default = {
        "@@operators_allowed_for_child_policies" = ["@@none"]
        opt_out_policy = {
          "@@assign"                               = "optOut"
          "@@operators_allowed_for_child_policies" = ["@@none"]
        }
      }
    }
  })
  description  = "Opt out of all AI services for all accounts in the organization"
  name         = "AI Service Opt Out"
  skip_destroy = null
  tags         = {}
  tags_all     = {}
  type         = "AISERVICES_OPT_OUT_POLICY"
}


resource "aws_organizations_policy_attachment" "account" {
  for_each  = var.attack_accounts
  policy_id = aws_organizations_policy.aiservices_opt_out_policy.id
  target_id = aws_organizations_account.attack_accounts[each.value.account_name].id
}

data "aws_organizations_organization" "this" {}

#attach to the management account
resource "aws_organizations_policy_attachment" "management" {
  policy_id = aws_organizations_policy.aiservices_opt_out_policy.id
  target_id = data.aws_organizations_organization.this.master_account_id
}

##TODO: SCP GOES HERE