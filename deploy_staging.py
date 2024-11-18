import subprocess

# Define the environment name (staging)
ENV_NAME = 'ronn4_staging'

def deploy_lambda_to_staging():
    """
    Deploy Lambda function to the staging environment
    """
    print(f"Deploying Lambda function to {ENV_NAME} environment...")

    # Example command to deploy using Terraform (or you can use AWS CLI)
    subprocess.run(["terraform", "init"], check=True)
    subprocess.run(["terraform", "plan", "-var", f"env_name={ENV_NAME}"], check=True)
    subprocess.run(["terraform", "apply", "-auto-approve", "-var", f"env_name={ENV_NAME}"], check=True)

    print(f"Lambda function deployed to {ENV_NAME}.")

def deploy_step_function_to_staging():
    """
    Deploy AWS Step Function to the staging environment
    """
    print(f"Deploying Step Function to {ENV_NAME} environment...")

    # Example command to deploy a Step Function using Terraform or AWS CLI
    subprocess.run(["terraform", "init"], check=True)
    subprocess.run(["terraform", "plan", "-var", f"env_name={ENV_NAME}"], check=True)
    subprocess.run(["terraform", "apply", "-auto-approve", "-var", f"env_name={ENV_NAME}"], check=True)

    print(f"Step Function deployed to {ENV_NAME}.")

def deploy_staging():
    """
    Deploy both Lambda and Step Function to staging environment
    """
    deploy_lambda_to_staging()
    deploy_step_function_to_staging()

if __name__ == "__main__":
    deploy_staging()
