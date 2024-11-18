import json


def lambda_handler(event, context):
    # Example code for the Lambda function
    # This will process the event passed to the Lambda function and return a result.
    print("Processing event:", event)

    # Example of a simple validation or processing logic
    if "key" in event:
        return {
            'statusCode': 200,
            'body': json.dumps(f"Valid event with key: {event['key']}")
        }
    else:
        return {
            'statusCode': 400,
            'body': json.dumps("Invalid event, key not found.")
        }
