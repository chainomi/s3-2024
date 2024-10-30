variable "region" {
  description = "AWS region"
}

variable "environment" {
  description = "Name of environment"
}

variable "s3_bucket_name" {
  description = "Name of S3 bucket for origin"
}

variable "index_document" {
    description = "Name of the index page for the website"
}
variable "error_document" {
    description = "Name of the error page for the website"
}

variable "project_name" {
    description = "Name of the project"
}

variable "route_53_hosted_zone_domain_name" {
  description = "hosted zone domain name"
}

variable "sub_domain" {
  description = "Sub-domain for bmw-whiz"
}

variable "domain_cert_arn" {
  description = "ARN of the *.bmwusacm.co wildcard certificate"
}