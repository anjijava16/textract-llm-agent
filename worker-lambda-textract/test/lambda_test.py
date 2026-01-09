import os
import json
from lambda_function import lambda_handler

# Environment variables your lambda expects
os.environ["DDB_TABLE"] = "textract_jobs"
os.environ["RESULT_BUCKET"] = "textract-results-bucket"

# Use boto3 with localstack (optional) or actual AWS
# os.environ["AWS_DEFAULT_REGION"] = "us-east-1"

# Test event
test_event = {
    "Records": [
        {
            "body": json.dumps({
                "Type": "Notification",
                "MessageId": "11111111-2222-3333-4444-555555555555",
                "TopicArn": "arn:aws:sns:us-east-1:123456789012:textract-job-topic",
                "Message": json.dumps({
                    "JobId": "example-job-id-123",
                    "Status": "SUCCEEDED",
                    "API": "StartDocumentAnalysis",
                    "Timestamp": "2026-01-08T10:20:45.321Z"
                })
            })
        }
    ]
}

class Context:
    function_name = "test_lambda"
    memory_limit_in_mb = 128
    invoked_function_arn = "arn:aws:lambda:local:123456:function:test_lambda"
    aws_request_id = "local-request-id"

# Call lambda handler
lambda_handler(test_event, Context())
