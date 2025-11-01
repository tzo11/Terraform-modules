# Security Group Module

A flexible and reusable Terraform module to create AWS security groups with custom ingress and egress rules.

## Features

- ✅ Create security groups with custom name and description
- ✅ Define ingress rules using `for_each` for flexibility
- ✅ Define egress rules using `for_each` for flexibility
- ✅ Support CIDR blocks and security group references
- ✅ Easy rule management and modification
- ✅ Custom tagging support
- ✅ Default allow-all egress rule

## Module Structure

```
SecurityGroup/
├── main.tf          # Security group and rule resources
├── variables.tf     # Input variable definitions
├── output.tf        # Output values
└── provider.tf      # AWS provider configuration
```

## Usage

### Basic Example

```hcl
module "web_sg" {
  source = "./SecurityGroup"
  
  aws_region     = "us-east-1"
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
  
  tags = {
    Environment = "production"
    Owner       = "DevOps"
  }
}
```

### With Security Group Reference

```hcl
module "app_sg" {
  source = "./SecurityGroup"
  
  sg_name = "app-security-group"
  vpc_id  = "vpc-12345678"
  
  ingress_rules = {
    "from_web" = {
      protocol    = "tcp"
      from_port   = 8080
      to_port     = 8080
      source      = module.web_sg.security_group_id  # Reference another SG
      description = "Allow traffic from web servers"
    }
  }
  
  egress_rules = {
    "to_db" = {
      protocol       = "tcp"
      from_port      = 5432
      to_port        = 5432
      destination    = "sg-87654321"  # Reference DB security group
      description    = "Allow PostgreSQL to database"
    }
  }
}
```

### Using in terraform.tfvars

```hcl
# terraform.tfvars
aws_region = "us-east-1"
sg_name    = "production-sg"
vpc_id     = "vpc-12345678"

ingress_rules = {
  "http" = {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    source      = "0.0.0.0/0"
    description = "Allow HTTP"
  }
  "https" = {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    source      = "0.0.0.0/0"
    description = "Allow HTTPS"
  }
}

egress_rules = {
  "all_outbound" = {
    protocol       = "-1"
    from_port      = 0
    to_port        = 0
    destination    = "0.0.0.0/0"
    description    = "Allow all outbound"
  }
}
```

## Input Variables

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `aws_region` | string | `us-east-1` | No | AWS region for the security group |
| `sg_name` | string | - | **Yes** | Name of the security group |
| `sg_description` | string | `Security group managed by Terraform` | No | Description of the security group |
| `vpc_id` | string | - | **Yes** | VPC ID where SG will be created |
| `ingress_rules` | map(object) | `{}` | No | Map of ingress (inbound) rules |
| `egress_rules` | map(object) | See default | No | Map of egress (outbound) rules |
| `tags` | map(string) | `{}` | No | Additional tags for the SG |

### Ingress Rule Object

```hcl
{
  protocol    = string  # "tcp", "udp", "icmp", or "-1" for all
  from_port   = number  # Start port (0 for all)
  to_port     = number  # End port (0 for all)
  source      = string  # CIDR block (e.g., "0.0.0.0/0") or SG ID
  description = string  # Rule description
}
```

### Egress Rule Object

```hcl
{
  protocol       = string  # "tcp", "udp", "icmp", or "-1" for all
  from_port      = number
  to_port        = number
  destination    = string  # CIDR block or SG ID
  description    = string
}
```

## Outputs

| Output | Description |
|--------|-------------|
| `security_group_id` | The ID of the security group |
| `security_group_arn` | The ARN of the security group |
| `security_group_name` | The name of the security group |
| `security_group_vpc_id` | The VPC ID of the security group |
| `ingress_rules` | Map of ingress rule IDs |
| `egress_rules` | Map of egress rule IDs |

## Common Examples

### Web Server Security Group

```hcl
module "web_sg" {
  source = "./SecurityGroup"
  
  sg_name = "web-servers"
  vpc_id  = var.vpc_id
  
  ingress_rules = {
    "http" = {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      source      = "0.0.0.0/0"
      description = "HTTP"
    }
    "https" = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      source      = "0.0.0.0/0"
      description = "HTTPS"
    }
    "ssh" = {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      source      = var.admin_cidr
      description = "SSH from admin"
    }
  }
}
```

### Database Security Group

```hcl
module "db_sg" {
  source = "./SecurityGroup"
  
  sg_name = "database"
  vpc_id  = var.vpc_id
  
  ingress_rules = {
    "from_app" = {
      protocol    = "tcp"
      from_port   = 5432
      to_port     = 5432
      source      = module.app_sg.security_group_id
      description = "PostgreSQL from app servers"
    }
  }
  
  egress_rules = {
    "none" = {
      protocol       = "-1"
      from_port      = 0
      to_port        = 0
      destination    = "127.0.0.1/32"  # Deny all outbound
      description    = "Deny all"
    }
  }
}
```

### Allow All Inbound (Development Only)

```hcl
ingress_rules = {
  "all" = {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    source      = "0.0.0.0/0"
    description = "Allow all inbound (DEV ONLY)"
  }
}
```

## Protocol Reference

| Protocol | Value | From Port | To Port |
|----------|-------|-----------|---------|
| TCP | `tcp` | 0-65535 | 0-65535 |
| UDP | `udp` | 0-65535 | 0-65535 |
| ICMP | `icmp` | -1 | -1 |
| All | `-1` | 0 | 0 |

## Source/Destination Types

### CIDR Block
```hcl
source = "0.0.0.0/0"           # Any IPv4
source = "10.0.0.0/8"          # Private network
source = "192.168.1.0/24"      # Specific subnet
```

### Security Group ID
```hcl
source = "sg-12345678"         # Direct SG ID
source = module.app_sg.security_group_id  # Module reference
```

## Prerequisites

- AWS Account with appropriate permissions
- Terraform >= 1.0
- AWS CLI configured with credentials
- VPC already created

## Deploying

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars

# Destroy resources
terraform destroy -var-file=terraform.tfvars
```

## Notes

- Egress rules default to allow all outbound traffic
- Ingress rules are optional (defaults to no inbound traffic)
- Each rule needs a unique key in the map
- Protocol `-1` means all protocols (TCP, UDP, ICMP, etc.)
- Port range 0-0 with protocol `-1` means all ports

## Troubleshooting

### Error: "Invalid security group ID"
**Solution:** Ensure the security group ID exists in the same VPC

### Error: "CIDR block invalid"
**Solution:** Verify CIDR notation (e.g., `10.0.0.0/8`, not `10.0.0.0`)

### Rules not appearing
**Solution:** Check that `ingress_rules` and `egress_rules` are properly formatted maps

## License

This module is provided as-is for educational purposes.
