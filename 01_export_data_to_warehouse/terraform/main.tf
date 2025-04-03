provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "dataengineering-workshop"
}

resource "aws_iam_role" "airflow_role" {
  name = "airflow-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
      {
        Action = "sts:AssumeRole"
        Principal = {
          AWS = "arn:aws:iam::970547364499:user/ljnw0000-s"
        }
        Effect = "Allow"
        Sid    = "AllowSnowflakeToAssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "CU87852_SFCRole=1_BuewggnWsLIVI9+jkU5VqDU9H60="
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "airflow_policy" {
  name        = "airflow-policy"
  description = "Policy for Airflow to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:GetBucketLocation"],
        Effect   = "Allow",
        Resource = [
          "${aws_s3_bucket.data_bucket.arn}",
          "${aws_s3_bucket.data_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = aws_iam_policy.airflow_policy.arn
  role       = aws_iam_role.airflow_role.name
}
