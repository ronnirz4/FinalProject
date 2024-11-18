import json
import logging

# Initialize logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")  # Log the entire event for debugging

    # Validate if 'key' exists in the event
    if "key" in event:
        logger.info(f"Validation successful. Key found: {event['key']}")
        return {
            'statusCode': 200,
            'body': json.dumps(f"Valid event with key: {event['key']}")
        }
    else:
        logger.error("Validation failed. Key not found.")
        return {
            'statusCode': 400,
            'body': json.dumps("Invalid event, key not found.")
        }
