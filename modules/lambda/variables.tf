variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "demo-zero-cost-fn"
}

variable "lambda_exec_role_arn" {
  description = "ARN of the Lambda execution role"
  type        = string
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "nodejs18.x"
}

variable "timeout" {
  description = "Timeout for the Lambda function"
  type        = number
  default     = 5
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "config_param_name" {
  description = "Name of the SSM parameter"
  type        = string
}
