# ============================================================================
# Security Group Module - Example Backend Configuration
# ============================================================================
# Choose one backend configuration and use it

# Option 1: S3 Backend (Recommended for Production)
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "security-group/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Option 2: Local Backend (Development Only)
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }
