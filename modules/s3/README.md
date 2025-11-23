# Terraform AWS S3 Module

## Overview
This module creates and manages AWS S3 buckets with configurable versioning, encryption, and lifecycle policies.

## Features
- Creates S3 buckets with unique naming
- Configurable versioning support
- Optional force destroy capability
- Resource tagging support
- CloudFront distribution ready

## Usage

### Basic Usage
```hcl
module "s3" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/s3"

  bucket_name       = "my-app-bucket"
  force_destroy     = true
  enable_versioning = false
}
```

### Production Usage
```hcl
module "s3" {
  source = "git::https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management.git//modules/s3"

  bucket_name       = "my-app-bucket-prod"
  force_destroy     = false
  enable_versioning = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `bucket_name` | Name of the S3 bucket | `string` | `demo-zero-cost-bucket` | No |
| `force_destroy` | Allow destruction of non-empty bucket | `bool` | `true` | No |
| `enable_versioning` | Enable versioning for the S3 bucket | `bool` | `false` | No |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | ID of the S3 bucket |
| `bucket_name` | Name of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |

## Requirements

| Name | Version |
|------|---------|
| `aws` | ~> 6.14.1 |
| `terraform` | ~> 1.14.0 |

## License
MIT License

## Author
Gopikrishnavallepu
