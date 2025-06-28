# Run first TerraformClass/Day-3-Statefile-Locking-with-DynamoDB-and-S3 to create reources 
# This backend configuration instructs Terraform to store its state in an S3 bucket.
terraform {
  backend "s3" {
    bucket         = "lumlabucketterraform" # Name of the S3 bucket where the state will be stored.
    region         = "eu-west-2"
    key            = "folder1/terraform.tfstate"   # Path within the bucket where the state will be read/written.
    dynamodb_table = "terraform-state-file-dynamo" # DynamoDB table used for state locking, note: first run day-3-bckend resources then day-4-backend config
    encrypt        = true                          # Ensures the state is encrypted at rest in S3.
  }
}