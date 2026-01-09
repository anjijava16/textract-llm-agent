(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % aws sqs create-queue \
    --queue-name textract-job-queue

{
    "QueueUrl": "https://sqs.us-east-1.amazonaws.com/907708980274/textract-job-queue"
}
(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % aws sqs create-queue --queue-name textract-job-dlq

{
    "QueueUrl": "https://sqs.us-east-1.amazonaws.com/907708980274/textract-job-dlq"
}
(textract-llm-agent) welcome@jaisairams-Laptop textract-llm-agent % aws sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:907708980274:textract-job-topic \
    --protocol sqs \
    --notification-endpoint arn:aws:sqs:us-east-1:907708980274:textract-job-queue
