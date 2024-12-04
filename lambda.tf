provider "aws" {
  region = "us-east-2"  # Replace with your desired region
}

resource "aws_lambda_function" "Ronn4ValidateCode" {
  function_name = "Ronn4ValidateCode"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.validateCode"  # Replace with the handler function in your code
  runtime       = "nodejs14.x"          # Adjust runtime based on your Lambda code
  timeout       = 300                   # Timeout in seconds

  # Do not use filename here, as you are uploading manually
  source_code_hash = ""  # Empty because code is uploaded manually
}

resource "aws_lambda_function" "Ronn4DeployToStaging" {
  function_name = "Ronn4DeployToStaging"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.deployToStaging"
  runtime       = "nodejs14.x"
  timeout       = 300

  source_code_hash = ""  # Empty because code is uploaded manually
}

resource "aws_lambda_function" "Ronn4RunTests" {
  function_name = "Ronn4RunTests"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.runTests"
  runtime       = "nodejs14.x"
  timeout       = 300

  source_code_hash = ""  # Empty because code is uploaded manually
}

resource "aws_lambda_function" "Ronn4DeployToProduction" {
  function_name = "Ronn4DeployToProduction"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.deployToProduction"
  runtime       = "nodejs14.x"
  timeout       = 300

  source_code_hash = ""  # Empty because code is uploaded manually
}

# IAM Role for Lambda execution (same as before)
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the necessary permissions to the IAM role (same as before)
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:*",
          "s3:*",  # Example of a service the Lambda might interact with
          "codecommit:GitPull",  # Example of another AWS service the Lambda might need access to
          "ecs:DescribeServices"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}