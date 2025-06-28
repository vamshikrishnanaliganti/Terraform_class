resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = "lumla-primary-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "primary-versioning" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = "lumla-secondary-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "secondary-versioning" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name        = "s3-replication-policy"
  description = "Policy for S3 replication"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ]
        Resource = "arn:aws:s3:::lumla-primary-terraform-state-bucket/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "arn:aws:s3:::lumla-secondary-terraform-state-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

resource "aws_s3_bucket_replication_configuration" "primary_to_secondary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id
  role     = aws_iam_role.replication_role.arn

  rule {
    id     = "ReplicationRule"
    status = "Enabled"
    
    destination {
      bucket        = aws_s3_bucket.secondary.arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }

    filter {
      prefix = ""  # Use a prefix if needed, or leave it as is to replicate all objects.
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.primary-versioning,
    aws_s3_bucket_versioning.secondary-versioning
  ]
}
