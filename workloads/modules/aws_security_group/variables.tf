variable "vpc_id" {
  description = "ID of the VPC where we'll be creating the instances"
  default     = null
}


variable "tags" {
  description = "A list of tags: VPC=<name>,Environment=<name>,Terraform=true"
  type        = map(any)
  default     = {}
}
