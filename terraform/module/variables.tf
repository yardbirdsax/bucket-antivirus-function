variable "av_s3_bucket_name" {
  type = string
  description = "The name of the S3 bucket to create for storing AV definitions."
  default = ""
}

variable "scanned_s3_bucket_arns" {
  type = list(string)
  description = "A list of S3 bucket ARNs that will be scanned by the function."
}
