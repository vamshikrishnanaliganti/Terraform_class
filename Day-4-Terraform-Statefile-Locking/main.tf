resource "aws_instance" "test" {
  ami               = "ami-019374baf467d6601"
  instance_type     = "t2.micro"
  key_name          = "LondonKP"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "Dev"
  }
}
