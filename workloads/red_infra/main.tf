# VPC that spans multiple availability zones
# Using CIDR /16 gives us 65k IPs in specified range
# Inspiration From 
# https://stackoverflow.com/questions/35822830/how-to-route-between-two-subnets-in-an-aws-vpc-w-terraform
# https://nickcharlton.net/posts/terraform-aws-vpc.html

############################## VPC DEFINITION ######################################

resource "aws_vpc" "attack" {
  cidr_block           = "10.100.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.vpc_tags, {
      Name = "attack"
  })
}

############################## INTERNET GATEWAY #####################################

# Internet access for public subnet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.attack.id

  tags = merge(
    local.vpc_tags, {
      Name = "attack-ig"
  })
}

# Add catch-all route to send traffic to Internet
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.attack.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    local.vpc_tags, {
      Name = "attack-ig-route"
  })
}

resource "aws_subnet" "attack" {
  vpc_id = aws_vpc.attack.id

  # Add a cidr block for the subnet, allows us to add more subnets later if we choose
  cidr_block = "10.100.1.0/24"

  tags = merge(
    local.vpc_tags, {
      Name = "attack-subnet-default"
  })
}

resource "aws_route_table_association" "attack" {
  route_table_id = aws_route_table.this.id
  subnet_id      = aws_subnet.attack.id
}

