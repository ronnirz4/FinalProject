resource "aws_lambda_function" "validate_code" {
  function_name    = "ValidateCode"
  role             = aws_iam_role.lambda_execution_role.arn  # Correct reference to the IAM role
  handler          = "validate_code.lambda_handler"  # Ensure this is correct for your Lambda function
  runtime          = "python3.9"
  filename         = "validate_code.zip"  # Path to your ZIP file containing Lambda code
  source_code_hash = filebase64sha256("validate_code.zip")  # Ensures Lambda gets updated on file change
}
