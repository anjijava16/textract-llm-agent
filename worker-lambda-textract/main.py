import json
import boto3
import os

textract = boto3.client("textract",region_name="us-east-1")
s3 = boto3.client("s3",region_name="us-east-1")
dynamodb = boto3.resource("dynamodb",region_name="us-east-1")

TABLE_NAME ='textract_jobs' #os.environ["DDB_TABLE"]
RESULT_BUCKET ='mmm-retail' # os.environ["RESULT_BUCKET"]

table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    for record in event["Records"]:
        # Parse SNS envelope from SQS
        sns_envelope = json.loads(record["body"])
        textract_msg = json.loads(sns_envelope["Message"])

        job_id = textract_msg["JobId"]
        status = textract_msg["Status"]

        if status != "SUCCEEDED":
            update_status(job_id, "FAILED")
            continue

        # Idempotency check
        item = table.get_item(Key={"job_id": job_id}).get("Item")
        if item and item.get("status") == "COMPLETED":
            continue

        blocks = []
        next_token = None

        while True:
            params = {"JobId": job_id}
            if next_token:
                params["NextToken"] = next_token

            response = textract.get_document_analysis(**params)
            blocks.extend(response["Blocks"])

            next_token = response.get("NextToken")
            if not next_token:
                break

        # Store result in S3
        result_key = f"results/{job_id}.json"
        s3.put_object(
            Bucket=RESULT_BUCKET,
            Key=result_key,
            Body=json.dumps(blocks)
        )

        # Update DynamoDB
        table.update_item(
            Key={"job_id": job_id},
            UpdateExpression="SET #s=:s, result_s3=:r",
            ExpressionAttributeNames={"#s": "status"},
            ExpressionAttributeValues={
                ":s": "COMPLETED",
                ":r": f"s3://{RESULT_BUCKET}/{result_key}"
            }
        )

def update_status(job_id, status):
    table.update_item(
        Key={"job_id": job_id},
        UpdateExpression="SET #s=:s",
        ExpressionAttributeNames={"#s": "status"},
        ExpressionAttributeValues={":s": status}
    )



# Test event
test_event = {
    "Records": [
        {
            "body": json.dumps({
                "Type": "Notification",
                "MessageId": "11111111-2222-3333-4444-555555555555",
                "TopicArn": "arn:aws:sns:us-east-1:907708980274:textract-job-topic",
                "Message": json.dumps({
                    "JobId": "a8609b2a1a560153d9c8fe9fd634377a4b22d92ba6fade5858bd1907ba6be503",
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


