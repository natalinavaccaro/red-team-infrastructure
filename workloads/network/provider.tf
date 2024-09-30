provider "aws" {
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.
  region = "us-east-1"

}


terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = var.terraform_state_bucket_name
    key            = var.terraform_state_bucket_key
    dynamodb_table = var.terraform_state_table_name
    encrypt        = true
  }
}