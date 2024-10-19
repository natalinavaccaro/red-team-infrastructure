################### DATA #######################
# filter to find the VPC we want to work in
data "aws_vpc" "this" {
  filter {
    name   = "tag:VPC"
    values = [var.vpc_key]
  }
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}


data "aws_subnet" "this" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_ami" "ubuntu_latest" {
  most_recent = true             # Always get the latest instance of the version specified
  owners      = ["099720109477"] # This is Canonical (maker of Ubuntu)

  filter {
    name   = "name" # Allow user to specify version
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-${var.ubuntu_version}-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"] 
  }
}

################## filter to find target security group ########################

data "aws_security_groups" "this" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Name"
    values = var.assigned_security_groups
  }
}

resource "aws_instance" "red" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = var.instance_type

  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = data.aws_subnet.this.id

  vpc_security_group_ids = data.aws_security_groups.this.ids

  key_name = "ansible"

  tags = merge(
    local.tags,
    {
      "Name" = var.instance_name
  })

  # This prevents terraform from wanting to force the instance to be
  # replaced when the instance doesnt have a public ip because it is shut down.
  #
  # the lifecycle ignore_changes list makes the argument inside only get
  # applied when the resource is created.
  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      ami, # avoid destroy/create when new ami published; only update ami on new instance creation
    ]
  }
}


output "ami_id" {
  value = aws_instance.red.ami
}

output "instance_id" {
  value = aws_instance.red.id
}

output "public_dns" {
  value = aws_instance.red.public_dns
}

output "public_ip" {
  value = aws_instance.red.public_ip
}

output "private_ip" {
  value = aws_instance.red.private_ip
}

output "root_volume_encrypted" {
  value = aws_instance.red.root_block_device[0].encrypted
}

output "security_group_ids" {
  value = aws_instance.red.vpc_security_group_ids
}