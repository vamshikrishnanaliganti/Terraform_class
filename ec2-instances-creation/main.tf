# main.tf

provider "aws" {
  region = "eu-west-2"  # Change to your preferred region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"  # Change to your preferred AZ
  map_public_ip_on_launch = true  # Enable auto-assign public IPv4 for instances in this subnet

  tags = {
    Name = "my-subnet"
  }
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Route all traffic to the Internet Gateway
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_assoc" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create a security group to allow ALL traffic
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow ALL inbound and outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id  # Associate the security group with the VPC

  # Allow ALL inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }

  # Allow ALL outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }

  tags = {
    Name = "allow_all"
  }
}

# Create the Ansible EC2 instance
resource "aws_instance" "ansible" {
  ami           = "ami-0e56583ebfdfc098f"  # Amazon Linux 2 AMI (eu-west-2)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]  # Use security group ID
  key_name      = "LondonKP"  # Use your key pair name

  tags = {
    Name = "ansible"
  }
}

# Create the Target-1 EC2 instance
resource "aws_instance" "target_1" {
  ami           = "ami-0e56583ebfdfc098f"  # Amazon Linux 2 AMI (eu-west-2)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]  # Use security group ID
  key_name      = "LondonKP"  # Use your key pair name

  tags = {
    Name = "target-1"
  }
}

# Output the public IP addresses of the instances
output "ansible_public_ip" {
  value = aws_instance.ansible.public_ip
}

output "target_1_public_ip" {
  value = aws_instance.target_1.public_ip
}