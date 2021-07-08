variable "dns_name" {
  description = "DNS name for cert"
  type        = string
  default     = null
}

variable "cloudfront_endpoint" {
  description = "Endpoint for cloudfront"
  type        = string
  default     = null
}

variable "cloudfront_zone_id" {
  description = "Zone for cloudfront"
  type        = string
  default     = null
}