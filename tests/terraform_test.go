package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test IAM Module
func TestIAMModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/iam",
		Vars: map[string]interface{}{
			"iam_role_name": "test-lambda-role",
			"policy_arn":    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	roleArn := terraform.Output(t, terraformOptions, "lambda_exec_role_arn")
	roleName := terraform.Output(t, terraformOptions, "lambda_exec_role_name")

	// Assert outputs exist and are not empty
	assert.NotEmpty(t, roleArn, "Lambda role ARN should not be empty")
	assert.NotEmpty(t, roleName, "Lambda role name should not be empty")
	assert.Contains(t, roleArn, "arn:aws:iam", "Role ARN should contain iam service")
}

// Test S3 Module
func TestS3Module(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/s3",
		Vars: map[string]interface{}{
			"bucket_name":       "test-demo-bucket",
			"force_destroy":     true,
			"enable_versioning": false,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	bucketId := terraform.Output(t, terraformOptions, "bucket_id")
	bucketName := terraform.Output(t, terraformOptions, "bucket_name")

	// Assert outputs
	assert.NotEmpty(t, bucketId, "Bucket ID should not be empty")
	assert.NotEmpty(t, bucketName, "Bucket name should not be empty")
	assert.Contains(t, bucketName, "test-demo-bucket", "Bucket name should contain our prefix")
}

// Test Lambda Module
func TestLambdaModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/lambda",
		Vars: map[string]interface{}{
			"function_name":        "test-lambda-fn",
			"lambda_exec_role_arn": "arn:aws:iam::123456789012:role/lambda-role",
			"handler":              "index.handler",
			"runtime":              "nodejs18.x",
			"timeout":              5,
			"bucket_name":          "test-bucket",
			"config_param_name":    "/test/config",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	functionArn := terraform.Output(t, terraformOptions, "function_arn")
	functionName := terraform.Output(t, terraformOptions, "function_name")

	// Assert outputs
	assert.NotEmpty(t, functionArn, "Function ARN should not be empty")
	assert.NotEmpty(t, functionName, "Function name should not be empty")
	assert.Contains(t, functionArn, "lambda", "Function ARN should contain lambda")
}

// Test API Gateway Module
func TestAPIGatewayModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/api_gateway",
		Vars: map[string]interface{}{
			"api_name":               "test-api",
			"protocol_type":          "HTTP",
			"integration_type":       "AWS_PROXY",
			"lambda_invoke_arn":      "arn:aws:lambda:us-east-1:123456789012:function:test-fn",
			"integration_method":     "POST",
			"payload_format_version": "2.0",
			"route_key":              "GET /",
			"stage_name":             "$default",
			"auto_deploy":            true,
			"lambda_function_name":   "test-fn",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	apiEndpoint := terraform.Output(t, terraformOptions, "api_endpoint")
	apiId := terraform.Output(t, terraformOptions, "api_id")

	// Assert outputs
	assert.NotEmpty(t, apiEndpoint, "API endpoint should not be empty")
	assert.NotEmpty(t, apiId, "API ID should not be empty")
	assert.Contains(t, apiEndpoint, "execute-api", "Endpoint should contain execute-api")
}

// Test SSM Module
func TestSSMModule(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/ssm",
		Vars: map[string]interface{}{
			"parameter_name":        "/test/config",
			"parameter_type":        "String",
			"parameter_value":       "test-value",
			"parameter_description": "Test parameter",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	parameterArn := terraform.Output(t, terraformOptions, "parameter_arn")
	parameterName := terraform.Output(t, terraformOptions, "parameter_name")

	// Assert outputs
	assert.NotEmpty(t, parameterArn, "Parameter ARN should not be empty")
	assert.NotEmpty(t, parameterName, "Parameter name should not be empty")
	assert.Contains(t, parameterArn, "ssm", "Parameter ARN should contain ssm")
}
