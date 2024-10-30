#bucket endpoint, cloud front distribution id, cloud front url

output "s3_endpoint" {
    value = aws_s3_bucket.origin.website_endpoint
}

output "cloudfront_endpoint" {
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_ID" {
    value = aws_cloudfront_distribution.s3_distribution.id
}