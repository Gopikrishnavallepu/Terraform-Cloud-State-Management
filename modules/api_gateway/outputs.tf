output "api_endpoint" {
  description = "Endpoint of the API Gateway"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_apigatewayv2_api.api.id
}

output "stage_name" {
  description = "Name of the API stage"
  value       = aws_apigatewayv2_stage.default.name
}
