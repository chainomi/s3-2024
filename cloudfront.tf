resource "aws_cloudfront_origin_access_identity" "origin" {
  comment = "access-identity-${var.s3_bucket_name}"
}

locals {
  s3_origin_id = "${var.s3_bucket_name}"
}



resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    connection_attempts = 3
    connection_timeout = 10

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.environment} ${var.project_name} cloudfront distribution"
  default_root_object = "index.html"


  aliases = ["${var.sub_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }    
  }

  
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = var.domain_cert_arn
    ssl_support_method = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2021"
  }
  
}

resource "aws_cloudfront_function" "basic_auth" {
  name    = "bmw-whiz-basic-auth-function"
  runtime = "cloudfront-js-2.0"
  comment = "BMW Whiz basic-auth-function"
  publish = true
  code    = file("${path.module}/functions/basic_auth.js")
}