locals {
    bucket_name         = "cdn-bucket-${random_uuid.this.result}"
    replica_bucket_name = "replica-cdn-bucket-${random_uuid.this.result}"
    main_region         = "eu-central-1"
    replica_region      = "us-east-2"
    domain_name         = "finhoodtest.link"
    acm_region          = "us-east-1"
}

provider "aws" {
  region = local.main_region
}

provider "aws" {
  region = local.replica_region

  alias = "replica"
}

provider "aws" {
  region = local.acm_region

  alias = "acm"
}

resource "random_uuid" "this" {

}

data "aws_iam_policy_document" "policy_bucket" {
    statement {
        principals {
            type        = "*"
            identifiers = ["*"]
        }

        sid = "staticCDN"

        actions = [
            "s3:GetObject",
        ]
        
        resources = [
            "arn:aws:s3:::${local.bucket_name}/*",
        ]
    }
}

data "aws_iam_policy_document" "policy_bucket_replica" {
    statement {
        principals {
            type        = "*"
            identifiers = ["*"]
        }

        sid = "staticCDN"

        actions = [
            "s3:GetObject",
        ]
        
        resources = [
            "arn:aws:s3:::${local.replica_bucket_name}/*",
        ]
    }
}

module "s3-eu" {
    source = "./s3"

    bucket = "${local.bucket_name}"
    policy = data.aws_iam_policy_document.policy_bucket.json
}

module "s3-us" {
    source = "./s3"

    providers = {
        aws = aws.replica
    }

    bucket = "${local.replica_bucket_name}"
    policy = data.aws_iam_policy_document.policy_bucket_replica.json

}

module "cdn-certificate" {
    source = "./cert"

    providers = {
        aws = aws.acm
    }

    dns_name = local.domain_name
}

module "cloudfront-distribution" {
    source = "./cloudfront"

    
    main_bucket_domain_name     = module.s3-eu.bucket_name
    replica_bucket_domain_name  = module.s3-us.bucket_name
    
    cert_arn = module.cdn-certificate.cert_arn

}

module "DNS-name" {
    source = "./dns"

    dns_name            = local.domain_name
    cloudfront_endpoint = module.cloudfront-distribution.cloudfront_name
    cloudfront_zone_id  = module.cloudfront-distribution.hosted_zone_id

}

