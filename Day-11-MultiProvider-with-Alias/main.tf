# Provider-1 for eu-west-2 (Default Provider)
provider "aws" {
  region = "eu-west-2"
}

#Another provider alias 
provider "aws" {
  region = "ap-south-1"
  alias = "provider2"
}

resource "aws_s3_bucket" "test" {
  bucket = "lumla1234522bucket1"

}
resource "aws_s3_bucket" "test2" {
  bucket = "lumla4564635bucket2"
  provider = aws.provider2  #provider.value of alias
  
}