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

#terraform.backend
terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "red.geart-terraformstate"
    key            = "geart/remote-state/terraform.tfstate"
    dynamodb_table = "geart-tfstate"
    encrypt        = true
  }
}