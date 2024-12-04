resource "aws_sfn_state_machine" "Ronn4DeploymentPipeline" {
  name     = "Ronn4DeploymentPipeline"
  role_arn = aws_iam_role.lambda_execution_role.arn  # Role for Step Function to execute Lambda

  definition = <<EOF
{
  "Comment": "Pipeline for Serverless Application Deployment",
  "StartAt": "ValidateCode",
  "States": {
    "ValidateCode": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-2:023196572641:function:Ronn4ValidateCode",  # Replace with your Lambda ARN
      "Next": "DeployToStaging",
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "Rollback"
        }
      ]
    },
    "DeployToStaging": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-2:023196572641:function:Ronn4DeployToStaging",  # Replace with your Lambda ARN
      "Next": "RunTests",
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "Rollback"
        }
      ]
    },
    "RunTests": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-2:023196572641:function:Ronn4RunTests",  # Replace with your Lambda ARN
      "Next": "DeployToProduction",
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "Rollback"
        }
      ]
    },
    "DeployToProduction": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-2:023196572641:function:Ronn4DeployToProduction",  # Replace with your Lambda ARN
      "End": true,
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "Rollback"
        }
      ]
    },
    "Rollback": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-2:023196572641:function:Ronn4RollbackDeployment",  # Replace with your Lambda ARN
      "End": true
    }
  }
}
EOF
}
