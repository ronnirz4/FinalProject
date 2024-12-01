resource "aws_lambda_function" "validate_code" {
  function_name    = "Ronn4ValidateCode"  # Name of the Lambda function
  role             = aws_iam_role.lambda_execution_role.arn  # Reference the role from iam.tf
  handler          = "validate_code.lambda_handler"  # Entry point of the Lambda function
  runtime          = "python3.9"  # Python runtime version

  # Specify the S3 bucket and key for the Lambda code
  s3_bucket        = "ronn4finaproject"  # The name of the S3 bucket
  s3_key           = "Ronn4ValidateCode"      # The path to the .zip file in the S3 bucket
}

resource "aws_lambda_function" "deploy_to_staging" {
  function_name = "Ronn4DeployToStaging"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  # Specify the S3 bucket and key for the Lambda code
  s3_bucket     = "ronn4-lambda-bucket"  # The name of the S3 bucket
  s3_key        = "staging_lambda_code.zip"  # The path to the .zip file in the S3 bucket

  environment {
    variables = {
      DEPLOYMENT_BUCKET = "ronn4-staging-bucket"
    }
  }
}

resource "aws_lambda_function" "deploy_to_production" {
  function_name = "Ronn4DeployToProduction"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  # Specify the S3 bucket and key for the Lambda code
  s3_bucket     = "ronn4-lambda-bucket"  # The name of the S3 bucket
  s3_key        = "production_lambda_code.zip"  # The path to the .zip file in the S3 bucket

  environment {
    variables = {
      DEPLOYMENT_BUCKET = "ronn4-production-bucket"
    }
  }
}
