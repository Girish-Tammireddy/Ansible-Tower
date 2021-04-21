# Common

variable "ami_id" {
  type        = string
  default     = ""
  description = "AMI ID to use for TFE instances and bastion host"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN to use with load balancer"
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of common tags for all taggable AWS resources."
  default     = {}
}

variable "db_size" {
  type        = string
  default     = "db.m4.xlarge"
  description = "PostgreSQL instance size."
}

variable "postgres_engine_version" {
  type        = string
  default     = "9.6.20"
  description = "PostgreSQL version."
}

variable "domain_name" {
  type        = string
  description = "Domain for creating the Terraform Enterprise subdomain on."
}

variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Friendly name prefix used for tagging and naming AWS resources."
}

variable "instance_type" {
  default     = "m5.xlarge"
  description = "The instance type of EC2 instance(s) to create."
  type        = string
}

variable "network_id" {
  default     = ""
  description = "The identity of the VPC in which resources will be deployed."
  type        = string
}

variable "network_private_subnets" {
  default     = []
  description = "A list of the identities of the private subnetworks in which resources will be deployed."
  type        = list(string)
}

variable "network_public_subnets" {
  default     = []
  description = "A list of the identities of the public subnetworks in which resources will be deployed."
  type        = list(string)
}

variable "node_count" {
  type        = number
  default     = 3
  description = "The number of nodes you want in your autoscaling group (1 for standalone, 3 for active-active configuration)"

  validation {
    condition     = var.node_count <= 5
    error_message = "The node_count value must be less than or equal to 5."
  }
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "SSL policy to use on ALB listener"
}

variable "ansible_subdomain" {
  type        = string
  default     = "ansible"
  description = "Subdomain for accessing the Terraform Enterprise UI."
}

# Secrets Manager
variable "deploy_secretsmanager" {
  type        = bool
  description = "(Optional) Boolean indicating whether to deploy AWS Secrets Manager secret (true) or not (false)."
  default     = false
}

# Load Balancer
variable "load_balancing_scheme" {
  default     = "PRIVATE"
  description = "Load Balancing Scheme. Supported values are: \"PRIVATE\"; \"PRIVATE_TCP\"; \"PUBLIC\"."
  type        = string

  validation {
    condition     = contains(["PRIVATE", "PRIVATE_TCP", "PUBLIC"], var.load_balancing_scheme)
    error_message = "The load_balancer value must be one of: \"PRIVATE\"; \"PRIVATE_TCP\"; \"PUBLIC\"."
  }
}

# Network
variable "deploy_vpc" {
  type        = bool
  description = "(Optional) Boolean indicating whether to deploy a VPC (true) or not (false)."
  default     = true
}

variable "network_cidr" {
  type        = string
  description = "(Optional) CIDR block for VPC."
  default     = "10.0.0.0/16"
}

variable "network_private_subnet_cidrs" {
  type        = list(string)
  description = "(Optional) List of private subnet CIDR ranges to create in VPC."
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
}

variable "network_public_subnet_cidrs" {
  type        = list(string)
  description = "(Optional) List of public subnet CIDR ranges to create in VPC."
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "admin_dashboard_ingress_ranges" {
  type        = list(string)
  description = "(Optional) List of CIDR ranges that are allowed to acces the admin dashboard. Only used for standalone installations."
  default     = ["0.0.0.0/0"]
}


# PROXY SETTINGS

variable "proxy_ip" {
  type        = string
  description = "(Optional) IP address of existing web proxy to route TFE traffic through."
  default     = ""
}

variable "proxy_cert_bundle_name" {
  type        = string
  description = "(Optional) Name for proxy cert bundle in S3."
  default     = ""
}

variable "proxy_cert_bundle_filepath" {
  type        = string
  description = "(Optional) Filepath for proxy cert bundle to copy to S3."
  default     = ""
}

variable "no_proxy" {
  type        = list(string)
  description = "(Optional) List of IP addresses to not proxy"
  default     = []
}

