module "dev" {
  source = "../Day-1-Terraform-Basics"
  amiid = "ami-019374baf467d6601"
  instancetype = "t2.micro"
  keyname = "LondonKP"
  az = "eu-west-2b"
}
