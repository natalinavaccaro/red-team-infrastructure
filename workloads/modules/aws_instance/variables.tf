variable "vpc_key" {
  description = "Name of the VPC where we'll be creating the instances"
  default     = "attack-subnet-default"
}

variable "subnet_name" {
  description = "Name of subnet in the VPC to assign to the new instance"
  type        = string
  default     = null
}

variable "assigned_security_groups" {
  description = "List of security group IDs to add to host in addition to default set"
  type        = list(string)
  default     = []
}

variable "ubuntu_version" {
  description = "Version of Ubuntu used to locate AMI when launching new instances. Form of 20.04"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The AWS instance type to create. Defaults to t2.micro"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name to apply to the newly created instance"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment for target resources: PROD, DEV, STAGE. Defaults to PROD"
  type        = string
  default     = "PROD"
}

variable "associate_public_ip_address" {
  description = "Associate public IP address? (true or false). Defaults to True"
  type        = bool
  default     = true
}


