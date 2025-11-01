# Version History

## [1.0.0] - 2025-11-01

### Initial Release

This is the first stable release of the EC2 Terraform module.

### Features

- ✅ Create multiple EC2 instances using `for_each`
- ✅ Configurable instance type, AMI ID, and instance count
- ✅ VPC and subnet selection
- ✅ Security group management
- ✅ Root volume customization (size, type, encryption)
- ✅ Additional EBS volumes support
- ✅ Mandatory tag validation (Environment, Technical Owner, Name, AppID, SysID)
- ✅ IAM instance profile support
- ✅ Automatic instance naming with prefix
- ✅ Default tagging for all resources

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
- `subnet_id` - Subnet ID for instances
- `security_group_ids` - List of security group IDs
- `iam_instance_profile` - IAM instance profile name
- `mandatory_tags` - Map of required tags

**Optional:**
- `aws_region` - AWS region (default: us-east-1)
- `instance_count` - Number of instances (default: 1)
- `instance_type` - Instance type (default: t3.small)
- `root_volume_size` - Root volume size in GB (default: 20)
- `root_volume_type` - Root volume type (default: gp3)
- `additional_volumes` - Map of additional EBS volumes (default: {})
- `placement_group` - Placement group name (default: null)

### Outputs

- `instance_ids` - Map of EC2 instance IDs
- `private_ips` - Map of private IP addresses
- `instances` - Complete instance details

### Known Limitations

- All instances are created in the same subnet
- All instances have the same instance type (root level)
- Root volume is always encrypted
- Placement group is optional and applies to all instances

### Deployment Example

```hcl
module "ec2_instances" {
  source = "./EC2"
  
  aws_region           = "us-east-1"
  instance_count       = 2
  instance_type        = "t3.small"
  ami_id               = "ami-0c55b159cbfafe1f0"
  instance-prefix      = "my-app"
  vpc_id               = "vpc-12345678"
  subnet_id            = "subnet-87654321"
  security_group_ids   = ["sg-12345678"]
  iam_instance_profile = "EC2-Role"
  
  mandatory_tags = {
    "Environment"      = "production"
    "Technical Owner"  = "DevOps Team"
    "Name"             = "my-ec2"
    "AppID"            = "APP-001"
    "SysID"            = "SYS-001"
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
- Custom tags

### Support

For issues or questions, refer to the `README.md` file for detailed documentation and troubleshooting guide.

---

**Release Date:** November 1, 2025  
**Status:** Stable ✅
