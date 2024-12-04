provider "aws" {
  region = "us-east-2"  # Replace with your desired region
}

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
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

# IAM role for Step Functions
resource "aws_iam_role" "step_function_role" {
  name               = "step_function_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for Lambda to interact with other AWS services
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Lambda execution policy for Step Functions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "s3:GetObject",
          "logs:*"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda function for validation
resource "aws_lambda_function" "validate_code" {
  function_name = "Ronn4ValidateCode"
  runtime       = "nodejs14.x"  # Update based on your Lambda code's runtime
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 300
  s3_bucket     = "your-code-bucket"  # Replace with your S3 bucket
  s3_key        = "validate_code.zip"  # Path to your Lambda zip file in S3
}

# Lambda function for deployment to staging
resource "aws_lambda_function" "deploy_to_staging" {
  function_name = "Ronn4DeployToStaging"
  runtime       = "nodejs14.x"  # Update based on your Lambda code's runtime
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 300
  s3_bucket     = "your-code-bucket"  # Replace with your S3 bucket
  s3_key        = "deploy_to_staging.zip"  # Path to your Lambda zip file in S3
}

# Lambda function for running tests
resource "aws_lambda_function" "run_tests" {
  function_name = "Ronn4RunTests"
  runtime       = "nodejs14.x"  # Update based on your Lambda code's runtime
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 300
  s3_bucket     = "your-code-bucket"  # Replace with your S3 bucket
  s3_key        = "run_tests.zip"  # Path to your Lambda zip file in S3
}

# Lambda function for deployment to production
resource "aws_lambda_function" "deploy_to_production" {
  function_name = "Ronn4DeployToProduction"
  runtime       = "nodejs14.x"  # Update based on your Lambda code's runtime
  handler       = "index.handler"
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 300
  s3_bucket     = "your-code-bucket"  # Replace with your S3 bucket
  s3_key        = "deploy_to_production.zip"  # Path to your Lambda zip file in S3
}

# Step Functions definition
resource "aws_sfn_state_machine" "deployment_pipeline" {
  name     = "ServerlessAppDeploymentPipeline"
  role_arn = aws_iam_role.step_function_role.arn
  definition = jsonencode({
    Comment: "Pipeline for Serverless Application Deployment",
    StartAt: "ValidateCode",
    States: {
      ValidateCode: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-2:023196572641:function:Ronn4ValidateCode",  # Replace with your Lambda ARN
        Next: "DeployToStaging"
      },
      DeployToStaging: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-2:023196572641:function:Ronn4DeployToStaging",  # Replace with your Lambda ARN
        Next: "RunTests"
      },
      RunTests: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-2:023196572641:function:Ronn4RunTests",  # Replace with your Lambda ARN
        Next: "DeployToProduction"
      },
      DeployToProduction: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-2:023196572641:function:Ronn4DeployToProduction",  # Replace with your Lambda ARN
        End: true
      }
    }
  })
}

# IAM Role Policy Attachment for Step Functions
resource "aws_iam_role_policy_attachment" "step_function_policy_attachment" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsFullAccess"
}
