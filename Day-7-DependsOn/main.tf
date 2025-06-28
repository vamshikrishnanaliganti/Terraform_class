resource "aws_instance" "dev" {
    ami = "ami-019374baf467d6601"
    instance_type = "t2.micro"
    availability_zone = "eu-west-2a"
    
  tags = {
    Name = "ec2-instance"
  }
}

resource "aws_s3_bucket" "dependent" {
    bucket = "lumlaytvhshfbbc" 
    depends_on = [ aws_instance.dev ]
}
