variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# IAM Variables
variable "iam_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
  default     = "lambda_exec_role"
}

variable "lambda_policy_arn" {
  description = "ARN of the Lambda policy"
  type        = string
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "demo-zero-cost-bucket"
}

variable "s3_force_destroy" {
  description = "Allow destruction of non-empty S3 bucket"
  type        = bool
  default     = true
}

variable "s3_enable_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = false
}

# SSM Variables
variable "ssm_parameter_name" {
  description = "Name of the SSM parameter"
  type        = string
  default     = "/demo/config"
}

variable "ssm_parameter_type" {
  description = "Type of the SSM parameter"
  type        = string
  default     = "String"
}

variable "ssm_parameter_value" {
  description = "Value of the SSM parameter"
  type        = string
  default     = "example-value"
}

variable "ssm_parameter_description" {
  description = "Description of the SSM parameter"
  type        = string
  default     = "Demo app config"
}

# Lambda Variables
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "demo-zero-cost-fn"
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function"
  type        = number
  default     = 5
}

# API Gateway Variables
variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "http-api"
}

variable "api_protocol_type" {
  description = "Protocol type for the API"
  type        = string
  default     = "HTTP"
}

variable "integration_type" {
  description = "Integration type"
  type        = string
  default     = "AWS_PROXY"
}

variable "integration_method" {
  description = "Integration HTTP method"
  type        = string
  default     = "POST"
}

variable "payload_format_version" {
  description = "Payload format version"
  type        = string
  default     = "2.0"
}

variable "route_key" {
  description = "Route key for the API"
  type        = string
  default     = "GET /"
}

variable "api_stage_name" {
  description = "Stage name for the API"
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Enable auto-deploy for API Gateway"
  type        = bool
  default     = true
}
