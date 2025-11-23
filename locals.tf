# Locals - Centralized computed values and grouped variables

locals {
  # Project Metadata
  project_name = "demo-zero-cost"
  environment  = var.environment
  
  # Common Tags
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    CreatedDate = timestamp()
  }

  # Naming Conventions
  name_prefix = "${local.project_name}-${local.environment}"

  # IAM Role Names
  iam_role_name = "${local.name_prefix}-lambda-role"

  # S3 Configuration
  s3_bucket_name = "${local.name_prefix}-bucket"
  s3_config = {
    versioning_enabled = var.s3_enable_versioning
    force_destroy      = var.s3_force_destroy
    encryption         = false
  }

  # SSM Parameter Configuration
  ssm_parameters = {
    config_param = {
      name        = "/${local.environment}/app/config"
      type        = var.ssm_parameter_type
      value       = var.ssm_parameter_value
      description = "Application configuration for ${local.environment}"
    }
  }

  # Lambda Configuration
  lambda_config = {
    function_name = "${local.name_prefix}-function"
    handler       = var.lambda_handler
    runtime       = var.lambda_runtime
    timeout       = var.lambda_timeout
    memory_size   = local.environment == "prod" ? 512 : 256
    environment_vars = {
      APP_ENV     = local.environment
      APP_NAME    = local.project_name
    }
  }

  # API Gateway Configuration
  api_gateway_config = {
    name          = "${local.name_prefix}-api"
    protocol_type = var.api_protocol_type
    stage_name    = var.api_stage_name
    auto_deploy   = var.auto_deploy
  }
}
