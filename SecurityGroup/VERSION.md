# Version History

## [1.0.0] - 2025-11-01

### Initial Release

This is the first stable release of the Security Group Terraform module.

### Features

- ✅ Create security groups with custom names and descriptions
- ✅ Define ingress (inbound) rules using `for_each`
- ✅ Define egress (outbound) rules using `for_each`
- ✅ Support CIDR block sources/destinations
- ✅ Support security group references (cross-SG traffic)
- ✅ Easy rule management and modification
- ✅ Automatic tagging support
- ✅ Default allow-all egress rule
- ✅ Individual rule tagging

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

### Resource Architecture

```
Security Group (aws_security_group)
  ├── Ingress Rules (aws_vpc_security_group_ingress_rule)
  │   ├── Rule 1
  │   ├── Rule 2
  │   └── Rule N
  │
  └── Egress Rules (aws_vpc_security_group_egress_rule)
      ├── Rule 1
      ├── Rule 2
      └── Rule N
```

### Default Egress Rule

By default, the module includes:
```hcl
"default" = {
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  destination    = "0.0.0.0/0"
  description    = "Allow all outbound traffic"
}
```

Override to restrict outbound traffic.

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

### Testing

This module has been tested with:
- Terraform 1.5+
- AWS Provider 5.0+
- Multiple ingress and egress rules
- CIDR block references
- Security group cross-references

### Known Limitations

- Does not support IPv6 CIDR blocks (easily addable)
- Does not support prefix lists (easily addable)
- Rules use individual resources (not inline)

### Future Enhancements

- IPv6 support
- Prefix list support
- Rule counts validation
- Reverse rules (ingress from external SG)

### Breaking Changes

None - First release

### Migration Guide

N/A - First release

---

**Release Date:** November 1, 2025  
**Status:** Stable ✅  
**Terraform Version:** >= 1.0  
**AWS Provider Version:** >= 5.0
