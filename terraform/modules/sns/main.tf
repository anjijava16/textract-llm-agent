resource "aws_sns_topic" "textract" {
  name = "textract-job-topic"
}

output "topic_arn" {
  value = aws_sns_topic.textract.arn
}
