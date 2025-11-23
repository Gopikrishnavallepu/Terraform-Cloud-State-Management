# Terraform Infrastructure Diagram (Text-Based)

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         AWS INFRASTRUCTURE                              │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│                         API GATEWAY (HTTP)                               │
│                                                                          │
│  Endpoint: https://api.example.com                                      │
│  Protocol: HTTP/REST                                                    │
│  Routes: GET / → Lambda Integration                                    │
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │  Integration: AWS_PROXY (HTTP API)                               │  │
│  │  Method: POST                                                    │  │
│  │  Payload Format: 2.0                                             │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└──────────────────────┬───────────────────────────────────────────────────┘
                       │
                       │ Invokes (Lambda Permission)
                       │
                       ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                    LAMBDA FUNCTION (Compute Layer)                       │
│                                                                          │
│  Function: demo-zero-cost-fn                                            │
│  Runtime: Node.js 18.x                                                  │
│  Handler: index.handler                                                 │
│  Timeout: 5 seconds                                                     │
│                                                                          │
│  Environment Variables:                                                 │
│  ├─ BUCKET_NAME ────────────► (S3 Bucket Name)                         │
│  └─ CONFIG_PARAM ───────────► (SSM Parameter Name)                     │
│                                                                          │
│  Execution Role: lambda_exec_role (IAM)                                │
└──────────────────┬────────────────────────────────────┬─────────────────┘
                   │                                    │
       Read/Write  │                    Read/Get        │
                   ▼                                    ▼
        ┌──────────────────────┐        ┌──────────────────────────┐
        │   S3 Bucket          │        │   SSM Parameter Store    │
        │                      │        │                          │
        │ Name: demo-...       │        │ Name: /demo/config       │
        │ Versioning: OFF      │        │ Type: String             │
        │ Force Destroy: YES   │        │ Value: example-value     │
        │                      │        │                          │
        │ Objects:             │        │ Use: Config Management   │
        │ ├─ App data          │        │                          │
        │ ├─ Logs              │        │ Access: Lambda reads     │
        │ └─ Uploads           │        │                          │
        └──────────────────────┘        └──────────────────────────┘
```

---

## Module Dependency Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                          ROOT TERRAFORM                             │
│                         (main.tf)                                   │
│                                                                     │
│  Calls 5 Modules with Variables                                   │
└──────┬──────────┬──────────┬──────────┬──────────────────────────┘
       │          │          │          │
       ▼          ▼          ▼          ▼
    ┌────┐    ┌────┐    ┌────┐    ┌────┐
    │IAM │    │S3  │    │SSM │    │LAMBDA
    │ M. │    │ M. │    │ M. │    │ M.
    └─┬──┘    └─┬──┘    └─┬──┘    └─┬──┘
      │         │         │         │
      │         │         │         │
      └────┬────┴────┬────┴────┬────┘
           │         │         │
           ▼         ▼         ▼
      ┌─────────────────────────────┐
      │    API GATEWAY MODULE       │
      │    (Uses outputs from       │
      │     Lambda, IAM)            │
      └─────────────────┬───────────┘
                        │
                        ▼
              ┌──────────────────┐
              │   Root Outputs   │
              │  (api_endpoint   │
              │   bucket_name    │
              │   lambda_arn)    │
              └──────────────────┘
```

---

## Data Flow Diagram

```
┌─────────────────┐
│   Client/User   │
│  (HTTP Request) │
└────────┬────────┘
         │
         │ GET / HTTP/1.1
         │
         ▼
┌────────────────────────────────┐
│   API Gateway                  │
│   ├─ Route: GET /              │
│   ├─ Integration: AWS_PROXY    │
│   └─ Auto Deploy: Enabled      │
└────────┬───────────────────────┘
         │
         │ Invoke Function
         │ (Request Payload)
         │
         ▼
┌────────────────────────────────┐
│   Lambda Function              │
│   ├─ Handler: index.handler    │
│   ├─ Reads: BUCKET_NAME        │
│   ├─ Reads: CONFIG_PARAM       │
│   └─ Returns: Response         │
└────┬───────────────┬───────────┘
     │               │
     │ GET           │ GetParameter
     │               │
     ▼               ▼
  ┌─────┐      ┌──────────┐
  │ S3  │      │   SSM    │
  │ Bucket     │ Parameter│
  └─────┘      └──────────┘
     │               │
     │ (data)        │ (config)
     │               │
     └───────┬───────┘
             │
             ▼
     ┌──────────────┐
     │  Lambda      │
     │  Processes   │
     │  Response    │
     └──────┬───────┘
            │
            │ Return Response
            │
            ▼
     ┌──────────────┐
     │  API Gateway │
     │  Returns     │
     │  JSON/Data   │
     └──────┬───────┘
            │
            │ HTTP 200
            │
            ▼
     ┌──────────────┐
     │    Client    │
     │   Receives   │
     │  Response    │
     └──────────────┘
```

---

## Module Structure Tree

```
Terraform-Cloud-State-Management/
│
├── ROOT CONFIGURATION
│   ├── main.tf              (Calls all modules)
│   ├── variables.tf         (All input variables)
│   ├── outputs.tf           (All outputs)
│   └── version.tf           (Provider versions)
│
└── MODULES/ (Reusable Components)
    │
    ├── modules/iam/         ► IAM Role & Policy
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── modules/s3/          ► S3 Bucket
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── modules/ssm/         ► Parameter Store
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── modules/lambda/      ► Lambda Function
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── modules/api_gateway/ ► API Gateway
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Resource Relationships

```
AWS IAM ROLE (lambda_exec_role)
    │
    ├─ Attached Policy: AWSLambdaBasicExecutionRole
    │
    ▼
LAMBDA FUNCTION (demo-zero-cost-fn)
    │
    ├─ Reads from: SSM Parameter (/demo/config)
    │
    ├─ Reads/Writes to: S3 Bucket (demo-zero-cost-bucket-*)
    │
    ├─ Publishes Logs to: CloudWatch Logs
    │
    ▼
API GATEWAY (http-api)
    │
    ├─ Protocol: HTTP
    │
    ├─ Integration: Lambda (AWS_PROXY)
    │
    ├─ Route: GET / → Lambda Integration
    │
    ├─ Stage: $default
    │
    ├─ Auto Deploy: Enabled
    │
    ▼
LAMBDA PERMISSION
    │
    └─ Allows: API Gateway to invoke Lambda
```

---

## Variable Flow

```
ROOT VARIABLES.TF
│
├─ aws_region ────────────────► Provider Region
│
├─ iam_role_name ─────────────► IAM Module
│
├─ bucket_name ───────────────► S3 Module
├─ s3_force_destroy ──────────► S3 Module
├─ s3_enable_versioning ──────► S3 Module
│
├─ ssm_parameter_name ────────► SSM Module
├─ ssm_parameter_value ───────► SSM Module
├─ ssm_parameter_type ────────► SSM Module
│
├─ lambda_function_name ──────► Lambda Module
├─ lambda_handler ────────────► Lambda Module
├─ lambda_runtime ────────────► Lambda Module
├─ lambda_timeout ────────────► Lambda Module
│
├─ api_gateway_name ──────────► API Gateway Module
├─ api_protocol_type ─────────► API Gateway Module
├─ integration_type ──────────► API Gateway Module
├─ route_key ─────────────────► API Gateway Module
├─ auto_deploy ───────────────► API Gateway Module
│
└─ (All passed to respective modules)
        │
        ▼
   MODULE RESOURCES
        │
        ▼
   AWS INFRASTRUCTURE
```

---

## Scaling Scenarios

### Scenario 1: Multiple Lambda Functions
```
API Gateway
    │
    ├─► Lambda API Handler ──────► S3 + SSM
    │
    ├─► Lambda Scheduler ────────► S3 + SSM
    │
    └─► Lambda Processor ────────► S3 + SSM
```

### Scenario 2: Multi-Environment
```
dev.tfvars      staging.tfvars      prod.tfvars
    │                │                  │
    └────────┬───────┴──────┬───────────┘
             │              │
         terraform      terraform
           apply          apply
             │              │
    ┌────────▼──┐    ┌─────▼─────┐
    │ DEV Stack │    │ PROD Stack │
    └────────────┘    └────────────┘
```

### Scenario 3: Modular Registry
```
module "lambda" {
  source = "git::https://github.com/...//modules/lambda"
}

module "api" {
  source = "git::https://github.com/...//modules/api_gateway"
}
```

---

## Quick Reference: What Each Module Does

| Module | Purpose | Key Outputs |
|--------|---------|-------------|
| **IAM** | Create execution role for Lambda | Role ARN, Role Name |
| **S3** | Create bucket for storage | Bucket ID, Name, ARN |
| **SSM** | Store configuration values | Parameter ARN, Name |
| **Lambda** | Define compute function | Function ARN, Name, Invoke ARN |
| **API Gateway** | Create HTTP endpoint | API Endpoint, API ID |

