resource "aws_iam_role" "textract_role" {
  name = "TextractSNSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "textract.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "textract_policy" {
  role = aws_iam_role.textract_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sns:Publish"]
        Resource = var.sns_topic_arn
      },
      {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = "${var.upload_bucket_arn}/*"
      }
    ]
  })
}
