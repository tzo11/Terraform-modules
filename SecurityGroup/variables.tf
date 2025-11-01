variable "aws_region" {
  description = "AWS region where security group will be created"
  type        = string
  default     = "us-east-1"
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "Map of ingress rules"
  type = map(object({
    protocol    = string       # tcp, udp, icmp, or -1 for all
    from_port   = number
    to_port     = number
    source      = string       # CIDR block or security group ID
    description = string
  }))
  default = {}
  
  # Example:
  # {
  #   "http" = {
  #     protocol    = "tcp"
  #     from_port   = 80
  #     to_port     = 80
  #     source      = "0.0.0.0/0"
  #     description = "Allow HTTP"
  #   }
  # }
}

variable "egress_rules" {
  description = "Map of egress rules"
  type = map(object({
    protocol       = string    # tcp, udp, icmp, or -1 for all
    from_port      = number
    to_port        = number
    destination    = string    # CIDR block or security group ID
    description    = string
  }))
  default = {
    "default" = {
      protocol       = "-1"
      from_port      = 0
      to_port        = 0
      destination    = "0.0.0.0/0"
      description    = "Allow all outbound traffic"
    }
  }
  
  # Example:
  # {
  #   "https" = {
  #     protocol       = "tcp"
  #     from_port      = 443
  #     to_port        = 443
  #     destination    = "0.0.0.0/0"
  #     description    = "Allow HTTPS to internet"
  #   }
  # }
}

variable "tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}
