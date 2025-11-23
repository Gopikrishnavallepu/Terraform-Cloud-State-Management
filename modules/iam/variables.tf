variable "iam_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
  default     = "lambda_exec_role"
}

variable "policy_arn" {
  description = "ARN of the IAM policy to attach"
  type        = string
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
