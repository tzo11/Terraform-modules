# EC2 Module - Examples

This folder contains example configurations for using the EC2 module with tfvars and proper variable passing.

## Files Included

### 1. `terraform.tfvars`
Example variable values showing:
- AWS region configuration
- Instance count and type
- VPC, subnet, and security group setup
- Root volume configuration
- Additional EBS volumes
- Placement group configuration
- User data script setup
- Mandatory tags

### 2. `main.tf`
Module call that passes variables from tfvars to the EC2 module

### 3. `variables.tf`
Variable definitions that receive values from terraform.tfvars and pass to module

### 4. `output.tf`
Exports key outputs from the module (instance IDs, IPs, instance details)

### 5. `backend.tf`
Backend configurations for Terraform state management

### 6. `user_data.sh`
Example initialization script for Linux EC2 instances

### 7. `user_data.ps1`
Example initialization script for Windows EC2 instances

## Quick Start

### Step 1: Copy All Example Files to Root Directory

```bash
cp examples/* .
```

### Step 2: Update terraform.tfvars

Replace placeholder values with your actual values:
```hcl
vpc_id = "vpc-12345678"        # Your actual VPC ID
subnet_ids = {
  "0" = "subnet-12345678"      # Your actual subnet IDs
  "1" = "subnet-87654321"
}
security_group_ids = ["sg-12345678"]  # Your actual security group ID
```

### Step 3: Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars
```

## How It Works

### Data Flow
```
terraform.tfvars (values) → variables.tf (definitions) → main.tf (module call) → EC2 module
```

### Example Flow
1. `terraform.tfvars` provides: `instance_count = 2`
2. `variables.tf` defines: `variable "instance_count" { type = number }`
3. `main.tf` passes: `instance_count = var.instance_count`
4. EC2 module receives: `instance_count = 2`

## Multiple Environments

Create different tfvars files for different environments:

**dev.tfvars:**
```hcl
instance_count = 1
instance_type  = "t3.micro"
mandatory_tags = {
  Environment = "development"
  # ... other tags
}
```

**prod.tfvars:**
```hcl
instance_count = 3
instance_type  = "t3.large"
mandatory_tags = {
  Environment = "production"
  # ... other tags
}
```

Deploy with:
```bash
# Development
terraform apply -var-file=dev.tfvars

# Production
terraform apply -var-file=prod.tfvars
```

## User Data Scripts

### Linux Script Usage
Reference in terraform.tfvars:
```hcl
user_data = file("${path.module}/user_data.sh")
```

### Windows Script Usage
Reference in terraform.tfvars:
```hcl
user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))
```

## Accessing Outputs

After deployment, access the outputs:
```bash
# Get instance IDs
terraform output instance_ids

# Get private IPs
terraform output private_ips

# Get all outputs
terraform output
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
