data "aws_route53_zone" "service" {
  name         = var.route_53_hosted_zone_domain_name
  private_zone = false
}

resource "aws_route53_record" "bmw-whiz" {
  zone_id = data.aws_route53_zone.service.zone_id
  name    = var.sub_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}