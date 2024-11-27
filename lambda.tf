# Lambda Function for Code Validation
resource "aws_lambda_function" "validate_code" {
  function_name    = "Ronn4ValidateCode"  # Name of the Lambda function
  role             = aws_iam_role.lambda_execution_role.arn  # Reference the role from iam.tf
  handler          = "validate_code.lambda_handler"  # Entry point of the Lambda function
  runtime          = "python3.9"  # Python runtime version
  filename         = "validate_code.zip"  # The name of the ZIP file containing the code
  source_code_hash = filebase64sha256("validate_code.zip")  # Hash of the ZIP file
}

# Output the ARN of the Lambda function if needed
output "validate_code_lambda_arn" {
  value = aws_lambda_function.validate_code.arn
}
