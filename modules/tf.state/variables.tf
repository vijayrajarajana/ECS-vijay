variable "bucket_name" {
  description = "tf state S3 bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "tf state DynamoDB table"
  type        = string
}