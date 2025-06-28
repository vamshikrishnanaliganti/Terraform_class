# Public EC2 Instance
resource "aws_instance" "public_instance" {
  ami           = "ami-019374baf467d6601" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  #security_groups = [aws_security_group.public_sg.name]
  vpc_security_group_ids = [aws_security_group.public_sg.id] # Use security group ID
  tags = {
    Name = "public-ec2"
  }
}

# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami           = "ami-019374baf467d6601" # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  #security_groups = [aws_security_group.private_sg.name]
  vpc_security_group_ids = [aws_security_group.private_sg.id] # Use security group ID
  tags = {
    Name = "private-ec2"
  }
}
