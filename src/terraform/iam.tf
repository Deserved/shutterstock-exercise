data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy_document_ii" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      format("%s/%s", aws_s3_bucket.dataset_storage.arn, aws_s3_bucket_object.dataset_uploader.key)

    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "lambda" {

  name = format("lambda-%s-service", var.service)
  description = format("IAM Role for %s lambda service", var.service)
  assume_role_policy = data.aws_iam_policy_document.lambda_policy_document.json

  force_detach_policies = true

  tags = {
    Name = format("IAM Role for %s Service lambda service", var.service)
  }
}

resource "aws_iam_role_policy" "lambda" {
  name  = format("lambda-%s-service", var.service)
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_policy_document_ii.json
}