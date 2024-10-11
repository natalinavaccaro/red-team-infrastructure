provider "aws" {
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.
  region = "us-east-1"

}


terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "TODO: replace with your bucket name"
    key            = "TODO: replace with your bucket key"
    dynamodb_table = "TODO: replace with your dynamo db table name"
    encrypt        = true
  }
}