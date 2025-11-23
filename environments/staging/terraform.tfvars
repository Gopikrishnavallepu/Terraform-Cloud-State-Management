# Staging Environment Configuration
# Used for pre-production testing and validation

aws_region = "us-east-1"

# IAM Configuration
iam_role_name = "lambda_exec_role_staging"
lambda_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

# S3 Configuration
bucket_name = "demo-zero-cost-bucket-staging"
s3_force_destroy = false
s3_enable_versioning = true

# SSM Parameter Configuration
ssm_parameter_name = "/staging/config"
ssm_parameter_type = "String"
ssm_parameter_value = "staging-environment-config"
ssm_parameter_description = "Staging environment configuration"

# Lambda Configuration
lambda_function_name = "demo-zero-cost-fn-staging"
lambda_handler = "index.handler"
lambda_runtime = "nodejs18.x"
lambda_timeout = 10

# API Gateway Configuration
api_gateway_name = "http-api-staging"
api_protocol_type = "HTTP"
integration_type = "AWS_PROXY"
integration_method = "POST"
payload_format_version = "2.0"
route_key = "GET /"
api_stage_name = "staging"
auto_deploy = true

# Tags
environment = "staging"
project = "demo"
