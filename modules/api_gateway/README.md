# Terraform AWS API Gateway Module

## Overview
This module creates HTTP API Gateway endpoints with Lambda integrations, supporting multiple routes and stages.

## Features
- Creates HTTP API Gateway
- Lambda integration setup
- Configurable routes and methods
- Auto-deploy capability
- Stage management

## Usage

### Basic Usage
```hcl
module "api_gateway" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/api_gateway"

  api_name              = "my-api"
  protocol_type         = "HTTP"
  lambda_invoke_arn     = module.lambda.invoke_arn
  lambda_function_name  = module.lambda.function_name
}
```

### Production Usage
```hcl
module "api_gateway" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/api_gateway"

  api_name               = "production-api"
  protocol_type          = "HTTP"
  integration_type       = "AWS_PROXY"
  lambda_invoke_arn      = module.lambda.invoke_arn
  lambda_function_name   = module.lambda.function_name
  stage_name             = "prod"
  auto_deploy            = false
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `api_name` | Name of the API Gateway | `string` | `http-api` | No |
| `protocol_type` | Protocol type for the API | `string` | `HTTP` | No |
| `integration_type` | Integration type | `string` | `AWS_PROXY` | No |
| `lambda_invoke_arn` | Invoke ARN of the Lambda function | `string` | | Yes |
| `lambda_function_name` | Name of the Lambda function | `string` | | Yes |
| `stage_name` | Stage name for the API | `string` | `$default` | No |
| `auto_deploy` | Enable auto-deploy | `bool` | `true` | No |

## Outputs

| Name | Description |
|------|-------------|
| `api_endpoint` | Endpoint of the API Gateway |
| `api_id` | ID of the API Gateway |
| `stage_name` | Name of the API stage |

## Requirements

| Name | Version |
|------|---------|
| `aws` | ~> 6.14.1 |
| `terraform` | ~> 1.14.0 |

## License
MIT License

## Author
Gopikrishnavallepu
