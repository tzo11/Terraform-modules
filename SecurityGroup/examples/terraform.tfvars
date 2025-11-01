# ============================================================================
# Security Group Module - Example Terraform Variables File
# ============================================================================

aws_region = "us-east-1"

sg_name        = "web-security-group"
sg_description = "Security group for web servers"
vpc_id         = "vpc-12345678"

ingress_rules = {
  "http" = {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    source      = "0.0.0.0/0"
    description = "Allow HTTP from anywhere"
  }
  
  "https" = {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    source      = "0.0.0.0/0"
    description = "Allow HTTPS from anywhere"
  }
  
  "ssh" = {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    source      = "10.0.0.0/8"
    description = "Allow SSH from internal network"
  }
}

egress_rules = {
  "all_outbound" = {
    protocol       = "-1"
    from_port      = 0
    to_port        = 0
    destination    = "0.0.0.0/0"
    description    = "Allow all outbound traffic"
  }
}

tags = {
  Environment = "production"
  Owner       = "DevOps"
  Team        = "Infrastructure"
}
