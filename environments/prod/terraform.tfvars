# Production Environment Configuration
# Used for production workloads - CRITICAL

aws_region = "us-east-1"

# IAM Configuration
iam_role_name = "lambda_exec_role_prod"
lambda_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

# S3 Configuration
bucket_name = "demo-zero-cost-bucket-prod"
s3_force_destroy = false
s3_enable_versioning = true

# SSM Parameter Configuration
ssm_parameter_name = "/prod/config"
ssm_parameter_type = "SecureString"
ssm_parameter_value = "prod-environment-config"
ssm_parameter_description = "Production environment configuration"

# Lambda Configuration
lambda_function_name = "demo-zero-cost-fn-prod"
lambda_handler = "index.handler"
lambda_runtime = "nodejs18.x"
lambda_timeout = 30

# API Gateway Configuration
api_gateway_name = "http-api-prod"
api_protocol_type = "HTTP"
integration_type = "AWS_PROXY"
integration_method = "POST"
payload_format_version = "2.0"
route_key = "GET /"
api_stage_name = "prod"
auto_deploy = false

# Tags
environment = "prod"
project = "demo"
