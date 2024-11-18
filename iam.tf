# Step 1: Create the IAM Role
resource "aws_iam_role" "lambda_execution_role" {
  name = "ronn4_lambda_execution_role"  # Desired role name

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

# Step 2: Create the IAM Policy (e.g., for logging and step functions)
resource "aws_iam_policy" "lambda_basic_execution_policy" {
  name = "ronn4_lambda_basic_execution_policy"  # Optional: Custom policy name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "states:StartExecution"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Step 3: Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_basic_execution_policy.arn
}
