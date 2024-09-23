
# Data block to fetch the SSO admin instance. Once you enabled SSO admin from console, you need data block to fetch this in your code.
data "aws_ssoadmin_instances" "this" {}

############################## Users,Group,Group's Membership #########################################
# Create SSO user
resource "aws_identitystore_user" "attackers" {
  for_each = var.attack_users

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
resource "aws_identitystore_group" "attack" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = "EC2AttackAccess"
  description       = "Gives Access to EC2 resources in the attack VPCs"
}

# Create Admin Group
resource "aws_identitystore_group" "admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = "AdminAccess"
  description       = "Gives Access to Admin resources in management and workloads account"
}


####################### Group Membership ############################################
# Create Group Membership for the users
resource "aws_identitystore_group_membership" "attack" {
  for_each = aws_identitystore_user.attackers

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.attack.group_id
  member_id         = each.value.user_id
}

resource "aws_identitystore_group_membership" "admin" {
  for_each = aws_identitystore_user.attackers

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.admin.group_id
  member_id         = each.value.user_id
}

##################### Permission Sets #######################################

# Create Custom Permission Set for EC2 
resource "aws_ssoadmin_permission_set" "ec2_attack" {
  name         = "ec2-attack"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

data "aws_iam_policy_document" "ec2_attack" {

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

# Custom permission set Inline policy 
resource "aws_ssoadmin_permission_set_inline_policy" "ec2_attack" {
  inline_policy      = data.aws_iam_policy_document.ec2_attack.json
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.ec2_attack.arn
}

########################## AWS Accdount/OU Assignment ###################################


# Create Account Assignment to the group with Custom permission sets  --> Production Account 
resource "aws_ssoadmin_account_assignment" "ec2_attack_access" {
  for_each = var.attack_accounts

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.ec2_attack.arn # Custom Permission set

  principal_id   = aws_identitystore_group.this.group_id # Group
  principal_type = "GROUP"
  target_id      = aws_organizations_account.attack_accounts[each.value.account_name].id
  target_type    = "AWS_ACCOUNT"
}