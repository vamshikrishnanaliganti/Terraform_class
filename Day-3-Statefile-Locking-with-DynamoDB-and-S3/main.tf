provider "aws" {

}
resource "aws_s3_bucket" "terraformbucket" {
  bucket = "lumlabucketterraform"
}
resource "aws_dynamodb_table" "dynamodb-terraform-statefile-lock" {
  name           = "terraform-state-file-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}