import os
import subprocess
import logging
import time

# Define the environment name (production)
ENV_NAME = 'ronn4_production'

# Configure logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def deploy_lambda_to_production():
    """
    Deploy Lambda function to the production environment
    """
    logger.info(f"Deploying Lambda function to {ENV_NAME} environment...")

    try:
        # Run Terraform commands to deploy to production
        subprocess.run(["terraform", "init"], check=True)
        subprocess.run(["terraform", "plan", "-var", f"env_name={ENV_NAME}"], check=True)
        subprocess.run(["terraform", "apply", "-auto-approve", "-var", f"env_name={ENV_NAME}"], check=True)
        logger.info(f"Lambda function deployed to {ENV_NAME}.")
    except subprocess.CalledProcessError as e:
        logger.error(f"Error deploying Lambda function: {e}")
        raise

def deploy_step_function_to_production():
    """
    Deploy AWS Step Function to the production environment
    """
    logger.info(f"Deploying Step Function to {ENV_NAME} environment...")

    try:
        # Run Terraform commands to deploy the Step Function to production
        subprocess.run(["terraform", "init"], check=True)
        subprocess.run(["terraform", "plan", "-var", f"env_name={ENV_NAME}"], check=True)
        subprocess.run(["terraform", "apply", "-auto-approve", "-var", f"env_name={ENV_NAME}"], check=True)
        logger.info(f"Step Function deployed to {ENV_NAME}.")
    except subprocess.CalledProcessError as e:
        logger.error(f"Error deploying Step Function: {e}")
        raise

def check_production_approval():
    """
    Simulate manual approval process before deploying to production.
    This could involve asking for approval through email, Slack, or other methods.
    """
    logger.info("Please approve the deployment to production.")
    # For the purpose of this script, we'll simulate approval with a time delay.
    time.sleep(5)  # Simulating waiting for approval
    logger.info("Deployment approved.")

def notify_on_failure():
    """
    Send a notification if deployment fails (e.g., via email or Slack).
    """
    logger.error("Deployment to production failed.")
    # You can implement a Slack/Email notification here if desired.
    # For example, using an AWS SNS or Slack API.

def deploy_production():
    """
    Deploy Lambda and Step Function to production, with approval and failure handling.
    """
    try:
        # Step 1: Manual Approval Process (optional)
        check_production_approval()

        # Step 2: Deploy resources to production
        deploy_lambda_to_production()
        deploy_step_function_to_production()

        logger.info("Production deployment completed successfully.")
    except Exception as e:
        logger.error(f"Error during production deployment: {e}")
        # Notify failure (e.g., via email, Slack)
        notify_on_failure()

if __name__ == "__main__":
    deploy_production()
