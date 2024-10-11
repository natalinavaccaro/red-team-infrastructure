
locals {

  common_tags = {
    Environment = "PROD"
  }

  vpc_tags = merge(
    local.common_tags,
    {
      "VPC" = "attack"
    }
  )

}