resource "aws_s3_bucket" "origin" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "${var.s3_bucket_name}"
    Environment = "${var.environment}"
  }
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.origin.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = aws_s3_bucket.origin.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.origin.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}