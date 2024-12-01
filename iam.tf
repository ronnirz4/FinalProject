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

# Step 4: Create the IAM Role for CodeDeploy Service Role (no changes)
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

# Step 7: Attach permissions to manage load balancers and target groups (no changes)
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

# Step 11: Create the CodeDeploy application for deployment (no changes)
resource "aws_codedeploy_app" "codedeploy_app" {
  name = "ronn4_codedeploy_app"
}

# Step 12: Create the CodeDeploy deployment group (no changes)
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

# Optional: S3 Bucket Deployment permissions for CodeDeploy to read from the bucket (no changes)
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

# Step 13: Attach the S3 bucket policy to CodeDeploy Role (no changes)
resource "aws_iam_role_policy_attachment" "codedeploy_s3_bucket_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_s3_bucket_policy.arn
}

# Step 14: Attach the permission to create deployments in CodeDeploy to the CodeDeploy role (no changes)
resource "aws_iam_policy" "codedeploy_create_deployment_policy" {
  name        = "ronn4_codedeploy_create_deployment_policy"
  description = "Policy to allow creating deployments in CodeDeploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "codedeploy:CreateDeployment"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the new policy to the CodeDeploy service role (no changes)
resource "aws_iam_role_policy_attachment" "codedeploy_create_deployment_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_create_deployment_policy.arn
}

# # Lambda function for deployment to staging (no changes)
resource "aws_lambda_function" "deploy_to_staging" {
  function_name = "Ronn4DeployToStaging"

  role = aws_iam_role.lambda_execution_role.arn  # Attach the role for deployment

  handler = "index.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      DEPLOYMENT_BUCKET = "ronn4-staging-bucket"
    }
  }
}

# # Lambda function for deployment to production (no changes)
resource "aws_lambda_function" "deploy_to_production" {
  function_name = "Ronn4DeployToProduction"

  role = aws_iam_role.lambda_execution_role.arn  # Attach the role for deployment

  handler = "index.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      DEPLOYMENT_BUCKET = "ronn4-production-bucket"
    }
  }
}

# Step 15: Create S3 bucket for production
resource "aws_s3_bucket" "production_bucket" {
  bucket = "ronn4-production-bucket"
}

# Step 16: Create S3 bucket for staging
resource "aws_s3_bucket" "staging_bucket" {
  bucket = "ronn4-staging-bucket"
}

# Step 17: S3 Bucket Policy for Lambda (allow access)
resource "aws_iam_policy" "lambda_s3_access_policy" {
  name = "ronn4_lambda_s3_access_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::ronn4-production-bucket/*"
      },
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::ronn4-staging-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_access_policy.arn
}