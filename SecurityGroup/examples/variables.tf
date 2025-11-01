variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "sg_name" {
  description = "Security group name"
  type        = string
}

variable "sg_description" {
  description = "Security group description"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "Map of ingress rules"
  type = map(object({
    protocol    = string
    from_port   = number
    to_port     = number
    source      = string
    description = string
  }))
  default = {}
}

variable "egress_rules" {
  description = "Map of egress rules"
  type = map(object({
    protocol       = string
    from_port      = number
    to_port        = number
    destination    = string
    description    = string
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}