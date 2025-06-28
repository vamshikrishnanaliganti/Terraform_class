module "prod" {
  source = "github.com/lumlathomas/TerraformClass/Day-8-EC2Creation-Template"
  ami_id = "ami-019374baf467d6601"
  instance_type = "t2.micro"
  key_name = "LondonKP"
}
