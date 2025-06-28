terraform {
  backend "s3" {
    bucket         = "lumla-primary-terraform-state-bucket"
    key            = "vpc/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}


