# EC2 Module - Examples

This folder contains example configurations for using the EC2 module.

## Files Included

### 1. `terraform.tfvars`
**Purpose:** Example variable values for the EC2 module

**What it shows:**
- AWS region configuration
- Instance count and type
- VPC, subnet, and security group setup
- Root volume configuration
- Additional EBS volumes
- Placement group configuration
- User data script setup
- Mandatory tags

**How to use:**
1. Copy to your root directory
2. Update values to match your environment
3. Replace placeholder IDs (vpc-*, subnet-*, sg-*) with real values

### 2. `backend.tf`
**Purpose:** Different backend configurations for Terraform state management

**Options included:**
- **S3 Backend** (Recommended for production)
- **Local Backend** (Development only)
- **Azure Backend**
- **Terraform Cloud**
- **Google Cloud Storage**

**How to use:**
1. Choose the appropriate backend for your use case
2. Copy the relevant section to your root directory as `backend.tf`
3. Replace placeholder values (bucket names, resource groups, etc.)
4. Run `terraform init` to initialize the backend

### 3. `user_data.sh`
**Purpose:** Example initialization script for Linux EC2 instances

**What it does:**
- Updates system packages
- Installs Docker
- Installs Docker Compose
- Installs CloudWatch Agent
- Creates application directory
- Logs output to `/var/log/user-data.log`

**How to use:**
1. Copy to your root directory
2. Customize for your needs (add your scripts, installations, etc.)
3. Reference in `terraform.tfvars`:
   ```hcl
   user_data = file("${path.module}/user_data.sh")
   ```

### 4. `user_data.ps1`
**Purpose:** Example initialization script for Windows EC2 instances

**What it does:**
- Updates Windows patches
- Installs Chocolatey (package manager)
- Installs Docker, Git, VSCode, and utilities
- Configures Windows Firewall
- Enables Remote Desktop
- Creates application directory

**How to use:**
1. Copy to your root directory
2. Customize for your needs
3. Reference in `terraform.tfvars`:
   ```hcl
   user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))
   ```

---

## Quick Start Guide

### Step 1: Prepare Your Environment

```bash
# Clone or download the Terraform module
git clone <repo-url>
cd Terraform
```

### Step 2: Copy Example Files

```bash
# Copy configuration files to root
cp examples/terraform.tfvars .
cp examples/backend.tf .
cp examples/user_data.sh .

# Or for Windows
copy examples\terraform.tfvars .
copy examples\backend.tf .
copy examples\user_data.sh .
```

### Step 3: Create Module Reference

Create `main.tf` in root directory:

```hcl
module "ec2_instances" {
  source = "./EC2"
  
  aws_region           = var.aws_region
  instance_count       = var.instance_count
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  instance-prefix      = var.instance-prefix
  vpc_id               = var.vpc_id
  subnet_ids           = var.subnet_ids
  security_group_ids   = var.security_group_ids
  iam_instance_profile = var.iam_instance_profile
  root_volume_size     = var.root_volume_size
  root_volume_type     = var.root_volume_type
  additional_volumes   = var.additional_volumes
  placement_group      = var.placement_group
  user_data            = var.user_data
  user_data_base64     = var.user_data_base64
  mandatory_tags       = var.mandatory_tags
}
```

### Step 4: Create Variables File

Create `variables.tf` in root directory (pass-through variables):

```hcl
variable "aws_region" {
  type = string
}

variable "instance_count" {
  type = number
}

# ... add other variables ...
```

### Step 5: Customize Configuration

Edit `terraform.tfvars`:
- Replace `vpc-12345678` with your VPC ID
- Replace `subnet-12345678` with your subnet IDs
- Replace `sg-12345678` with your security group ID
- Update tags with your values
- Customize user data scripts

### Step 6: Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars

# Destroy resources (when no longer needed)
terraform destroy -var-file=terraform.tfvars
```

---

## Backend Setup Examples

### S3 Backend Setup

```bash
# Create S3 bucket
aws s3api create-bucket \
  --bucket my-terraform-state-bucket \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket my-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket my-terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

## Common Customizations

### Adding More Packages to Linux User Data

Edit `user_data.sh`:

```bash
# Add after Docker installation
yum install -y nodejs npm
npm install -g pm2
```

### Customizing Windows User Data

Edit `user_data.ps1`:

```powershell
# Add after Chocolatey installation
choco install -y python nodejs sql-server-2019-express
```

### Using Different AMI

Find AMI IDs for your region:

```bash
# Amazon Linux 2
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query 'Images[0].ImageId'

# Ubuntu 20.04
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04*" \
  --query 'Images[0].ImageId'
```

---

## Troubleshooting

### Issue: "Subnet not found"
**Solution:** Verify subnet IDs exist in the specified VPC
```bash
aws ec2 describe-subnets --subnet-ids subnet-12345678
```

### Issue: "Security group not found"
**Solution:** Verify security group exists and is in the same VPC
```bash
aws ec2 describe-security-groups --group-ids sg-12345678
```

### Issue: "IAM instance profile not found"
**Solution:** Create the IAM instance profile
```bash
aws iam create-instance-profile --instance-profile-name EC2-Role
```

### Issue: User data script not executed
**Solution:** Check EC2 instance system log
```bash
aws ec2 get-console-output --instance-id i-12345678
```

---

## Best Practices

1. **Always use backend** - Never store state locally in production
2. **Use remote backend** - S3, Terraform Cloud, or similar
3. **Enable encryption** - Encrypt S3 bucket and state
4. **Use state locking** - Prevent concurrent modifications
5. **Tag all resources** - Use mandatory tags for organization
6. **Test first** - Run `terraform plan` before applying
7. **Review changes** - Always review terraform plan output
8. **Keep user data simple** - Complex scripts can fail
9. **Monitor logs** - Check `/var/log/user-data.log` for issues
10. **Version control** - Store configurations in Git (except tfvars)

---

## Support

For detailed module documentation, see `../README.md` and `../VERSION.md`
