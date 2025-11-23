data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/../../lambda.zip"

  source {
    content  = file("${path.module}/../../lambda/index.js")
    filename = "index.js"
  }
}

resource "aws_lambda_function" "demo_lambda" {
  function_name    = var.function_name
  role             = var.lambda_exec_role_arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  timeout          = var.timeout

  environment {
    variables = {
      BUCKET_NAME  = var.bucket_name
      CONFIG_PARAM = var.config_param_name
    }
  }
}
