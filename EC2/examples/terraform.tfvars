# ============================================================================
# EC2 Module - Example Terraform Variables File
# ============================================================================
# This file shows how to configure the EC2 module for deployment
# Copy this file to your root directory and customize values

# AWS Configuration
aws_region = "us-east-1"

# Instance Configuration
instance_count  = 2
instance_type   = "t3.small"
ami_id          = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 in us-east-1
instance-prefix = "my-app"

# Networking Configuration
vpc_id = "vpc-12345678"
subnet_ids = {
  "0" = "subnet-12345678"  # Instance 0 - Subnet A
  "1" = "subnet-87654321"  # Instance 1 - Subnet B
}
security_group_ids = ["sg-12345678"]

# IAM Configuration
iam_instance_profile = "EC2-Role"

# Storage Configuration
root_volume_size = 20
root_volume_type = "gp3"

# Additional EBS Volumes (Optional)
# Leave empty {} if you don't need additional volumes
additional_volumes = {
  "1" = {
    size                  = 100
    type                  = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
  "2" = {
    size                  = 50
    type                  = "gp2"
    delete_on_termination = false
    encrypted             = true
  }
}

# Placement Group (Optional)
# Leave as null if you don't want to use placement groups
placement_group = null
# placement_group = "my-placement-group"  # Uncomment to use

# User Data Script (Optional)
# Load from file instead of inline

# For Linux instances
user_data = file("${path.module}/user_data.sh")

# For Windows instances (uncomment if using Windows AMI)
# user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))

# Mandatory Tags (Required)
# All instances must have these tag keys
mandatory_tags = {
  "Environment"      = "production"
  "Technical Owner"  = "DevOps Team"
  "Name"             = "my-application"
  "AppID"            = "APP-001"
  "SysID"            = "SYS-001"
  
  # Additional tags (optional but recommended)
  "CostCenter"       = "CC-12345"
  "Department"       = "Engineering"
  "Project"          = "WebApp"
  "CreatedBy"        = "Terraform"
}
