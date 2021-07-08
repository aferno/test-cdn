resource "aws_s3_bucket" "this" {
    bucket = var.bucket

    acl = "public-read"

    tags = {
        Purpose = "Test CDN"
        Owner   = "Philip"
    }

}


resource "aws_s3_bucket_policy" "this" {
    bucket = aws_s3_bucket.this.id

    policy = var.policy

}