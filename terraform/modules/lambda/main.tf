resource "aws_lambda_function" "worker" {
  function_name = "textract-worker"
  role          = var.lambda_role_arn
  handler       = "main.lambda_handler"
  runtime       = "python3.11"
  filename      = var.lambda_zip

  environment {
    variables = {
      RESULT_BUCKET = var.result_bucket
      DDB_TABLE     = var.ddb_table
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = var.sqs_arn
  function_name   = aws_lambda_function.worker.arn
}
