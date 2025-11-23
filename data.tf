# Data Sources - Reference existing AWS resources

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get available AWS regions
data "aws_regions" "available" {}

# Get current AWS region
data "aws_region" "current" {
  name = var.aws_region
}

# Get available AZs in current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Get current AWS account details
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  
  # Build full resource ARNs
  lambda_arn_base = "arn:aws:lambda:${local.region}:${local.account_id}"
  api_arn_base    = "arn:aws:apigateway:${local.region}::${local.account_id}"
}

# Example: Reference existing VPC (if you had one)
# data "aws_vpc" "default" {
#   default = true
# }

# Example: Reference existing security group
# data "aws_security_group" "default" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "default"
# }

# Example: Reference existing IAM policy
# data "aws_iam_policy" "lambda_basic_execution" {
#   name = "AWSLambdaBasicExecutionRole"
# }
