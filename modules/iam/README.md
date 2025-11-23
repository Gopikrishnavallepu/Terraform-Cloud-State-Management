# Terraform AWS IAM Module

## Overview
This module creates AWS IAM roles and policies for Lambda function execution. It follows AWS best practices for role-based access control (RBAC).

## Features
- Creates IAM execution role for Lambda
- Attaches managed policies
- Supports custom inline policies
- Tags resources appropriately

## Usage

### Basic Usage
```hcl
module "iam" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/iam"

  iam_role_name = "my-lambda-role"
  policy_arn    = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

### Advanced Usage
```hcl
module "iam" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/iam"

  iam_role_name = "advanced-lambda-role"
  policy_arn    = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `iam_role_name` | Name of the IAM role for Lambda | `string` | `lambda_exec_role` | No |
| `policy_arn` | ARN of the IAM policy to attach | `string` | `arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole` | No |

## Outputs

| Name | Description |
|------|-------------|
| `lambda_exec_role_arn` | ARN of the Lambda execution role |
| `lambda_exec_role_name` | Name of the Lambda execution role |

## Requirements

| Name | Version |
|------|---------|
| `aws` | ~> 6.14.1 |
| `terraform` | ~> 1.14.0 |

## License
MIT License - See LICENSE file for details

## Author
Gopikrishnavallepu
