data "aws_route53_zone" "this" {
  name         = var.dns_name
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = var.cloudfront_endpoint
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = true
  }
}