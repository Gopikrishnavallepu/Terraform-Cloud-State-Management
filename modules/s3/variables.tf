variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "demo-zero-cost-bucket"
}

variable "force_destroy" {
  description = "Allow destruction of non-empty bucket"
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}
