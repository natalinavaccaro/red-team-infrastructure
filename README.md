# Red Team Infrastructure

This infrastructure was created to help red teams kickstart their AWS infrastructure using terraform

## Getting Started - Install Terraform/AWS CLI

### Install Terraform

(Terraform Download)<https://developer.hashicorp.com/terraform/install>

### Install AWS CLI

(AWS CLI Download)<https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

### Project Structure

This project was created with the intent to have a day 0 solution to building red team infrastructure. All resources are created in AWS region us-east-1. All users are created using AWS Identity Center. This project uses AWS Organizations. The recommended account structure is to have a management account and workloads account. Currently, this project was made with only these accounts in mind, but is open to adding more AWS accounts in the future. Only users with management account access can run the terraform in the management folder. All other users can run the workloads terraform. This allows the definition of user permissions and IAM, billing, and organizational policies to be separate from any other infrastructure created. If IAM, billing notifications, and organizations etc. are not needed, you could use just the workloads account terraform to kickstart your red team infrastructure.

## Bootstrap AWS Account (skip if already bootstrapped)

1. Set up management account using the README.md in management [Management README](management/README.md)
2. Set up workloads account using the README.md in workloads [Workloads README](workloads/README.md)

## Making Changes

If your AWS account has already been bootstrapped, you are now ready to make changes.
To make changes, run
terraform init (if needed)
terraform plan
terraform apply

### Version Control

Run terraform fmt and terraform validate before committing your code to version control.
