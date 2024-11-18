import json
import unittest
from validate_code import lambda_handler  # Importing lambda_handler from validate_code.py


class TestValidateCode(unittest.TestCase):

    def test_valid_event(self):
        # Test with a valid event containing 'key'
        event = {"key": "some_value"}  # Provide a sample event that includes 'key'
        context = {}  # Mocking the context (you can leave it empty if not needed)

        # Call the lambda_handler function with the event and context
        response = lambda_handler(event, context)

        # Assert the statusCode is 200 (indicating success)
        self.assertEqual(response['statusCode'], 200)

        # Assert that the response body contains a success message
        self.assertIn("Valid event with key", response['body'])

    def test_invalid_event(self):
        # Test with an invalid event (no 'key')
        event = {}  # An empty event, no 'key' included
        context = {}  # Mocking the context (you can leave it empty if not needed)

        # Call the lambda_handler function with the event and context
        response = lambda_handler(event, context)

        # Assert the statusCode is 400 (indicating failure)
        self.assertEqual(response['statusCode'], 400)

        # Assert that the response body contains the failure message
        self.assertIn("Invalid event, key not found", response['body'])


# If this file is run directly, execute the tests
if __name__ == '__main__':
    unittest.main()
