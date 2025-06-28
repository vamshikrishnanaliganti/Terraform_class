module "name" {
  source                 = "terraform-aws-modules/lambda/aws" #thats where it is calling from
  function_name          = "my-function"
  handler                = "lambda_function.lambda_handler"
  runtime                = "python3.12"
  create_package         = false
  #local_existing_package = "lambda_function.zip"
  local_existing_package = "../Day-7-Lambda-without-S3/lambda_function.zip"
}
#https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/7.20.0?utm_content=documentLink&utm_medium=Visual+Studio+Code&utm_source=terraform-ls
