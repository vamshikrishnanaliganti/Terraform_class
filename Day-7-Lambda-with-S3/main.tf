# S3 Bucket to Store Lambda Code
# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket        = "lumla-lambda-bucket-for-terraform-practice" # give unique bucket name
#   acl           = "private"
#   force_destroy = true

#   tags = {
#     Name = "LambdaBucket"
#   }
# }
# # S3 Bucket to Store Lambda Code
# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = "lumla-lambda-bucket"
# }

# resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   acl    = "private"
# }


# # Upload Lambda Code to S3
# resource "aws_s3_object" "lambda_code" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   key    = "lambda_function.zip"
#   source = "lambda_function.zip"          # Path to your zip file containing the Lambda code
#   etag   = filemd5("lambda_function.zip") # this is optional, used for hugecode, making into small chuncks
# }

# # IAM Role for Lambda
# resource "aws_iam_role" "lambda_exec_role" {
#   name = "lambda-exec-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach Policy to IAM Role
# resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
#   role       = aws_iam_role.lambda_exec_role.name
#   policy_arn = "arn:aws:iam::871677391987:role/service-role/my_lambda_function-role-kf6ysz75" # change this with your ARN
# }

# # Lambda Function
# resource "aws_lambda_function" "my_lambda" {
#   function_name = "my_lambda_function"
#   runtime       = "python3.9"
#   role          = aws_iam_role.lambda_exec_role.arn
#   handler       = "lambda_function.lambda_handler" # Replace with your function handler
#   s3_bucket     = aws_s3_bucket.lambda_bucket.id   # calling code from s3 bucket 
#   s3_key        = aws_s3_object.lambda_code.key    # inside this folder
#   timeout       = 100
#   memory_size   = 128

#   environment {
#     variables = {
#       ENV_VAR_KEY = "ENV_VAR_VALUE" # Example environment variable
#     }
#   }

#   tags = {
#     Name = "MyLambdaFunction"
#   }
# }

# # above code throws an error 

# # S3 Bucket to Store Lambda Code
# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = "lumla-lambda-bucket"

#   # Bucket policy to control access
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = "*",
#         Action    = "s3:GetObject",
#         Resource  = "arn:aws:s3:::lumla-lambda-bucket/*"
#       }
#     ]
#   })
# }

# S3 Bucket to Store Lambda Code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lumla-lambda-bucket"
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "lambda_bucket_policy" {
  bucket = aws_s3_bucket.lambda_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",  # Replace "*" with specific IAM principal(s) for restricted access
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::lumla-lambda-bucket/*"
      }
    ]
  })
}


# Upload Lambda Code to S3
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Basic Execution Policy to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_code.key
  timeout       = 100
  memory_size   = 128

  environment {
    variables = {
      ENV_VAR_KEY = "ENV_VAR_VALUE"
    }
  }

  tags = {
    Name = "MyLambdaFunction"
  }
}
