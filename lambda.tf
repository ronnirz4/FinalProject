resource "aws_lambda_function" "validate_code" {
  function_name    = "ValidateCode"
  role             = aws_iam_role.step_function_role.arn
  handler          = "validate_code.lambda_handler"
  runtime          = "python3.9"
  filename         = "validate_code.zip"  # Path to the ZIP file
  source_code_hash = filebase64sha256("validate_code.zip")
}
