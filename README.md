# Red Team Infrastructure

## Getting Started - Install Terraform/AWS CLI

### Install Terraform

(Terraform Download)<https://developer.hashicorp.com/terraform/install>

### Install AWS CLI

(AWS CLI Download)<https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

## Bootstrap AWS Account (skip if already bootstrapped)

1. Enable AWS Organizations

In Identity Center root account, create...
2. Add admin user
3. Add Admin Group and assign user
4. Add Admin Privileges to group
5. Add admin group to management account
You can now log out of root and use admin account
6. Login as admin and get AWS credentials
7. Add credentials to your cli
8. In remote-state module, initialize terraform backend
(run terraform init, terraform plan, terraform apply with LOCAL backend. This will create AWS S3 bucket and dynamoDB table for remote backend)
9. Once resources are created, add remote backend to 'providers.tf' in remote-state. You can now use the remote state in the other modules.

## Adding/Removing Users

There are two types of users that can be added without modifying terraform: attack users and admin users.

To create an admin user, in the organizations module, add user to admin_users in tfvars.

In organizations module, add user to attack_users in tfvars.

Unfortunately, AWS does not send an email on user creation.  [Terraform isn't sending email for Identity Center](https://github.com/hashicorp/terraform-provider-aws/issues/28102)

We need to use ClickOps to go into the Identity Center using an admin account. From there, you will see a banner to send an email to complete user creation.

To remove a user, remove them from the terraform state.

## Adding Accounts

There is one type of account that can be added without modifying terraform: attack account.

In the future, you may want to create an account that has the same environment as the attack account. In organizations module, add your account to attack_accounts in tfvars.

## Billing Explained

## Networking Explained

## Making Changes

If your AWS account has already been bootstrapped, you are now ready to make changes.
To make changes, run
terraform init
terraform plan
terraform apply

### Version Control

Run terraform fmt and terraform validate before committing your code to version control. (TODO - Figure out where to do version control)
