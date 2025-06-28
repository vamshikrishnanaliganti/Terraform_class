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
}

#terraform apply -target=aws_instance.dev -auto-approve
#terraform destroy -target=aws_instance.dev 
#terraform apply -target=aws_s3_bucket.dependent 
#terraform destroy -target=aws_s3_bucket.dependent -auto-approve
#terraform apply -target=aws_s3_bucket.dependent -target=aws_instance.dev # for calling muliple resource

#3 ways you can apply or destroy any resource or resources 1. directly giving above 2. using sh test.sh 3. mupltiple resources also we can call in one go