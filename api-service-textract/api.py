from fastapi import FastAPI, UploadFile, File, HTTPException
import boto3
import uuid
import os
import json
from datetime import datetime
import uvicorn
app = FastAPI()
app.title = "Textract Async API Service"
s3 = boto3.client("s3", region_name="us-east-1")
textract = boto3.client("textract", region_name="us-east-1")
dynamodb = boto3.resource("dynamodb", region_name="us-east-1")

TABLE_NAME = 'textract_jobs' #os.environ["DDB_TABLE"]
UPLOAD_BUCKET = 'mmm-retail' #os.environ["UPLOAD_BUCKET"]
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:907708980274:textract-job-topic' #os.environ["SNS_TOPIC_ARN"]
TEXTRACT_ROLE_ARN ='arn:aws:iam::907708980274:role/TEXTRACT_ROLE_ARN'# os.environ["TEXTRACT_ROLE_ARN"]

table = dynamodb.Table(TABLE_NAME)

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    job_uuid = str(uuid.uuid4())
    s3_key = f"uploads/{job_uuid}/{file.filename}"

    # Upload to S3
    s3.upload_fileobj(file.file, UPLOAD_BUCKET, s3_key)

    # Start Textract async job
    response = textract.start_document_analysis(
        DocumentLocation={
            "S3Object": {
                "Bucket": UPLOAD_BUCKET,
                "Name": s3_key
            }
        },
        FeatureTypes=["FORMS", "TABLES"],
        NotificationChannel={
            "SNSTopicArn": SNS_TOPIC_ARN,
            "RoleArn": TEXTRACT_ROLE_ARN
        }
    )

    job_id = response["JobId"]

    # Save metadata
    table.put_item(
        Item={
            "job_id": job_id,
            "status": "IN_PROGRESS",
            "input_s3": f"s3://{UPLOAD_BUCKET}/{s3_key}",
            "created_at": datetime.utcnow().isoformat()
        }
    )

    return {
        "job_id": job_id,
        "status": "IN_PROGRESS"
    }

@app.get("/result/{job_id}")
def get_result(job_id: str):
    response = table.get_item(Key={"job_id": job_id})
    item = response.get("Item")

    if not item:
        raise HTTPException(status_code=404, detail="Job not found")

    if item["status"] == "IN_PROGRESS":
        return {"job_id": job_id, "status": "IN_PROGRESS"}

    if item["status"] == "FAILED":
        raise HTTPException(status_code=500, detail="Textract failed")

    # COMPLETED
    result_s3 = item["result_s3"]
    bucket, key = result_s3.replace("s3://", "").split("/", 1)

    obj = s3.get_object(Bucket=bucket, Key=key)
    data = json.loads(obj["Body"].read())

    return {
        "job_id": job_id,
        "status": "COMPLETED",
        "data": data
    }

if __name__ == "__main__":
    uvicorn.run(app=app, host="localhost", port=8727)