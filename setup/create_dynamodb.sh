```

(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % aws dynamodb create-table \
    --table-name textract_jobs \
    --attribute-definitions \
        AttributeName=job_id,AttributeType=S \
    --key-schema \
        AttributeName=job_id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --tags Key=Project,Value=TextractPipeline

{
    "TableDescription": {
        "AttributeDefinitions": [
            {
                "AttributeName": "job_id",
                "AttributeType": "S"
            }
        ],
        "TableName": "textract_jobs",
        "KeySchema": [
            {
                "AttributeName": "job_id",
                "KeyType": "HASH"
            }
        ],
        "TableStatus": "CREATING",
        "CreationDateTime": "2026-01-08T22:58:28.559000-05:00",
        "ProvisionedThroughput": {
            "NumberOfDecreasesToday": 0,
            "ReadCapacityUnits": 0,
            "WriteCapacityUnits": 0
        },
        "TableSizeBytes": 0,
        "ItemCount": 0,
        "TableArn": "arn:aws:dynamodb:us-east-1:907708980274:table/textract_jobs",
        "TableId": "4607b160-fa7f-4536-ac89-cab95658da13",
        "BillingModeSummary": {
            "BillingMode": "PAY_PER_REQUEST"
        },
        "DeletionProtectionEnabled": false
    }
}
(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % 

```