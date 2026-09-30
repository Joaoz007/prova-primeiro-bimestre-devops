resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = "LabInstanceProfile"
  associate_public_ip_address = true

  tags = {
    Name = "technova-ec2"
  }
}
