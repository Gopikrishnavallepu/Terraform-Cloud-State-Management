output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.demo_lambda.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.demo_lambda.function_name
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.demo_lambda.invoke_arn
}
