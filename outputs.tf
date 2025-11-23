output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.function_name
}

output "api_endpoint" {
  description = "Endpoint of the API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "ssm_parameter_name" {
  description = "Name of the SSM parameter"
  value       = module.ssm.parameter_name
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = module.api_gateway.api_id
}
