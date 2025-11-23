provider "aws" {
  region = var.aws_region
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  iam_role_name = var.iam_role_name
  policy_arn    = var.lambda_policy_arn
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  bucket_name       = var.bucket_name
  force_destroy     = var.s3_force_destroy
  enable_versioning = var.s3_enable_versioning
}

# SSM Module
module "ssm" {
  source = "./modules/ssm"

  parameter_name        = var.ssm_parameter_name
  parameter_type        = var.ssm_parameter_type
  parameter_value       = var.ssm_parameter_value
  parameter_description = var.ssm_parameter_description
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"

  function_name        = var.lambda_function_name
  lambda_exec_role_arn = module.iam.lambda_exec_role_arn
  handler              = var.lambda_handler
  runtime              = var.lambda_runtime
  timeout              = var.lambda_timeout
  bucket_name          = module.s3.bucket_name
  config_param_name    = module.ssm.parameter_name
}

# API Gateway Module
module "api_gateway" {
  source = "./modules/api_gateway"

  api_name               = var.api_gateway_name
  protocol_type          = var.api_protocol_type
  integration_type       = var.integration_type
  lambda_invoke_arn      = module.lambda.invoke_arn
  integration_method     = var.integration_method
  payload_format_version = var.payload_format_version
  route_key              = var.route_key
  stage_name             = var.api_stage_name
  auto_deploy            = var.auto_deploy
  lambda_function_name   = module.lambda.function_name
}
