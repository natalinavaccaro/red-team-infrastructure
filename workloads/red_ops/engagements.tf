
# filter to find the target VPC
data "aws_vpc" "target" {
  for_each = { for host in var.engagements : host.instance_name => host }
  filter {
    name    = "tag:VPC"
    values  = [each.value.vpc_key]
  }
  filter {
    name    = "tag:Environment"
    values  = [var.environment]
  }
}


resource "aws_security_group" "c2_comm_sg" {

  # create security group for each engagement to allow comm between
  # redirector and teamserver host

  for_each = { for host in var.engagements : host.instance_name => host }

  name        = "allow_c2_comm_${each.key}"
  description = "Security group to allow C2 comms for ${each.key}"
  vpc_id      = data.aws_vpc.target[each.key].id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    self      = true
  }

  tags = merge(
    local.vpc_tags, {
      Name = "allow_c2_comm_${each.key}"
  })

}

##Create the C2 Hosts for an engagement

module "c2_hosts" {
  source   = "../modules/aws_instance"
  for_each = { for host in var.engagements : host.instance_name => host }

  instance_name               = "${each.key}-cs-${each.value.suffix}"
  ubuntu_version              = each.value.ubuntu_version
  instance_type               = each.value.cs_instance_type
  subnet_name                 = each.value.subnet_name
  associate_public_ip_address = each.value.associate_public_ip_address
  vpc_key                     = each.value.vpc_key
  assigned_security_groups    = ["egress_allow_web_out", "allow_c2_comm_${each.key}"]
  environment                 = var.environment

}


##Create the Redirectors for an engagement
module "web_hosts" {
  source   = "../modules/aws_instance"
  for_each = { for host in var.engagements : host.instance_name => host }

  instance_name               =  "${each.key}-web-${each.value.suffix}"
  ubuntu_version              = each.value.ubuntu_version
  instance_type               = each.value.web_instance_type
  subnet_name                 = each.value.subnet_name
  associate_public_ip_address = each.value.associate_public_ip_address
  vpc_key                     = each.value.vpc_key
  assigned_security_groups    = ["egress_allow_web_out", "ingress_allow_web_in", "allow_c2_comm_${each.key}"]
  environment                 = var.environment

}
