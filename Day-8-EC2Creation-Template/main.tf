provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }

  key_name      = var.key_name
  subnet_id     = var.subnet_id

#   vpc_security_group_ids = var.security_group_ids

  # Optional: Add a user data script
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, EC2 instance!" > /home/ec2-user/hello.txt
              EOF
}
