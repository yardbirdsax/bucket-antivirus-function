data "aws_iam_policy_document" "av_function_update_policy" {
  statement {
    sid = "WriteCloudWatchLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid = "s3GetAndPutWithTagging"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:PutObject",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging"
    ]
    resources = [join("",[aws_s3_bucket.av_s3_bucket.arn,"/*"])]
  }
  statement {
    sid = "s3HeadObject"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [join("",[aws_s3_bucket.av_s3_bucket.arn,"/*"]),aws_s3_bucket.av_s3_bucket.arn]
  }
}

resource "aws_iam_policy" "av_function_update_policy" {
  name = "bucket_av_function_update_policy"
  policy = data.aws_iam_policy_document.av_function_update_policy.json
}

resource "aws_iam_role" "av_function_update_role" { 
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
      }
  ]
}
JSON
}

resource "aws_iam_role_policy_attachment" "av_function_update_role_policy" { 
  policy_arn = aws_iam_policy.av_function_update_policy.arn
  role = aws_iam_role.av_function_update_role.name
}