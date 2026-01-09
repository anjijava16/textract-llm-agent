    aws sqs set-queue-attributes \
        --queue-url https://sqs.us-east-1.amazonaws.com/907708980274/textract-job-queue \
        --attributes '{
            "RedrivePolicy":"{\"maxReceiveCount\":\"5\", \"deadLetterTargetArn\":\"arn:aws:sqs:us-east-1:907708980274:textract-job-dlq\"}"
        }'
