variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_pair" {
  description = "AWS Key pair to use"
  type        = string
}

variable "instance-prefix" {
  description = "Prefix for instance names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where instances will be launched"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet IDs for instances (one per instance)"
  type        = map(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM Instance profile name"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root volume type (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "additional_volumes" {
  description = "Additional EBS volumes to attach"
  type = map(object({
    size              = number
    type              = string
    delete_on_termination = bool
    encrypted         = bool
  }))
  default = {}
}

variable "placement_group" {
  description = "Placement group name for instances"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script for EC2 instances (Linux or Windows)"
  type        = string
  default     = ""
}

variable "user_data_base64" {
  description = "Base64 encoded user data script"
  type        = string
  default     = ""
}

variable "mandatory_tags" {
  description = "Mandatory tags for EC2 instances"
  type        = map(string)
}