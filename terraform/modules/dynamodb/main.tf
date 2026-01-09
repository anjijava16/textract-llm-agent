resource "aws_dynamodb_table" "jobs" {
  name         = "textract_jobs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "job_id"

  attribute {
    name = "job_id"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.jobs.name
}
