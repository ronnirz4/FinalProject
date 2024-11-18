provider "aws" {
  region = "us-east-2" # Change to your desired region
}

# IAM Role for Step Functions
resource "aws_iam_role" "step_function_role" {
  name = "step_function_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policies to Step Functions Role
resource "aws_iam_role_policy" "step_function_policy" {
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction",
          "logs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# Step Function Definition
data "aws_iam_policy_document" "step_function" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"] # Replace with ARNs of your Lambda functions
  }
}

# Define State Machine
resource "aws_sfn_state_machine" "pipeline_workflow" {
  name     = "ServerlessDeploymentWorkflow"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    Comment: "Pipeline for Serverless Application Deployment",
    StartAt: "ValidateCode",
    States: {
      ValidateCode: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-1:123456789012:function:ValidateCode", # Replace with your Lambda ARN
        Next: "DeployToStaging"
      },
      DeployToStaging: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-1:123456789012:function:DeployToStaging", # Replace with your Lambda ARN
        Next: "RunTests"
      },
      RunTests: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-1:123456789012:function:RunTests", # Replace with your Lambda ARN
        Next: "DeployToProduction"
      },
      DeployToProduction: {
        Type: "Task",
        Resource: "arn:aws:lambda:us-east-1:123456789012:function:DeployToProduction", # Replace with your Lambda ARN
        End: true
      }
    }
  })
}

# Outputs
output "step_function_arn" {
  value = aws_sfn_state_machine.pipeline_workflow.arn
  description = "ARN of the Step Function State Machine"
}
