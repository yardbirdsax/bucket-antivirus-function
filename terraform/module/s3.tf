locals {
  av_s3_bucket_name = var.av_s3_bucket_name == "" ? join("",[data.aws_caller_identity.current.account_id,"-av-definitions"]) : var.av_s3_bucket_name
}
resource "aws_s3_bucket" "av_s3_bucket" {
  bucket = local.av_s3_bucket_name
  acl = "private"
}