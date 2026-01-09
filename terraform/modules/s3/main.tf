resource "aws_s3_bucket" "upload" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "result" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}
output "upload_bucket" {
  value = aws_s3_bucket.upload.bucket
}

output "result_bucket" {
  value = aws_s3_bucket.result.bucket
}
