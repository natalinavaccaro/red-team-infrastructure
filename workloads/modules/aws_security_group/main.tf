########### DATA: VPC #############

#Grab the vpc we created in main.tf
data "aws_vpc" "target" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "allow_web_in" {
  name        = "allow_web_in"
  description = "Allow 80/443 in for all"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags, {
      Name = "ingress_allow_web_in"
  })
}