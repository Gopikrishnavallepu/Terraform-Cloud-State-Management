# Terraform AWS Lambda Module

## Overview
This module creates AWS Lambda functions with environment variables, IAM roles, and code deployment capabilities.

## Features
- Creates Lambda functions with configurable runtime
- Environment variable support
- Source code management via ZIP files
- Timeout and memory configuration
- VPC support (optional)

## Usage

### Basic Usage
```hcl
module "lambda" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/lambda"

  function_name        = "my-function"
  lambda_exec_role_arn = aws_iam_role.lambda_role.arn
  handler              = "index.handler"
  runtime              = "nodejs18.x"
  timeout              = 30
  bucket_name          = "my-bucket"
  config_param_name    = "/app/config"
}
```

### Advanced Usage with VPC
```hcl
module "lambda" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/lambda"

  function_name        = "vpc-enabled-function"
  lambda_exec_role_arn = aws_iam_role.lambda_role.arn
  handler              = "index.handler"
  runtime              = "nodejs18.x"
  timeout              = 60
  bucket_name          = "my-bucket"
  config_param_name    = "/app/config"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `function_name` | Name of the Lambda function | `string` | `demo-zero-cost-fn` | No |
| `lambda_exec_role_arn` | ARN of the Lambda execution role | `string` | | Yes |
| `handler` | Handler for the Lambda function | `string` | `index.handler` | No |
| `runtime` | Runtime for the Lambda function | `string` | `nodejs18.x` | No |
| `timeout` | Timeout for the Lambda function | `number` | `5` | No |
| `bucket_name` | Name of the S3 bucket | `string` | | Yes |
| `config_param_name` | Name of the SSM parameter | `string` | | Yes |

## Outputs

| Name | Description |
|------|-------------|
| `function_arn` | ARN of the Lambda function |
| `function_name` | Name of the Lambda function |
| `invoke_arn` | Invoke ARN of the Lambda function |

## Requirements

| Name | Version |
|------|---------|
| `aws` | ~> 6.14.1 |
| `terraform` | ~> 1.14.0 |
| `archive` | Latest |

## License
MIT License

## Author
Gopikrishnavallepu
