# Version History

## [1.0.0] - 2025-11-02

### Initial Release

This is the first stable release of the Security Group Terraform module with comprehensive documentation and examples.

### ✨ Features

- ✅ **Flexible Rules**: Define ingress/egress rules using `for_each` for easy management
- ✅ **CIDR & SG References**: Support both IP ranges and cross-security group traffic
- ✅ **Protocol Support**: TCP, UDP, ICMP, or all protocols with port ranges
- ✅ **Auto-Detection**: Automatically detects CIDR blocks vs Security Group IDs
- ✅ **Individual Rule Tagging**: Each rule can be tagged separately
- ✅ **Enterprise Tags**: Custom tagging support with inheritance
- ✅ **Default Egress**: Configurable default allow-all egress rule
- ✅ **GitHub Sourcing**: Remote module sourcing with semantic versioning
- ✅ **Comprehensive Examples**: Multiple use case examples and scenarios

### Module Components

- `provider.tf` - AWS provider configuration (Terraform >= 1.0, AWS provider >= 5.0)
- `variables.tf` - Input variable definitions
- `main.tf` - Security group and rule resources
- `output.tf` - Output values (SG ID, ARN, rules)

### Input Variables

**Mandatory:**
- `sg_name` - Security group name
- `vpc_id` - VPC ID for the security group

**Optional:**
- `aws_region` - AWS region (default: us-east-1)
- `sg_description` - SG description (default: "Security group managed by Terraform")
- `ingress_rules` - Map of inbound rules (default: {})
- `egress_rules` - Map of outbound rules (default: allow all)
- `tags` - Additional tags (default: {})

### Outputs

- `security_group_id` - Security group ID
- `security_group_arn` - Security group ARN
- `security_group_name` - Security group name
- `security_group_vpc_id` - VPC ID
- `ingress_rules` - Map of ingress rule IDs
- `egress_rules` - Map of egress rule IDs

### Key Features

- **for_each based rules** - Easy to manage multiple rules
- **CIDR and SG references** - Support both IP ranges and cross-SG traffic
- **Protocol flexibility** - Support TCP, UDP, ICMP, or all protocols
- **Port ranges** - Define specific ports or port ranges
- **Automatic detection** - Automatically detects CIDR vs SG ID
- **Individual rule tagging** - Each rule can be tagged separately

### Key Improvements

- **Enhanced Documentation**: Comprehensive README with examples and troubleshooting
- **GitHub Sourcing**: Examples use remote GitHub sourcing with versioning
- **Multi-Protocol Examples**: Complete examples for TCP, UDP, ICMP, and all protocols
- **Cross-SG References**: Detailed examples of security group to security group communication
- **Protocol Reference**: Comprehensive protocol and port reference guide
- **Default Egress Override**: Clear documentation on restricting outbound traffic

### Resource Architecture

```
Security Group (aws_security_group)
  ├── Ingress Rules (aws_vpc_security_group_ingress_rule)
  │   ├── HTTP/HTTPS Rules
  │   ├── SSH/RDP Rules
  │   ├── Database Rules
  │   └── Custom Protocol Rules
  │
  └── Egress Rules (aws_vpc_security_group_egress_rule)
      ├── Outbound Web Traffic
      ├── Database Connections
      └── Custom Destinations
```

### Protocol Support

| Protocol | Value | Example |
|----------|-------|---------|
| TCP | `tcp` | Port 80, 443, 22 |
| UDP | `udp` | Port 53, 123 |
| ICMP | `icmp` | Ping traffic |
| All | `-1` | All protocols and ports |

### Common Use Cases

1. **Web Server SG** - HTTP/HTTPS inbound, SSH for management
2. **Database SG** - Specific port from app servers only
3. **Load Balancer SG** - HTTP/HTTPS inbound, backend SG reference
4. **Bastion SG** - SSH inbound from specific IPs
5. **Internal Service SG** - Custom port from other SGs

### Deployment Example

```hcl
module "web_sg" {
  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"
  
  # Basic Configuration
  sg_name        = "web-servers-sg"
  sg_description = "Security group for web servers"
  vpc_id         = "vpc-12345678"
  
  # Ingress Rules (Inbound)
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
    "ssh_admin" = {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      source      = "10.0.0.0/8"
      description = "SSH from internal network"
    }
  }
  
  # Tags
  tags = {
    "Environment" = "production"
    "Team"        = "platform"
    "Service"     = "web-servers"
  }
}
```

### Prerequisites

- Terraform >= 1.0
- AWS provider >= 5.0
- AWS CLI configured with credentials
- Existing VPC where security group will be created
- Valid CIDR blocks or existing security group IDs for references

### Testing

This module has been tested with:
- Terraform 1.5+
- AWS Provider 5.0+
- Multiple ingress and egress rules (up to 50 rules per direction)
- CIDR block references with various network sizes
- Security group cross-references and circular dependencies
- Multi-protocol rules (TCP, UDP, ICMP, all)
- Port ranges and individual port configurations

### Support

For issues or questions, refer to the comprehensive `README.md` file which includes:
- Detailed variable documentation
- Complete usage examples for various scenarios
- Protocol reference and common port examples
- Troubleshooting guide for common issues
- Best practices for security group design
- Reverse rules (ingress from external SG)

### Breaking Changes

None - First release

### Migration Guide

N/A - First release

---

**Release Date:** November 2, 2025  
**Status:** Stable ✅  
**Terraform Version:** >= 1.0  
**AWS Provider Version:** >= 5.0
