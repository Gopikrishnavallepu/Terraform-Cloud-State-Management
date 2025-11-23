# Comprehensive Terraform Interview Q&A

## 1. What is Terraform?
Terraform is an open-source Infrastructure as Code (IaC) tool by HashiCorp that allows you to define, provision, and manage cloud infrastructure using declarative configuration files.

---

## 2. What are the main benefits of using Terraform?
- Infrastructure as Code (versioned, repeatable)
- Multi-cloud support (AWS, Azure, GCP, etc.)
- Declarative syntax
- State management
- Modular and reusable code
- Automation and scalability

---

## 3. What is a Terraform provider?
A provider is a plugin that enables Terraform to interact with APIs of cloud platforms or services (e.g., AWS, Azure, Google Cloud, GitHub).

---

## 4. What is a Terraform module?
A module is a container for multiple resources that are used together. Modules enable code reuse, organization, and abstraction.

---

## 5. What is the difference between `terraform plan` and `terraform apply`?
- `terraform plan`: Shows the changes Terraform will make to your infrastructure.
- `terraform apply`: Executes the changes and provisions resources.

---

## 6. What is the Terraform state file?
The state file (`terraform.tfstate`) tracks the current state of your infrastructure. It is used by Terraform to map resources in your configuration to real-world resources.

---

## 7. How do you manage Terraform state in a team?
- Use remote backends (Terraform Cloud, S3, Azure Storage, etc.)
- Enable state locking to prevent concurrent changes
- Encrypt state files for security

---

## 8. What is a backend in Terraform?
A backend defines where Terraform stores its state data (local, remote, etc.) and how operations like state locking and remote execution are handled.

---

## 9. How do you use variables in Terraform?
- Define in `variables.tf`
- Set via `terraform.tfvars`, CLI (`-var`), environment variables (`TF_VAR_`), or directly in the configuration

---

## 10. What are outputs in Terraform?
Outputs expose information about your infrastructure after apply (e.g., IP addresses, resource IDs) and can be used by other modules or tools.

---

## 11. What is the purpose of `locals` in Terraform?
Locals are named values computed from variables and expressions, used to simplify and DRY up your configuration.

---

## 12. How do you reference existing resources in Terraform?
Use data sources (e.g., `data "aws_vpc" "default" { ... }`) to fetch information about resources not managed by Terraform.

---

## 13. What is the difference between `count` and `for_each`?
- `count`: Creates multiple instances of a resource based on an integer.
- `for_each`: Creates resources for each item in a map or set, allowing more flexible indexing.

---

## 14. How do you create reusable modules?
- Place code in a directory with `main.tf`, `variables.tf`, `outputs.tf`
- Use `module` blocks in root configuration to call modules
- Publish modules to Terraform Registry or use local paths

---

## 15. What is remote state locking?
Prevents multiple users from making concurrent changes to the state file, avoiding race conditions and corruption.

---

## 16. How do you handle secrets in Terraform?
- Use `Sensitive` variables
- Store secrets in SSM Parameter Store, Secrets Manager, Vault
- Avoid hardcoding secrets in code or state files

---

## 17. What is the lifecycle block in Terraform?
Controls resource behavior (e.g., `create_before_destroy`, `prevent_destroy`, `ignore_changes`).

---

## 18. How do you import existing resources into Terraform?
Use `terraform import` to bring resources under Terraform management, then add configuration to your code.

---

## 19. What is the difference between `depends_on` and implicit dependencies?
- Implicit: Created by referencing outputs/attributes of other resources.
- Explicit: Use `depends_on` to force ordering when implicit dependencies are not enough.

---

## 20. How do you test Terraform modules?
- Use Terratest (Go-based testing framework)
- Use `terraform validate`, `tflint`, `tfsec` for static analysis

---

## 21. What is a workspace in Terraform?
Workspaces allow you to manage multiple state files for different environments (e.g., dev, staging, prod) within the same configuration.

---

## 22. How do you publish a module to the Terraform Registry?
- Create a public GitHub repo named `terraform-<PROVIDER>-<NAME>`
- Add `README.md`, `main.tf`, `variables.tf`, `outputs.tf`, LICENSE
- Tag releases (e.g., v1.0.0)
- Connect repo to Terraform Registry

---

## 23. What are best practices for organizing Terraform code?
- Use modules for reusability
- Separate environments (dev, staging, prod)
- Use remote state
- Document code and modules
- Use version control for code, not state files

---

## 24. How do you handle resource drift?
- Run `terraform plan` regularly
- Use `terraform refresh` to update state
- Investigate and fix drift manually or with `terraform apply`

---

## 25. What is the difference between declarative and imperative IaC?
- Declarative (Terraform): You describe the desired state, and the tool figures out how to achieve it.
- Imperative (Ansible, scripts): You specify the exact steps to reach the desired state.

---

## 26. How do you use remote modules from the Terraform Registry?
```
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  cidr    = "10.0.0.0/16"
}
```

---

## 27. What is the difference between `terraform destroy` and `terraform taint`?
- `terraform destroy`: Removes all managed resources.
- `terraform taint`: Marks a resource for recreation on next apply.

---

## 28. How do you upgrade Terraform and provider versions safely?
- Update `required_version` and provider versions in `version.tf`
- Run `terraform init -upgrade`
- Review plan for breaking changes

---

## 29. How do you use conditional expressions in Terraform?
```
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0
}
```

---

## 30. What is the difference between `terraform state` and `terraform output`?
- `terraform state`: Inspect and manage the state file.
- `terraform output`: Show output values from the last apply.

---

## Scenario-Based Questions

### 31. How would you deploy the same infrastructure to dev, staging, and prod?
- Use workspaces or separate directories with environment-specific `terraform.tfvars`
- Parameterize variables for each environment
- Use remote state for each environment

---

### 32. How do you ensure your S3 buckets are encrypted and versioned in production?
- Set `enable_versioning = true` and `server_side_encryption_configuration` in your S3 module
- Use environment variables or locals to enforce settings in prod

---

### 33. How do you manage IAM policies for least privilege in Lambda?
- Attach only required managed policies
- Use inline policies for fine-grained control
- Regularly audit IAM roles and policies

---

### 34. How do you roll back a failed Terraform deployment?
- Use version control to revert code changes
- Restore previous state file from backup or remote backend
- Re-run `terraform apply` with the previous configuration

---

### 35. How do you handle breaking changes in a module?
- Use semantic versioning
- Test changes in a staging environment
- Communicate changes in README and CHANGELOG

---

## Advanced Topics

### 36. What is a data source and when would you use it?
A data source allows you to fetch information about existing resources (not managed by Terraform) for use in your configuration.

---

### 37. How do you use `for_each` with modules?
```
module "lambda" {
  for_each = var.lambda_configs
  source   = "./modules/lambda"
  function_name = each.value.name
  ...
}
```

---

### 38. How do you use `depends_on` with modules?
```
module "api_gateway" {
  source = "./modules/api_gateway"
  depends_on = [module.lambda]
  ...
}
```

---

### 39. How do you use dynamic blocks in Terraform?
Dynamic blocks allow you to generate nested blocks based on variables or lists.
```
resource "aws_security_group" "example" {
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

---

### 40. How do you secure Terraform state files?
- Use remote backends with encryption (S3 + KMS, Terraform Cloud)
- Restrict access to state files
- Enable state locking

---

## Module-Specific Questions

### 41. How do you structure a module for publishing?
- `main.tf`, `variables.tf`, `outputs.tf`, `README.md`, LICENSE
- Document all inputs/outputs
- Use semantic versioning

---

### 42. How do you test a module before publishing?
- Use Terratest for automated tests
- Use `terraform validate` and `terraform plan`
- Test in multiple environments

---

### 43. How do you use outputs from one module in another?
```
module "iam" { ... }
module "lambda" {
  lambda_exec_role_arn = module.iam.lambda_exec_role_arn
}
```

---

### 44. How do you handle cross-account deployments in Terraform?
- Use multiple provider blocks with different credentials
- Use `alias` for providers
- Pass provider configuration to modules

---

### 45. How do you automate Terraform deployments in CI/CD?
- Use tools like GitHub Actions, GitLab CI, Jenkins
- Store state remotely
- Use environment variables for secrets
- Run `terraform plan` and `terraform apply` in pipeline

---

## Best Practices & Real-World Tips

### 46. What are some common mistakes to avoid in Terraform?
- Hardcoding secrets
- Not using remote state
- Ignoring state file security
- Not using modules
- Not validating or testing code

---

### 47. How do you handle resource deletion protection?
Use `prevent_destroy` in the lifecycle block:
```
resource "aws_s3_bucket" "critical" {
  lifecycle {
    prevent_destroy = true
  }
}
```

---

### 48. How do you manage multiple AWS accounts with Terraform?
- Use multiple provider blocks with `alias`
- Use workspaces or separate state files
- Use cross-account IAM roles

---

### 49. How do you debug Terraform errors?
- Use `terraform plan` and `terraform apply` with `-debug`
- Check logs and error messages
- Use `terraform state` commands to inspect resources

---

### 50. How do you keep your Terraform code DRY and maintainable?
- Use modules and locals
- Use variable validation
- Document everything
- Use outputs for sharing data between modules

---

This Q&A covers the most important Terraform concepts, real-world scenarios, and best practices for interviews and practical use. If you need more advanced or specific questions, let me know!
