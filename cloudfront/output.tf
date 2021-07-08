output "cloudfront_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "DNS name of the distibution"
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "Hosted Zone"
}
