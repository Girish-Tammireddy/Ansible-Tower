variable "default_ami_id" {
  description = "The identity of the AMI which will be used to provision the TFE EC2 instance(s)."
  type        = string
}

variable "userdata_script" {
  description = "A user data script to be executed when launching the TFE EC2 instance(s)."
  type        = string
}

variable "aws_lb" {
  description = <<-EOD
  The identity of the security group attached to the load balancer which will be authorized to communicate with the TFE 
  EC2 instance(s).
  EOD
  type        = string
}

variable "aws_lb_target_group_tfe_tg_443_arn" {
  description = <<-EOD
  The Amazon Resource Name of the load balancer target group for traffic on port 443 which will be backed by the TFE 
  EC2 autoscaling group.
  EOD
  type        = string
}

variable "aws_lb_target_group_tfe_tg_8800_arn" {
  description = <<-EOD
  The Amazon Resource Name of the load balancer target group for traffic on port 8800 which will be backed by the TFE 
  EC2 autoscaling group.
  EOD
  type        = string
}

variable "aws_iam_instance_profile" {
  description = "The name of the IAM instance profile to be associated with the TFE EC2 instance(s)."
  type        = string
}

variable "bastion_sg" {
  description = "The identity of the security group attached to the bastion EC2 instance."
  type        = string
}

variable "bastion_key" {
  description = "The name of the key pair used for SSH access to the bastion EC2 instance."
  type        = string
}

variable "network_id" {
  description = "The identity of the VPC in which the security group attached to the TFE EC2 instance will be delpoyed."
  type        = string
}

variable "network_subnets_private" {
  description = <<-EOD
  A list of the identities of the private subnetworks in which the EC2 autoscaling group will be deployed.
  EOD
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type of TFE EC2 instance(s) to create."
  type        = string
}

variable "active_active" {
  type        = bool
  description = "Flag for active-active configuation: true for active-active, false for standalone"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for TFE instances and bastion host"
}

variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Friendly name prefix used for tagging and naming AWS resources."
}

variable "node_count" {
  type        = number
  description = "The number of nodes you want in your autoscaling group (1 for standalone, 2 for active-active configuration)"
}

variable "common_tags" {
  type        = map(string)
  description = "(Optional) Map of common tags for all taggable AWS resources."
  default     = {}
}

variable "network_private_subnet_cidrs" {
  type        = list(string)
  description = "(Optional) List of private subnet CIDR ranges to create in VPC."
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
}
