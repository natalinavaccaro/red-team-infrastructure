locals {

  common_tags = {
    Environment = "PROD"
    Terraform   = true
  }

  vpc_tags = merge(
    local.common_tags,
    {
      "VPC" = "attack"
    }
  )

}