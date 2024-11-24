# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "Ronn4_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda Logs (CloudWatch permissions)
resource "aws_iam_policy" "lambda_logs" {
  name        = "Ronn4_lambda-logs-policy"
  description = "Policy for Lambda to write logs to CloudWatch"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:*",
        Resource = "*"
      }
    ]
  })
}

# Attach the Lambda Logs Policy to the Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_logs_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

# Lambda Function for Code Validation
resource "aws_lambda_function" "validate_code" {
  function_name    = "Ronn4ValidateCode"  # Name of the Lambda function
  role             = aws_iam_role.lambda_execution_role.arn  # Correct IAM role for execution
  handler          = "validate_code.lambda_handler"  # Entry point of the Lambda function (assuming validate_code.py and lambda_handler function)
  runtime          = "python3.9"  # Python runtime version
  filename         = "validate_code.zip"  # The name of the ZIP file containing the code
  source_code_hash = filebase64sha256("validate_code.zip")  # Hash of the ZIP file to trigger deployment on change
}

# If you need additional Lambda functions, like DeployToStaging, RunTests, etc., repeat the above Lambda function block
