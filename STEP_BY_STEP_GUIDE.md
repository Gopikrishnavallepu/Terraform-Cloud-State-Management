# Complete Terraform Implementation Guide
## Step-by-Step Guide with Best Practices

---

## Table of Contents
1. [Project Structure Overview](#project-structure-overview)
2. [Environment Setup](#environment-setup)
3. [Module Usage](#module-usage)
4. [Environment-Specific Deployments](#environment-specific-deployments)
5. [Terraform Cloud Integration](#terraform-cloud-integration)
6. [Locals and Variables](#locals-and-variables)
7. [Data Sources](#data-sources)
8. [Testing with Terratest](#testing-with-terratest)
9. [Module Publishing](#module-publishing)
10. [Best Practices](#best-practices)

---

## 1. Project Structure Overview

```
Terraform-Cloud-State-Management/
├── main.tf                      # Root module configuration
├── variables.tf                 # All input variables
├── outputs.tf                   # Root outputs
├── locals.tf                    # Computed values
├── data.tf                      # Data sources
├── version.tf                   # Terraform & provider versions
│
├── modules/                     # Reusable modules
│   ├── iam/                    # IAM module
│   ├── s3/                     # S3 module
│   ├── ssm/                    # SSM module
│   ├── lambda/                 # Lambda module
│   └── api_gateway/            # API Gateway module
│
├── environments/                # Environment-specific configs
│   ├── dev/
│   │   ├── terraform.tf
│   │   ├── terraform.tfvars
│   │   └── locals.tf
│   ├── staging/
│   │   ├── terraform.tf
│   │   ├── terraform.tfvars
│   │   └── locals.tf
│   └── prod/
│       ├── terraform.tf
│       ├── terraform.tfvars
│       └── locals.tf
│
├── tests/                      # Terratest files
│   ├── terraform_test.go
│   └── go.mod
│
└── docs/                       # Documentation
    ├── MODULARITY_REFACTORING_SUMMARY.md
    ├── INFRASTRUCTURE_DIAGRAM.md
    └── STEP_BY_STEP_GUIDE.md
```

### Key Files Explanation

| File | Purpose |
|------|---------|
| `main.tf` | Calls all modules with variables |
| `variables.tf` | Defines all input variables with validation |
| `outputs.tf` | Aggregates outputs from modules |
| `locals.tf` | Computed/grouped values (naming, tags, configs) |
| `data.tf` | References existing AWS resources |
| `version.tf` | Terraform version & provider requirements |
| `terraform.tfvars` | Environment-specific variable values |

---

## 2. Environment Setup

### Step 1: Initialize Terraform

```bash
# Initialize root module (downloads providers & modules)
terraform init

# Initialize specific environment
cd environments/dev
terraform init
```

### Step 2: Validate Configuration

```bash
# Validate root configuration
terraform validate

# Validate modules
terraform validate -chdir=modules/iam
terraform validate -chdir=modules/s3
```

### Step 3: Format Code

```bash
# Format all Terraform files
terraform fmt -recursive

# Show what will be formatted
terraform fmt -recursive -check
```

### Step 4: Run Pre-Deployment Checks

```bash
# Check for security issues
tfsec .

# Lint checks
tflint
```

---

## 3. Module Usage

### Using a Single Module

```hcl
# Example: Using just the S3 module
module "my_bucket" {
  source = "./modules/s3"

  bucket_name       = "my-app-data"
  force_destroy     = false
  enable_versioning = true
}

output "bucket" {
  value = module.my_bucket.bucket_name
}
```

### Using Multiple Modules Together

```hcl
# Create IAM role
module "iam" {
  source = "./modules/iam"
  
  iam_role_name = "my-lambda-role"
}

# Create S3 bucket
module "s3" {
  source = "./modules/s3"
  
  bucket_name = "my-app-bucket"
}

# Create Lambda using IAM role and S3 bucket
module "lambda" {
  source = "./modules/lambda"
  
  lambda_exec_role_arn = module.iam.lambda_exec_role_arn
  bucket_name          = module.s3.bucket_name
}
```

### Module Composition Pattern

```
┌─────────────────────┐
│  Root Module        │
├─────────────────────┤
│ Calls Modules       │
│ ├─ IAM              │
│ ├─ S3               │
│ ├─ Lambda ◄─────────┼─ Uses outputs from IAM & S3
│ ├─ API Gateway ◄────┼─ Uses Lambda output
│ └─ SSM              │
└─────────────────────┘
```

---

## 4. Environment-Specific Deployments

### Deploying to Development

```bash
# Change to dev environment
cd environments/dev

# Initialize Terraform Cloud workspace
terraform init

# Plan changes (dry-run)
terraform plan

# Apply changes
terraform apply

# View outputs
terraform output
```

### Deploying to Staging

```bash
# Change to staging environment
cd environments/staging

terraform init
terraform plan
terraform apply
```

### Deploying to Production

```bash
# Change to prod environment
cd environments/prod

# Always use -auto-approve=false for production
terraform plan -out=tfplan

# Review plan carefully
terraform show tfplan

# Apply with confirmation
terraform apply tfplan
```

### Key Differences Between Environments

| Aspect | Dev | Staging | Prod |
|--------|-----|---------|------|
| Force Destroy | true | false | false |
| Versioning | false | true | true |
| Parameter Type | String | String | SecureString |
| Lambda Timeout | 5s | 10s | 30s |
| Auto Deploy | true | true | false |
| CloudWatch Retention | 7 days | 30 days | 90 days |

---

## 5. Terraform Cloud Integration

### Step 1: Create Terraform Cloud Account

1. Go to https://app.terraform.io/signup
2. Create account and organization
3. Generate API token

### Step 2: Configure Terraform Cloud

```bash
# Login to Terraform Cloud
terraform login

# Enter API token when prompted
```

### Step 3: Update version.tf

```hcl
terraform {
  cloud {
    organization = "your-org-name"

    workspaces {
      name = "production-workspace"
    }
  }

  required_version = "~> 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.1"
    }
  }
}
```

### Step 4: Migrate State to Terraform Cloud

```bash
# Initialize to use Terraform Cloud
terraform init

# Terraform will ask to migrate existing state
# Type 'yes' to confirm
```

### Terraform Cloud Benefits

✓ **Remote State** - Share state across team  
✓ **State Locking** - Prevent concurrent modifications  
✓ **VCS Integration** - Auto-run on commits  
✓ **Runs UI** - Visual plan/apply in browser  
✓ **Team Management** - RBAC & audit logs  

---

## 6. Locals and Variables

### Variables (Input)

```hcl
# variables.tf - Defines what can be passed in
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  
  validation {
    condition     = var.lambda_timeout > 0 && var.lambda_timeout <= 900
    error_message = "Timeout must be between 1 and 900 seconds."
  }
}
```

### Locals (Computed Values)

```hcl
# locals.tf - Computed values & groups
locals {
  # Derived values
  environment = var.environment
  region      = var.aws_region
  
  # Naming convention
  name_prefix = "app-${local.environment}"
  
  # Resource grouping
  common_tags = {
    Project     = "my-project"
    Environment = local.environment
    ManagedBy   = "Terraform"
    CreatedDate = timestamp()
  }
  
  # Configuration maps
  env_config = {
    dev = {
      instance_type = "t2.micro"
      backup        = false
    }
    prod = {
      instance_type = "t3.medium"
      backup        = true
    }
  }
  
  # Access env config
  instance_type = local.env_config[local.environment].instance_type
}
```

### Using Variables vs Locals

```hcl
# Variable - input from user/tfvars
variable "bucket_name" {
  type = string
}

# Local - computed value
locals {
  full_bucket_name = "${var.bucket_name}-${var.environment}"
}

# Usage
resource "aws_s3_bucket" "example" {
  bucket = local.full_bucket_name  # Uses computed local
}
```

### Passing Variables

```bash
# Via command line
terraform apply -var="environment=staging"

# Via file (recommended)
terraform apply -var-file="staging.tfvars"

# Via environment variables
export TF_VAR_environment=staging
terraform apply

# In terraform.tfvars (auto-loaded)
environment = "staging"
```

---

## 7. Data Sources

### Purpose
Reference existing AWS resources without managing them in Terraform.

### Common Data Sources

```hcl
# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get available regions
data "aws_regions" "available" {}

# Get current region details
data "aws_region" "current" {
  name = var.aws_region
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Reference existing VPC
data "aws_vpc" "default" {
  default = true
}

# Reference existing security group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

# Reference existing AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# Reference existing IAM policy
data "aws_iam_policy" "lambda_basic" {
  name = "AWSLambdaBasicExecutionRole"
}
```

### Using Data Source Values

```hcl
# In locals
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  azs        = data.aws_availability_zones.available.names
}

# In resources
resource "aws_lambda_function" "example" {
  role = data.aws_iam_policy.lambda_basic.arn
  
  environment {
    variables = {
      ACCOUNT_ID = data.aws_caller_identity.current.account_id
      REGION     = data.aws_region.current.name
    }
  }
}

# In outputs
output "current_account" {
  value = data.aws_caller_identity.current.account_id
}
```

---

## 8. Testing with Terratest

### Setup

```bash
# Install Go (required)
# Download from https://golang.org/dl

# Navigate to tests directory
cd tests

# Initialize Go modules
go mod init github.com/yourname/yourrepo

# Download Terratest
go get -u github.com/gruntwork-io/terratest/modules/terraform
go get -u github.com/stretchr/testify
```

### Write Tests

```go
// tests/terraform_test.go
package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestIAMModule(t *testing.T) {
	t.Parallel()

	// Configure Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/iam",
		Vars: map[string]interface{}{
			"iam_role_name": "test-role",
		},
	}

	// Cleanup after test
	defer terraform.Destroy(t, terraformOptions)

	// Apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	roleArn := terraform.Output(t, terraformOptions, "lambda_exec_role_arn")

	// Assert
	assert.NotEmpty(t, roleArn)
	assert.Contains(t, roleArn, "arn:aws:iam")
}
```

### Run Tests

```bash
# Run all tests
go test -v

# Run specific test
go test -v -run TestIAMModule

# Run with timeout
go test -v -timeout 30m

# Run tests in parallel
go test -v -parallel 4
```

### Test Best Practices

✓ Use `t.Parallel()` for independent tests  
✓ Clean up with `defer terraform.Destroy()`  
✓ Test module outputs  
✓ Validate resource attributes  
✓ Use meaningful test names  

---

## 9. Module Publishing

### Publish to Terraform Registry

#### Step 1: Prepare Module

```
Module Requirements:
✓ README.md with usage examples
✓ variables.tf with descriptions
✓ outputs.tf with descriptions
✓ main.tf with resources
✓ LICENSE file (MIT recommended)
✓ GitHub repository
✓ Semantic versioning (v1.0.0)
```

#### Step 2: Create GitHub Release

```bash
# Add Git tags
git tag -a v1.0.0 -m "First release"

# Push tags
git push origin v1.0.0
```

#### Step 3: Register Module

1. Go to https://registry.terraform.io
2. Click "Publish" → "Module"
3. Connect GitHub account
4. Select repository
5. Accept auto-published versions

#### Step 4: Use Published Module

```hcl
# From Terraform Registry
module "s3" {
  source  = "gopikrishnavallepu/s3/aws"
  version = "1.0.0"

  bucket_name = "my-bucket"
}

# From GitHub
module "s3" {
  source = "git::https://github.com/Gopikrishnavallepu/terraform-aws-s3.git"

  bucket_name = "my-bucket"
}
```

### Module Registry Requirements

- **Naming**: `terraform-{provider}-{name}`
- **Documentation**: Comprehensive README
- **Inputs/Outputs**: Fully documented
- **License**: Required
- **Tags**: For discoverability
- **Versions**: Semantic versioning

---

## 10. Best Practices

### Code Organization

✓ **Separate Modules** - One responsibility per module  
✓ **Variable Grouping** - Use `locals.tf` for derived values  
✓ **Environment Separation** - Dev/staging/prod configs  
✓ **Naming Conventions** - Consistent resource names  
✓ **Documentation** - README for every module  

### Security

✓ **Never hardcode secrets** - Use SSM/Secrets Manager  
✓ **Use SecureString** - For sensitive parameters  
✓ **Encryption** - Enable EBS/S3 encryption  
✓ **IAM Principle of Least Privilege** - Minimal permissions  
✓ **State file security** - Remote state with encryption  

### Performance

✓ **Parallel Modules** - Independent modules execute parallel  
✓ **depends_on** - Only use when implicit dependencies insufficient  
✓ **Targeted Apply** - `terraform apply -target=module.s3`  
✓ **Import Resources** - Manage existing AWS resources  

### State Management

✓ **Remote State** - Use Terraform Cloud/S3  
✓ **State Locking** - Prevent concurrent modifications  
✓ **Backup** - Keep state backups  
✓ **Never Edit Directly** - Use Terraform commands  
✓ **Version Control** - NOT for .tfstate files  

### Deployment

```bash
# Always use plan first
terraform plan -out=tfplan

# Review carefully
terraform show tfplan

# Apply from saved plan (reproducible)
terraform apply tfplan

# For production
terraform plan -out=prod.tfplan
# Manual review by team
terraform apply prod.tfplan
```

### Validation & Testing

```bash
# Validate syntax
terraform validate

# Format code
terraform fmt -recursive

# Lint (requires tflint)
tflint

# Security scan (requires tfsec)
tfsec

# Unit tests (Terratest)
go test -v ./tests/...
```

### Example: Complete Workflow

```bash
# 1. Create feature branch
git checkout -b feature/new-api

# 2. Make changes
# Edit modules, add resources

# 3. Format and validate
terraform fmt -recursive
terraform validate
tflint
tfsec

# 4. Plan changes
cd environments/staging
terraform plan -out=tfplan

# 5. Run tests
cd ../../tests
go test -v

# 6. Apply to staging
cd ../environments/staging
terraform apply tfplan

# 7. Commit and push
git add .
git commit -m "feat: Add new API resources"
git push origin feature/new-api

# 8. Create pull request
# Review, test, approve

# 9. Merge to main
git merge feature/new-api

# 10. Deploy to production
cd environments/prod
terraform plan -out=prod.tfplan
terraform apply prod.tfplan
```

---

## Troubleshooting Common Issues

### Issue: "Provider plugins not installed"
```bash
terraform init
```

### Issue: "State file locked"
```bash
terraform force-unlock <LOCK_ID>
```

### Issue: "Module not found"
```bash
# Update module sources
terraform get -update

# Reinitialize
terraform init -upgrade
```

### Issue: "Variable validation failed"
```hcl
# Add validation block to variable
variable "instance_count" {
  type = number
  
  validation {
    condition     = var.instance_count > 0
    error_message = "Must be positive."
  }
}
```

---

## Summary

This guide covers:
1. ✓ Complete project structure
2. ✓ Environment-specific deployments
3. ✓ Module reuse and composition
4. ✓ Locals and variable management
5. ✓ Data source usage
6. ✓ Testing with Terratest
7. ✓ Publishing to registry
8. ✓ Security and best practices
9. ✓ Complete workflows

For more information, visit:
- https://www.terraform.io/docs
- https://registry.terraform.io
- https://github.com/Gopikrishnavallepu/Terraform-Cloud-State-Management
