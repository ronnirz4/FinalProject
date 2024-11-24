# Step 1: Create the IAM Role for Lambda Execution
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

# Step 2: Create the IAM Policy for Lambda Logging and Step Functions
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

# Step 3: Attach the IAM Policy for Lambda to the Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name  # Correct role reference
  policy_arn = aws_iam_policy.lambda_basic_execution_policy.arn  # Correct policy ARN reference
}

# Step 4: Create the IAM Role for CodeDeploy Service Role
resource "aws_iam_role" "codedeploy_service_role" {
  name = "ronn4_codedeploy_service_role"  # Desired role name for CodeDeploy

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

# Step 5: Attach the AWSCodeDeployRole Policy to the CodeDeploy Role
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name  # Correct role reference
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"  # Predefined policy for CodeDeploy
}

# Step 6 (Optional): Attach the CloudWatch Logs Full Access Policy to the CodeDeploy Role (if needed for logging)
resource "aws_iam_role_policy_attachment" "codedeploy_logs_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name  # Correct role reference
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"  # Full access to CloudWatch Logs
}

# Step 7 (Optional): Attach the ECS Role Policy if deploying to ECS via CodeDeploy
resource "aws_iam_role_policy_attachment" "ecs_codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name  # Correct role reference
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"  # Required for ECS deployments
}
