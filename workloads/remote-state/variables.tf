#########TERRAFORM STATE##################
variable "terraform_state_bucket_name" {
  description = "The name of the terraform state S3 bucket"
  type = string
}    
variable "terraform_state_bucket_key" {
  description = "The key of the terraform state S3 bucket"
  type = string
}    
variable "terraform_state_table_name" {
  description = "The name of the terraform state dynamodb table"
  type = string
}    