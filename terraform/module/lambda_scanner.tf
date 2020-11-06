data "aws_iam_policy_document" "av_function_scanner_policy" {
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
    sid = "s3AntiVirusScan"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging"
    ]
    resources = var.scanned_s3_bucket_arns
  }

  statement {
    sid = "s3AntiVirusDefinitions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging"
    ]
    resources = [join("",[aws_s3_bucket.av_s3_bucket.arn,"/*"])]
  }
}

resource "aws_iam_policy" "av_function_scanner_policy" {
  name = "bucket_av_function_scanner_policy"
  policy = data.aws_iam_policy_document.av_function_scanner_policy.json
}

resource "aws_iam_role" "av_function_scanner_role" { 
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

resource "aws_iam_role_policy_attachment" "av_function_scanner_role_policy" { 
  policy_arn = aws_iam_policy.av_function_scanner_policy.arn
  role = aws_iam_role.av_function_scanner_role.name
}