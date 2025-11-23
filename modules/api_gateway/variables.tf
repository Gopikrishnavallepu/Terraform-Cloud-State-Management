variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "http-api"
}

variable "protocol_type" {
  description = "Protocol type for the API"
  type        = string
  default     = "HTTP"
}

variable "integration_type" {
  description = "Integration type"
  type        = string
  default     = "AWS_PROXY"
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  type        = string
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

variable "stage_name" {
  description = "Stage name for the API"
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Enable auto-deploy"
  type        = bool
  default     = true
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}
