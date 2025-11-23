# Development Environment Configuration
# Used for development and testing

aws_region = "us-east-1"

# IAM Configuration
iam_role_name = "lambda_exec_role_dev"
lambda_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

# S3 Configuration
bucket_name = "demo-zero-cost-bucket-dev"
s3_force_destroy = true
s3_enable_versioning = false

# SSM Parameter Configuration
ssm_parameter_name = "/dev/config"
ssm_parameter_type = "String"
ssm_parameter_value = "dev-environment-config"
ssm_parameter_description = "Development environment configuration"

# Lambda Configuration
lambda_function_name = "demo-zero-cost-fn-dev"
lambda_handler = "index.handler"
lambda_runtime = "nodejs18.x"
lambda_timeout = 5

# API Gateway Configuration
api_gateway_name = "http-api-dev"
api_protocol_type = "HTTP"
integration_type = "AWS_PROXY"
integration_method = "POST"
payload_format_version = "2.0"
route_key = "GET /"
api_stage_name = "$default"
auto_deploy = true

# Tags
environment = "dev"
project = "demo"
