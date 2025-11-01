variable "aws_region" {
    description = "Region where you will deploy"
    type = string
    default = "us-east-1"
}

variable "instance_count" {
    description = "No of instances you will deploy"
    type = number
    default = 1
}

variable "instance_type" {
    description = "Type of EC2 instance deployed"
    type = string
    default = "t3.small"
}

variable "ami_id" {
    description = "AMI ID to use to spin up EC2"
    type = string
}

variable "key_pair" {
    description = "AWS Key pair to use"
    type = string
}

variable "instance-prefix" {
    description = "Prefix for instance name"
    type = string
}

variable "vpc_id" {
  description = "VPC ID where instances will be launched"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet IDs for instances (one per instance)"
  type        = map(string)
  
  # Example: { "0" = "subnet-123", "1" = "subnet-456" }
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "iam_instance_profile" {
    description = "IAM Instance profile name"
    type        = string
}

locals {
    mandatory_tag_keys = ["Environment", "Technical Owner", "Name", "AppID", "SysID"]
}
variable "mandatory_tags" {
    description = "Mandatory tags of EC2 instances"
    type        = map(String)

    validation {
        condition = alltrue([for key in local.mandatory_tag_keys : contains(keys(var.mandatory_tags), key)])
        error_message = "Tags must include: ${join(", ", local.mandatory_tag_keys)}."
    }
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
    description = "Type of EBS the root volume should be (gp2, gp3, io1, ...)"
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