# ============================================================================
# EC2 Module - Example Backend Configuration
# ============================================================================
# This file shows different backend configurations for Terraform state
# Choose the appropriate backend for your use case and copy to root directory

# ============================================================================
# Option 1: S3 Backend (Recommended for Production)
# ============================================================================
# Stores state in AWS S3 with encryption and locking
# Requires:
#   - S3 bucket already created
#   - DynamoDB table for state locking
#   - Appropriate IAM permissions

terraform {
  backend "s3" {
    # S3 bucket to store state
    bucket = "my-terraform-state-bucket"
    
    # Path within bucket
    key = "ec2-module/prod/terraform.tfstate"
    
    # AWS region where bucket exists
    region = "us-east-1"
    
    # Enable encryption at rest
    encrypt = true
    
    # DynamoDB table for state locking (prevents concurrent modifications)
    dynamodb_table = "terraform-state-lock"
    
    # Enable version control
    versioning = true
  }
}

# ============================================================================
# Option 2: Local Backend (Development Only)
# ============================================================================
# Stores state locally - NOT recommended for production
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

# ============================================================================
# Option 3: Azure Backend
# ============================================================================
# Stores state in Azure Blob Storage
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "my-resource-group"
#     storage_account_name = "mystorageaccount"
#     container_name       = "tfstate"
#     key                  = "prod.terraform.tfstate"
#   }
# }

# ============================================================================
# Option 4: Terraform Cloud Backend
# ============================================================================
# Stores state in Terraform Cloud (HashiCorp hosted)
# terraform {
#   cloud {
#     organization = "my-organization"
#     
#     workspaces {
#       name = "ec2-module-prod"
#     }
#   }
# }

# ============================================================================
# Option 5: Google Cloud Storage Backend
# ============================================================================
# Stores state in GCS
# terraform {
#   backend "gcs" {
#     bucket = "my-terraform-state"
#     prefix = "ec2-module/prod"
#   }
# }

# ============================================================================
# Backend Setup Instructions
# ============================================================================

# Step 1: Create S3 Bucket (if using S3 backend)
# aws s3api create-bucket \
#   --bucket my-terraform-state-bucket \
#   --region us-east-1 \
#   --create-bucket-configuration LocationConstraint=us-east-1

# Step 2: Enable Versioning
# aws s3api put-bucket-versioning \
#   --bucket my-terraform-state-bucket \
#   --versioning-configuration Status=Enabled

# Step 3: Enable Encryption
# aws s3api put-bucket-encryption \
#   --bucket my-terraform-state-bucket \
#   --server-side-encryption-configuration '{
#     "Rules": [{
#       "ApplyServerSideEncryptionByDefault": {
#         "SSEAlgorithm": "AES256"
#       }
#     }]
#   }'

# Step 4: Create DynamoDB Table for Locking
# aws dynamodb create-table \
#   --table-name terraform-state-lock \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST

# Step 5: Block Public Access
# aws s3api put-public-access-block \
#   --bucket my-terraform-state-bucket \
#   --public-access-block-configuration \
#   "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
