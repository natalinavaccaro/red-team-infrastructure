
################ S3 GLOBAL (ACCOUNT WIDE) CONFIG  ##################

#
# Block Public Access at the account level. This setting should protect
# any new buckets that get created without the proper configuration.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block
#
resource "aws_s3_account_public_access_block" "geart" {
  # PUT Bucket acl and PUT Object acl calls will fail if the specified ACL allows public access
  # PUT Object calls will fail if the request includes an object ACL 
  block_public_acls = true
  # Reject calls to PUT Bucket policy if the specified bucket policy allows public access
  block_public_policy = true
  # Ignore public ACLs on this bucket and any objects that it contains
  ignore_public_acls = true
  # Only the bucket owner and AWS Services can access this buckets if it has a public policy
  restrict_public_buckets = true
}

#terraform backend s3 bucket

resource "aws_s3_bucket" "geart-terraformstate" {
    bucket = "red.geart-terraformstate"
    #TODO- what is this?
    force_destroy = true

}

# state versioning
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.geart-terraformstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# encryption configuration 
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.geart-terraformstate.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# dynamodb to keep lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "geart-tfstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}