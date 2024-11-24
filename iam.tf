# Step 1: Create the IAM Role for Lambda Execution (no changes)
resource "aws_iam_role" "lambda_execution_role" {
  name = "ronn4_lambda_execution_role"

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

# Step 2: Create the IAM Policy for Lambda Logging and Step Functions (no changes)
resource "aws_iam_policy" "lambda_basic_execution_policy" {
  name = "ronn4_lambda_basic_execution_policy"

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

# Step 3: Attach the IAM Policy for Lambda to the Lambda Execution Role (no changes)
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_basic_execution_policy.arn
}

# Step 4: Create the IAM Role for CodeDeploy Service Role
resource "aws_iam_role" "codedeploy_service_role" {
  name = "ronn4_codedeploy_service_role"

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

# Step 5: Attach the AWSCodeDeployRole Policy to the CodeDeploy Role (no changes)
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

# Step 6: Attach the Step Function Permissions to the CodeDeploy Role (no changes)
resource "aws_iam_policy" "codedeploy_step_function_policy" {
  name        = "ronn4_codedeploy_step_function_policy"
  description = "Policy for CodeDeploy to invoke Step Functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "states:StartExecution"
        Effect   = "Allow"
        Resource = "arn:aws:states:us-east-2:023196572641:stateMachine:ServerlessDeploymentWorkflow" # Replace with your Step Function ARN
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_step_function_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_step_function_policy.arn
}

# Step 7: Attach permissions to manage load balancers and target groups
resource "aws_iam_policy" "codedeploy_load_balancer_policy" {
  name        = "ronn4_codedeploy_load_balancer_policy"
  description = "Policy for CodeDeploy to interact with ELB/ALB and target groups"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_load_balancer_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_load_balancer_policy.arn
}

# Step 8: Attach the CloudWatch Logs Full Access Policy to the CodeDeploy Role (if needed for logging)
resource "aws_iam_role_policy_attachment" "codedeploy_logs_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Step 9: Attach the ECS Role Policy if deploying to ECS via CodeDeploy (no changes)
resource "aws_iam_role_policy_attachment" "ecs_codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# Step 10: Create the S3 bucket deployment for CodeDeploy to store application revisions
resource "aws_s3_bucket_object" "codedeploy_revision" {
  bucket = "ronn4finaproject"  # Your S3 bucket name
  key    = "app-revision.zip"  # The key for your application revision
  source = "path/to/your/app/revision.zip"  # Path to the application revision to upload

  # Optional: Set permissions if required
  acl = "private"
}

# Step 11: Create the CodeDeploy application for deployment
resource "aws_codedeploy_app" "codedeploy_app" {
  name = "ronn4_codedeploy_app"
}

# Step 12: Create the CodeDeploy deployment group
resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name  = "ronn4_deployment_group"
  service_role_arn       = aws_iam_role.codedeploy_service_role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  # Define the load balancer settings to use your ALB
  load_balancer_info {
    elb_info {
      name = "k8s-ronn4jen-releasej-4f195683e1"  # Your load balancer name
    }
  }

  # Additional settings for deployment (e.g., ECS, Lambda, etc.)
  # Depending on the deployment type, specify more settings here.
}

# Optional: S3 Bucket Deployment permissions for CodeDeploy to read from the bucket
resource "aws_iam_policy" "codedeploy_s3_bucket_policy" {
  name        = "ronn4_codedeploy_s3_bucket_policy"
  description = "Allow CodeDeploy to access the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "arn:aws:s3:::ronn4finaproject/*"
      }
    ]
  })
}

# Step 13: Attach the S3 bucket policy to CodeDeploy Role
resource "aws_iam_role_policy_attachment" "codedeploy_s3_bucket_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_s3_bucket_policy.arn
}
