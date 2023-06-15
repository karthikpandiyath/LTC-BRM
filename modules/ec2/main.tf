# main.tf

resource "aws_instance" "ec2_instance" {
  count           = var.instance_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  availability_zone = var.availability_zone

  # Add other instance configuration as needed
}