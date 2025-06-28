resource "aws_instance" "dev" {
    ami = "ami-01816d07b1128cd2d"
    instance_type = "t2.micro"
    key_name = "dummykeypair"
    tags = {
      Name = "import-ec2-dev"
    }
}

