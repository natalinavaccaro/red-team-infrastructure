


module "hosts" {
  source   = "../modules/aws_instance"
  for_each = { for host in var.hosts : host.instance_name => host }

  instance_name               = each.key
  ubuntu_version              = each.value.ubuntu_version
  instance_type               = each.value.instance_type
  subnet_name                 = each.value.subnet_name
  associate_public_ip_address = each.value.associate_public_ip_address
  vpc_key                     = each.value.vpc_key
  assigned_security_groups    = each.value.assigned_security_groups
  environment                 = var.environment

}

