terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66.0"
    }
  }
  required_version = "~> 1.9.5"
}

# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}

#points to workloads account
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.workloads.id}:role/Admin"
  }

  alias  = "workloads"
  region = "us-east-1"
}

#terraform.backend
terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "red.geart-terraformstate"
    key            = "geart/organizations/terraform.tfstate"
    dynamodb_table = "geart-tfstate"
    encrypt        = true
  }
}