# Terraform AWS SSM Parameter Module

## Overview
This module creates and manages AWS Systems Manager Parameter Store entries for configuration management.

## Features
- Creates String, StringList, and SecureString parameters
- Supports encryption with KMS
- Parameter versioning
- Tag support
- Description and default value management

## Usage

### Basic Usage
```hcl
module "ssm" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/ssm"

  parameter_name        = "/app/config"
  parameter_type        = "String"
  parameter_value       = "my-config-value"
  parameter_description = "Application configuration"
}
```

### Secure Parameter Usage
```hcl
module "ssm" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/ssm"

  parameter_name        = "/app/secrets"
  parameter_type        = "SecureString"
  parameter_value       = "secret-value"
  parameter_description = "Secret configuration"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `parameter_name` | Name of the SSM parameter | `string` | `/demo/config` | No |
| `parameter_type` | Type of the SSM parameter | `string` | `String` | No |
| `parameter_value` | Value of the SSM parameter | `string` | `example-value` | No |
| `parameter_description` | Description of the SSM parameter | `string` | `Demo app config` | No |

## Outputs

| Name | Description |
|------|-------------|
| `parameter_arn` | ARN of the SSM parameter |
| `parameter_name` | Name of the SSM parameter |

## Requirements

| Name | Version |
|------|---------|
| `aws` | ~> 6.14.1 |
| `terraform` | ~> 1.14.0 |

## License
MIT License

## Author
Gopikrishnavallepu
