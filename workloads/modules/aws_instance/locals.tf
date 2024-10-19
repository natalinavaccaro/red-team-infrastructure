locals {

  tags = {
    VPC         = var.vpc_key
    Environment = var.environment
    Terraform   = true
  }
}
