resource "aws_ssm_parameter" "app_config" {
  name        = var.parameter_name
  type        = var.parameter_type
  value       = var.parameter_value
  description = var.parameter_description
}
