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
