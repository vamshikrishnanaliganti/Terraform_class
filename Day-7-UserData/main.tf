resource "aws_instance" "dev" {
    ami = "ami-019374baf467d6601"
    instance_type = "t2.micro"
    availability_zone = "eu-west-2b"
    user_data = file("script.sh")
  tags = {
    Name = "ec2-instance"
  }
}