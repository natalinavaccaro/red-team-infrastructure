# Workloads Account README

## Pre-requisites: If using the management account, make sure you set that up first. If you are just here for the infrastructure or you completed management account setup, carry on

### Part One - Creating the remote state backend

The remote state backends are beneficial to AWS projects because they offer a solution to working with terraform in a team based environment.

1. In workloads/remote-state module, initialize the terraform backend. You can do this by creating a file called terraform.tfvars and placing your desired bucket name, key, and table name in the file. These variables are defined in the variables.tf file.
2. Run terraform init & terraform apply
3. Add your chosen bucket name, key, and table name to workloads/remote-state/provider.tf. Re-run terraform init & terraform apply to have a terraform backend. Now in both red-ops/provider.tf and red_infra/provider.tf, add the same the bucket name and table name. You can use a different key.

### Part Two - Setting up red team Network & Compute Instances

A red team often requires different ec2 hosts to be stood up and destroyed on demand within an engagement. To solve this challenge, I propose a two folder structure within the workloads environment. The red_infra folder contains resources that will rarely change throughout engagements (ex. networking resources). The red team operations folder contains resources that are more dynamic (ex. ec2 creation) and is designed to be easy to create/destroy as needed.

1. Set up red team infrastructure using the README.md in red_infra [Red Team Infrastructure README](red_infra/README.md)
2. Set up red team operations using the README.md in red_ops [Red Team Operations README](red_ops/README.md)