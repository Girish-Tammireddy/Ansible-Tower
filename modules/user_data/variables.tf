
variable "fqdn" {
  description = "The fully qualified domain name of the load balancer."
  type        = string
}
variable "active_active" {
  default     = true
  description = "A boolean that indicates if the TFE deployment is Active/Active or Standalone."
  type        = bool
}
variable "generated_bastion_key_private" {
  description = "The PEM formatted private data of the SSH key pair associated with the bastion EC2 instance."
  type        = string
}
variable "aws_bucket_bootstrap" {
  description = "The name of the S3 storage bucket which contains TFE bootstrap artifacts."
  type        = string
}
variable "aws_bucket_data" {
  description = "The name of the S3 storage bucket which contains TFE runtime data."
  type        = string
}
variable "aws_region" {
  description = "The region in which the S3 storage bucket which contains TFE runtime data is deployed."
  type        = string
}
variable "tfe_license" {
  description = "The name of the S3 storage bucket object which contains the TFE license."
  type        = string
}
variable "kms_key_arn" {
  description = "The Amazon Resource Name of the KMS key which is used to encrypt S3 storage bucket objects."
  type        = string
}
variable "redis_host" {
  default     = ""
  description = "The IP address of the primary node in the Redis Elasticache replication group."
  type        = string
}
variable "redis_pass" {
  default     = ""
  description = "The password which is required to create connections with the Redis Elasticache replication group."
  type        = string
}
variable "redis_port" {
  default     = ""
  description = "The port number on which the Redis Elasticache replication group accepts connections."
  type        = string
}

variable "redis_use_password_auth" {
  type        = bool
  default     = false
  description = "Determines if the Replicated configuration is aware to use password auth."
}

variable "redis_use_tls" {
  type        = bool
  default     = false
  description = "Determines if the Replicated configuration is aware to use TLS/HTTPS."
}

variable "pg_netloc" {
  description = "The connection endpoint of the PostgreSQL RDS instance in address:port format."
  type        = string
}
variable "pg_dbname" {
  description = "The name of the PostgreSQL RDS instance."
  type        = string
}
variable "pg_user" {
  description = "The name of the main PostgreSQL user."
  type        = string
}
variable "pg_password" {
  description = "The password of the main PostgreSQL user."
  type        = string
}

variable "proxy_ip" {
  description = "The IP address of the HTTP proxy through which TFE traffic will be routed."
  type        = string
}
variable "proxy_cert_bundle_name" {
  type        = string
  description = "(Optional) name of cert bundle stored in S3"
  default     = ""
}
variable "no_proxy" {
  type        = list(string)
  description = "(Optional) List of IP addresses to not proxy"
  default     = []
}
