
# Data block to fetch the SSO admin instance. Once you enabled SSO admin from console, you need data block to fetch this in your code.
data "aws_ssoadmin_instances" "this" {}

############################## Users,Group,Group's Membership #########################################
# Create SSO user
resource "aws_identitystore_user" "workloads_admin_users" {
  for_each = local.workloads_admin_users

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = each.value.display_name
  user_name         = each.value.user_name

  name {
    given_name  = each.value.name.given_name
    family_name = each.value.name.family_name
  }

  emails {
    value   = each.value.emails.value
    primary = each.value.emails.primary
  }
}
resource "aws_identitystore_user" "management_admin_users" {
  for_each = local.management_admin_users

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = each.value.display_name
  user_name         = each.value.user_name

  name {
    given_name  = each.value.name.given_name
    family_name = each.value.name.family_name
  }

  emails {
    value   = each.value.emails.value
    primary = each.value.emails.primary
  }
}

# Create Group
resource "aws_identitystore_group" "workloads_admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = "WorkloadsAdmin"
  description       = "Gives Access to EC2 resources in the attack VPCs"
}

# Create Admin Group
resource "aws_identitystore_group" "management_admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = "ManagementAdmin"
  description       = "Gives Access to Admin resources in management account"
}


####################### Group Membership ############################################
# Create Group Membership for the users


resource "aws_identitystore_group_membership" "workloads_admin" {
  for_each = aws_identitystore_user.workloads_admin_users

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.workloads_admin.group_id
  member_id         = each.value.user_id
}

#We want our management admin users to still have access to workloads admin role
resource "aws_identitystore_group_membership" "workloads_admin_for_management" {
  for_each = aws_identitystore_user.management_admin_users

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.workloads_admin.group_id
  member_id         = each.value.user_id
}

resource "aws_identitystore_group_membership" "management_admin" {
  for_each = aws_identitystore_user.management_admin_users

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.management_admin.group_id
  member_id         = each.value.user_id
}

##################### Permission Sets #######################################

# Create Custom Permission Set for EC2 
resource "aws_ssoadmin_permission_set" "workloads_admin" {
  name         = "WorkloadsAdmin"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_iam_policy_document" "workloads_admin" {

  statement {
    sid    = "VPCActions"
    effect = "Allow"

    actions = [
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
    ]

    resources = ["arn:aws:ec2:*:*:vpc/*"] 
  }


}

# Create Custom Permission Set for management admin 
resource "aws_ssoadmin_permission_set" "management_admin" {
  name         = "ManagementAdmin"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_iam_policy" "billing" {
  arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

data "aws_iam_policy_document" "management_admin" {

  statement {
    sid    = "ManagementAdminActions"
    effect = "Allow"

    actions = [
      "s3:*",
      "dynamodb:*",
      "iam:*",
      "organizations:*",
      "identitystore:*",
      "sso:*",
      "sso-directory:*",
      "identitystore:*",
      "identitystore-auth:*",
      "sns:*",
      "cloudwatch:*",


    ]

    resources = ["*"]
  }

}

# Custom permission set Inline policy 
resource "aws_ssoadmin_permission_set_inline_policy" "workloads_admin" {
  inline_policy      = data.aws_iam_policy_document.workloads_admin.json
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.workloads_admin.arn
}

##Management account policy attachments
resource "aws_ssoadmin_permission_set_inline_policy" "management_admin" {
  inline_policy      = data.aws_iam_policy_document.management_admin.json
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.management_admin.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  managed_policy_arn = data.aws_iam_policy.billing.arn
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.management_admin.arn
}
########################## AWS Accdount/OU Assignment ###################################


# Create Account Assignment to the group with Custom permission sets
resource "aws_ssoadmin_account_assignment" "workloads_admin" {
  for_each = var.attack_accounts

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.workloads_admin.arn # Custom Permission set

  principal_id   = aws_identitystore_group.workloads_admin.group_id # Group
  principal_type = "GROUP"
  target_id      = aws_organizations_account.attack_accounts[each.value.account_name].id
  target_type    = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "management_admin" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.management_admin.arn # Custom Permission set

  principal_id   = aws_identitystore_group.management_admin.group_id # Group
  principal_type = "GROUP"
  target_id      = data.aws_organizations_organization.this.master_account_id
  target_type    = "AWS_ACCOUNT"
}