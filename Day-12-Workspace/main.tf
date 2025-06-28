provider "aws" {
  region = "eu-west-2"
}

# S3 Bucket - workspace-specific
resource "aws_s3_bucket" "example" {
  bucket = "lumlaterraformbucket-${terraform.workspace}" # Bucket name includes workspace name

  tags = {
    Name        = "S3-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# EC2 Instance - workspace-specific
resource "aws_instance" "example" {
  ami           = "ami-019374baf467d6601" # Custom AMI for your use
  instance_type = "t2.micro"

  tags = {
    Name        = "EC2-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
