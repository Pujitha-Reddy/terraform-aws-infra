terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
  ec2  = "http://host.docker.internal:4566"
  iam  = "http://host.docker.internal:4566"
  logs = "http://host.docker.internal:4566"
  s3   = "http://host.docker.internal:4566"
  sts  = "http://host.docker.internal:4566"
}

}

resource "aws_iam_user" "deployer" {
  name = "demo-deployer"
}

resource "aws_iam_user_policy" "deployer_policy" {
  name = "demo-deployer-policy"
  user = aws_iam_user.deployer.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:*", "logs:*", "s3:*", "iam:GetUser"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "demo-artifacts-bucket"
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/demo/app"
  retention_in_days = 7
}

output "iam_user" {
  value = aws_iam_user.deployer.name
}

output "s3_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "log_group" {
  value = aws_cloudwatch_log_group.app_logs.name
}
