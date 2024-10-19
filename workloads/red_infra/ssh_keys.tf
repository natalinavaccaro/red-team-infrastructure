#Currently this resource requires an existing user-supplied key pair. 
#This key pair's public key will be registered with AWS to allow logging-in to EC2 instances.

resource "aws_key_pair" "ansible" {
  key_name   = "ansible"
  public_key = file(var.public_key)
}