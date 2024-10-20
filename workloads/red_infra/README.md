# Red Team Infrastructure - Explained

## Getting Started

You will need to create an SSH key pair to use for ansible configurations. Once created, you can add the public key's file name and path as the variable public_key in terraform.tfvars. 

Don't forget to initialize your terraform backend!

## Resources Created

1. Networking Resources: [A VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) with an internet gateway, route table, subnet, and security groups
2. SSH public key is added to aws