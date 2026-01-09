resource "aws_sns_topic" "textract" {
  name = var.topic_name
}

output "topic_arn" {
  value = aws_sns_topic.textract.arn
}
