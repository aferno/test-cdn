locals {
  origin_id_primary = "S3-test-dev-static-main"
  origin_id_replica = "S3-test-dev-static-replica"
  
  origin_id = "Origin-Group-static-CDN"  
}


resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.main_bucket_domain_name
    origin_id   = local.origin_id_primary
  }

  origin {
    domain_name = var.replica_bucket_domain_name
    origin_id   = local.origin_id_replica
  }

  origin_group {
    origin_id = local.origin_id

    failover_criteria {
      status_codes = [403, 404, 500, 502, 503]
    }

    member {
      origin_id = local.origin_id_primary
    }

    member {
      origin_id = local.origin_id_replica
    }
  }

  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All"

  aliases = ["finhoodtest.link"]

  tags = {
    Purpose = "test"
    Owner   = "Philip"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"  
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}