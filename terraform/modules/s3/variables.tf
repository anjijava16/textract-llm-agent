variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "versioning" {
  description = "Enable versioning"
  type        = bool
  default     = true
}
