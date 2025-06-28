provider "aws" {
  region = "eu-west-2"
}

locals {

  instance_type = "t2.micro"
  environment   = "lumlaproduction"
  app_name      = "lumla-app"
  tags = {
    Environment = local.environment
    Application = local.app_name
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "${local.app_name}-${local.environment}-bucket"

  tags = local.tags
}
resource "aws_instance" "example" {
  ami           = "ami-019374baf467d6601" # Custom AMI for your use
  instance_type = local.instance_type

  tags = {
    Name        = "EC2TF"
    Environment = local.environment
  }
}

