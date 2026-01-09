resource "aws_s3_bucket" "upload" {
  bucket = "${var.project}-upload-${var.env}"
}

resource "aws_s3_bucket" "result" {
  bucket = "${var.project}-result-${var.env}"
}

output "upload_bucket" {
  value = aws_s3_bucket.upload.bucket
}

output "result_bucket" {
  value = aws_s3_bucket.result.bucket
}
