provider "aws" {
  alias  = "primary"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.59.0"
    }
  }
}
