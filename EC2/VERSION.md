# Version History

## [1.0.0] - 2025-11-02

### Initial Release

This is the first stable release of the EC2 Terraform module with comprehensive documentation and examples.

### ✨ Features

- ✅ **Multiple EC2 Instances**: Deploy 1-N instances using `for_each`
- ✅ **Multi-Subnet Support**: Deploy instances across different subnets/AZs
- ✅ **Flexible Storage**: Configurable root volume + multiple additional EBS volumes
- ✅ **User Data Support**: Linux (bash) and Windows (PowerShell) initialization scripts
- ✅ **Security**: Security group integration and IAM instance profiles
- ✅ **Enterprise Tags**: Mandatory tag validation (Environment, Technical Owner, Name, AppID, SysID)
- ✅ **Placement Groups**: Optional placement group support for performance optimization
- ✅ **Encryption**: All root volumes encrypted by default
- ✅ **GitHub Sourcing**: Remote module sourcing with semantic versioning
- ✅ **Comprehensive Examples**: Dev, staging, and production examples

### Module Components

- `provider.tf` - AWS provider configuration (Terraform >= 1.0, AWS provider >= 5.0)
- `variables.tf` - Input variable definitions with validation
- `main.tf` - EC2 instance and EBS volume resource definitions
- `output.tf` - Output values (instance IDs, private IPs, instances)

### Input Variables

**Mandatory:**
- `ami_id` - AMI ID for EC2 instances
- `instance-prefix` - Prefix for instance names
- `vpc_id` - VPC ID for instances
- `subnet_ids` - Map of subnet IDs (one per instance)
- `security_group_ids` - List of security group IDs
- `iam_instance_profile` - IAM instance profile name
- `mandatory_tags` - Map of required tags

**Optional:**
- `aws_region` - AWS region (default: us-east-1)
- `instance_count` - Number of instances (default: 1)
- `instance_type` - Instance type (default: t3.small)
- `key_pair` - AWS key pair for SSH access (default: null)
- `root_volume_size` - Root volume size in GB (default: 20)
- `root_volume_type` - Root volume type (default: gp3)
- `placement_group` - Placement group name (default: null)
- `user_data` - User data script content (default: "")
- `user_data_base64` - Base64 encoded user data (default: "")
- `additional_volumes` - Map of additional EBS volumes (default: {})

### Outputs

- `instance_ids` - Map of EC2 instance IDs
- `private_ips` - Map of private IP addresses
- `public_ips` - Map of public IP addresses (if assigned)
- `instances` - Complete instance details (marked sensitive)

### Key Improvements

- **Multi-Subnet Support**: Instances can be deployed across different subnets/AZs
- **User Data Scripts**: Support for both Linux and Windows initialization
- **Enhanced Documentation**: Comprehensive README with examples and troubleshooting
- **GitHub Sourcing**: Examples use remote GitHub sourcing with versioning
- **Key Pair Support**: Optional SSH key pair configuration
- **Flexible Variables**: Better default values and validation

### Deployment Example

```hcl
module "ec2_instances" {
  source = "git@github.com:tzo11/Terraform-modules.git//EC2?ref=ec2-v1.0.0"
  
  # Instance Configuration
  instance_count  = 2
  instance_type   = "t3.medium"
  ami_id          = "ami-0c55b159cbfafe1f0"
  instance-prefix = "web-server"
  key_pair        = "my-keypair"
  
  # Networking
  vpc_id         = "vpc-12345678"
  subnet_ids     = {
    "0" = "subnet-web-1a"
    "1" = "subnet-web-1b"
  }
  security_group_ids = ["sg-web-servers"]
  
  # IAM
  iam_instance_profile = "WebServerRole"
  
  # User Data
  user_data = file("${path.module}/web-server-init.sh")
  
  # Tags
  mandatory_tags = {
    "Environment"      = "production"
    "Technical Owner"  = "Platform Team"
    "Name"             = "web-servers"
    "AppID"            = "WEB-001"
    "SysID"            = "SYS-WEB"
  }
}
```

### Prerequisites

- Terraform >= 1.0
- AWS provider >= 5.0
- AWS CLI configured with credentials
- Existing VPC, Subnet, and Security Group
- Existing IAM Instance Profile
- Valid AMI ID for target region

### Testing

This module has been tested with:
- Terraform 1.5+
- AWS Provider 5.0+
- Multiple instance deployments (up to 5 instances)
- Additional EBS volumes (up to 3 volumes)
- Multi-subnet deployments
- User data scripts for Linux and Windows
- Tag validation and enforcement

### Support

For issues or questions, refer to the comprehensive `README.md` file which includes:
- Detailed variable documentation
- Complete usage examples
- Troubleshooting guide
- Best practices

---

**Release Date:** November 2, 2025  
**Status:** Stable ✅
