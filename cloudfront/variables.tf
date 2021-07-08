variable "main_bucket_domain_name" {
  description = "Name of the main bucket"
  type        = string
  default     = null
}

variable "replica_bucket_domain_name" {
  description = "Name of the replica"
  type        = string
  default     = null
}

variable "cert_arn" {
  description = "ARN of cert"
  type        = string
  default     = null
}
