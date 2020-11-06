provider aws {
  region = "us-east-2"
}

data aws_caller_identity current {}

resource aws_s3_bucket av_bucket {
  bucket = join("",[data.aws_caller_identity.current.account_id,"-av-example"])
  acl = "private"
}

module av_function {
  source = "./module"
  providers = {
    aws = aws
  }
  av_s3_bucket_name = join("",[data.aws_caller_identity.current.account_id,"-av-definitions"])
  scanned_s3_bucket_arns = [
    aws_s3_bucket.av_bucket.arn
  ]
  
}