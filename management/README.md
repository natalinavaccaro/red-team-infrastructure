# Management Account README

## Account Setup (Start here if creating a whole new project. MAKE SURE YOU DO THIS FIRST BEFORE WORKLOADS IF YOU WANT THESE IAM PERMISSIONS AND ORGANIZATIONAL STRUCTURE)

### Part One - Initializing AWS Identity Center, AWS Organizations, and creating your first IAM User

1. In the AWS Console, enable AWS Organizations
2. In AWS Organizations, enable AI Opt Out Policies and SCP's
3. Add admin user using the AWS console
4. Add admin Group and assign user
5. Add Admin Privileges to group. This could be someone with "AdministratorAccess" managed permission set, OR it is sufficient to create a user with the permission set defined in iam.tf for management admins.
6. Add this admin group to management account
7. Login as admin and get AWS credentials
8. Add credentials to your cli [Add SSO credentials to CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)

### Part Two - Creating the remote state backend

The remote state backend are beneficial to AWS projects because they offer a solution to working with terraform in a team based environment.

1. In management/remote-state module, initialize the terraform backend. You can do this by creating a file called terraform.auto.tfvars and placing the bucket name, key, and table name in the file. These variables are defined in the variables.tf file.
2. Run terraform init & terraform apply
3. Add your chosen bucket name, key, and table name to management/remote-state/provider.tf. Re-run terraform init & terraform apply to have a terraform backend. In management/provider.tf, add the same the bucket name and table name. You can use a different key.

### Part Three - Initializing the Management Account

The management account has built-in functionalities to perform the following:

1. Add new users on demand with pre-defined permission sets
2. Ability to add new accounts on demand with pre-defined policies and user access 
3. Create a billing alarm

#### Users Functionality

All users in this project will be created with the AWS Identity Center. [AWS Identity Center](https://aws.amazon.com/iam/identity-center/). The AWS Identity Center was used for a few reasons. It allows easier management of users across multi-account environments and removes the necessity for long term access credentials like with IAM users.
To create a user, add a user to the "users" map in a terraform.auto.tfvars management file. **WARNING** If a user is created with the parameter is_management_admin set to true, then it will be given access to the management account and able to set all IAM permissions...

Once changes are applied, unfortunately, AWS does not send an email on user creation.  [Terraform isn't sending email for Identity Center](https://github.com/hashicorp/terraform-provider-aws/issues/28102)

We need to use ClickOps to go into the Identity Center using an admin account. From there, you will see a banner to send an email to complete user creation.

To remove a user, remove them from the tfvars file and apply changes.

### Accounts Functionality

There is one type of account that can be added without modifying the terraform. These accounts will all have the same account structure and policies applied. I recommend creating one account to be used with the workloads terraform code to start, and to consider adding more accounts in the future as necessary. This account will host all the compute services we need to create red team infrastructure

To create an account, add an account to the "attack_accounts" map in a terraform.auto.tfvars management file.

Policies Added to accounts:

1. AI Opt Out Policy
2. TODO - More policies to add in the future (See how to add policies by referencing main.tf)

### Billing Functionality

A billing alert is provided for billing exceeding a certain threshold. In a terraform.auto.tfvars management file, add a billing_email contact, the alert_threshold (default is 100), and sns topic name (default is 'billing-alert')

### Future Functionality

Improvements to the management account could entail:

1. Creating cloudwatch alarms for certain modifications
2. Creating different user personas other than just management & workloads admins
