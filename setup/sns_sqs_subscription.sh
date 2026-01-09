(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % aws sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:907708980274:textract-job-topic \
    --protocol sqs \
    --notification-endpoint arn:aws:sqs:us-east-1:907708980274:textract-job-queue
{
    "SubscriptionArn": "arn:aws:sns:us-east-1:907708980274:textract-job-topic:269aad35-7e27-40b4-94f5-18e037c89071"
}
(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % 