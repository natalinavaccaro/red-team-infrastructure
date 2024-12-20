

variable "environment" {
  description = "Environment for target resources: PROD, DEV, STAGE. Defaults to PROD"
  type        = string
  default     = "PROD"
}


variable "hosts" {
  description = "List of hosts to create. Each entry becomes a new host."
  type = list(object({
    instance_name               = string
    instance_type               = string
    ubuntu_version              = string
    subnet_name                 = string
    vpc_key                     = string
    assigned_security_groups    = list(string)
    associate_public_ip_address = bool
  }))
  default = []
}


variable "engagements" {
  description = "List of engagements, with each containing variables to configure the engagement"
  type = list(object({
    instance_name               = string
    cs_instance_type            = string
    web_instance_type           = string
    ubuntu_version              = string
    subnet_name                 = string
    vpc_key                     = string
    associate_public_ip_address = bool
    suffix                      = string
  }))
  default = []
}

