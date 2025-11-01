# Security Group Module# Security Group Module



A comprehensive and flexible Terraform module to create **AWS Security Groups** with advanced rule management, cross-security group references, and enterprise-grade features.A flexible and reusable Terraform module to create AWS security groups with custom ingress and egress rules.



## 🚀 Features## Features



- ✅ **Flexible Rules**: Define ingress/egress rules using `for_each` for easy management- ✅ Create security groups with custom name and description

- ✅ **CIDR & SG References**: Support both IP ranges and cross-security group traffic- ✅ Define ingress rules using `for_each` for flexibility

- ✅ **Protocol Support**: TCP, UDP, ICMP, or all protocols with port ranges- ✅ Define egress rules using `for_each` for flexibility

- ✅ **Auto-Detection**: Automatically detects CIDR blocks vs Security Group IDs- ✅ Support CIDR blocks and security group references

- ✅ **Individual Rule Tagging**: Each rule can be tagged separately- ✅ Easy rule management and modification

- ✅ **Enterprise Tags**: Custom tagging support with inheritance- ✅ Custom tagging support

- ✅ **Default Egress**: Configurable default allow-all egress rule- ✅ Default allow-all egress rule

- ✅ **Version Controlled**: GitHub sourced with semantic versioning

## Module Structure

## 📁 Module Structure

```

```SecurityGroup/

SecurityGroup/├── main.tf          # Security group and rule resources

├── main.tf           # Security group and rule resources├── variables.tf     # Input variable definitions

├── variables.tf      # Input variable definitions with validation├── output.tf        # Output values

├── output.tf         # Output values (IDs, ARNs, rule details)└── provider.tf      # AWS provider configuration

├── provider.tf       # AWS provider configuration```

├── VERSION.md        # Version history and changelog

├── README.md         # This documentation## Usage

└── examples/         # Usage examples and configurations

    ├── main.tf### Basic Example

    ├── variables.tf

    ├── output.tf```hcl

    ├── terraform.tfvarsmodule "web_sg" {

    ├── backend.tf  source = "./SecurityGroup"

    └── README.md  

```  aws_region     = "us-east-1"

  sg_name        = "web-security-group"

## 🔧 Quick Start  sg_description = "Security group for web servers"

  vpc_id         = "vpc-12345678"

### 1. Source the Module  

  ingress_rules = {

Choose your preferred sourcing method:    "http" = {

      protocol    = "tcp"

#### Option A: GitHub (Recommended for Production)      from_port   = 80

```hcl      to_port     = 80

module "web_security_group" {      source      = "0.0.0.0/0"

  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"      description = "Allow HTTP from anywhere"

      }

  # Required variables    "https" = {

  sg_name        = "web-security-group"      protocol    = "tcp"

  vpc_id         = "vpc-12345678"      from_port   = 443

        to_port     = 443

  # Optional but recommended      source      = "0.0.0.0/0"

  sg_description = "Security group for web servers"      description = "Allow HTTPS from anywhere"

      }

  ingress_rules = {    "ssh" = {

    "http" = {      protocol    = "tcp"

      protocol    = "tcp"      from_port   = 22

      from_port   = 80      to_port     = 22

      to_port     = 80      source      = "10.0.0.0/8"

      source      = "0.0.0.0/0"      description = "Allow SSH from internal network"

      description = "Allow HTTP from anywhere"    }

    }  }

    "https" = {  

      protocol    = "tcp"  tags = {

      from_port   = 443    Environment = "production"

      to_port     = 443    Owner       = "DevOps"

      source      = "0.0.0.0/0"  }

      description = "Allow HTTPS from anywhere"}

    }```

  }

}### With Security Group Reference

```

```hcl

#### Option B: Local Path (Development)module "app_sg" {

```hcl  source = "./SecurityGroup"

module "web_security_group" {  

  source = "./SecurityGroup"  sg_name = "app-security-group"

    vpc_id  = "vpc-12345678"

  # Same variables as above...  

}  ingress_rules = {

```    "from_web" = {

      protocol    = "tcp"

### 2. Copy Examples and Customize      from_port   = 8080

      to_port     = 8080

```bash      source      = module.web_sg.security_group_id  # Reference another SG

# Copy example files to your project root      description = "Allow traffic from web servers"

cp SecurityGroup/examples/* .    }

  }

# Edit terraform.tfvars with your values  

# Deploy  egress_rules = {

terraform init    "to_db" = {

terraform plan -var-file=terraform.tfvars      protocol       = "tcp"

terraform apply -var-file=terraform.tfvars      from_port      = 5432

```      to_port        = 5432

      destination    = "sg-87654321"  # Reference DB security group

## 📋 Input Variables      description    = "Allow PostgreSQL to database"

    }

### 🔴 MANDATORY Variables (Must be provided)  }

}

| Variable | Type | Description | Example |```

|----------|------|-------------|---------|

| **`sg_name`** | `string` | Security group name | `"web-security-group"` |### Using in terraform.tfvars

| **`vpc_id`** | `string` | VPC ID for the security group | `"vpc-12345678"` |

```hcl

### 🟡 OPTIONAL Variables (Have defaults)# terraform.tfvars

aws_region = "us-east-1"

| Variable | Type | Default | Description |sg_name    = "production-sg"

|----------|------|---------|-------------|vpc_id     = "vpc-12345678"

| `aws_region` | `string` | `"us-east-1"` | AWS region for deployment |

| `sg_description` | `string` | `"Security group managed by Terraform"` | Security group description |ingress_rules = {

| `ingress_rules` | `map(object)` | `{}` | Map of inbound rules (see below) |  "http" = {

| `egress_rules` | `map(object)` | Default allow-all | Map of outbound rules (see below) |    protocol    = "tcp"

| `tags` | `map(string)` | `{}` | Additional tags for all resources |    from_port   = 80

    to_port     = 80

### 🔧 Rule Configuration Objects    source      = "0.0.0.0/0"

    description = "Allow HTTP"

#### Ingress Rules Structure  }

```hcl  "https" = {

ingress_rules = {    protocol    = "tcp"

  "rule_name" = {    from_port   = 443

    protocol    = "tcp"              # Protocol: tcp, udp, icmp, -1 (all)    to_port     = 443

    from_port   = 80                 # Starting port number    source      = "0.0.0.0/0"

    to_port     = 80                 # Ending port number    description = "Allow HTTPS"

    source      = "0.0.0.0/0"       # CIDR block OR security group ID  }

    description = "Rule description" # Human-readable description}

  }

}egress_rules = {

```  "all_outbound" = {

    protocol       = "-1"

#### Egress Rules Structure    from_port      = 0

```hcl    to_port        = 0

egress_rules = {    destination    = "0.0.0.0/0"

  "rule_name" = {    description    = "Allow all outbound"

    protocol    = "tcp"              # Protocol: tcp, udp, icmp, -1 (all)  }

    from_port   = 443                # Starting port number}

    to_port     = 443                # Ending port number```

    destination = "0.0.0.0/0"       # CIDR block OR security group ID

    description = "Rule description" # Human-readable description## Input Variables

  }

}| Variable | Type | Default | Required | Description |

```|----------|------|---------|----------|-------------|

| `aws_region` | string | `us-east-1` | No | AWS region for the security group |

### 🎯 Source/Destination Auto-Detection| `sg_name` | string | - | **Yes** | Name of the security group |

| `sg_description` | string | `Security group managed by Terraform` | No | Description of the security group |

The module automatically detects whether a source/destination is:| `vpc_id` | string | - | **Yes** | VPC ID where SG will be created |

- **CIDR Block**: `"10.0.0.0/8"`, `"192.168.1.0/24"`, `"0.0.0.0/0"`| `ingress_rules` | map(object) | `{}` | No | Map of ingress (inbound) rules |

- **Security Group ID**: `"sg-12345678"`, `"sg-abcdef12"`| `egress_rules` | map(object) | See default | No | Map of egress (outbound) rules |

| `tags` | map(string) | `{}` | No | Additional tags for the SG |

```hcl

ingress_rules = {### Ingress Rule Object

  "from_cidr" = {

    protocol    = "tcp"```hcl

    from_port   = 22{

    to_port     = 22  protocol    = string  # "tcp", "udp", "icmp", or "-1" for all

    source      = "10.0.0.0/8"      # CIDR block  from_port   = number  # Start port (0 for all)

    description = "SSH from internal network"  to_port     = number  # End port (0 for all)

  }  source      = string  # CIDR block (e.g., "0.0.0.0/0") or SG ID

  "from_sg" = {  description = string  # Rule description

    protocol    = "tcp"}

    from_port   = 3306```

    to_port     = 3306

    source      = "sg-12345678"     # Security Group ID### Egress Rule Object

    description = "MySQL from app servers"

  }```hcl

}{

```  protocol       = string  # "tcp", "udp", "icmp", or "-1" for all

  from_port      = number

## 📤 Outputs  to_port        = number

  destination    = string  # CIDR block or SG ID

| Output | Type | Description |  description    = string

|--------|------|-------------|}

| `security_group_id` | `string` | Security group ID |```

| `security_group_arn` | `string` | Security group ARN |

| `security_group_name` | `string` | Security group name |## Outputs

| `security_group_vpc_id` | `string` | VPC ID where SG is created |

| `ingress_rules` | `map(string)` | Map of ingress rule IDs || Output | Description |

| `egress_rules` | `map(string)` | Map of egress rule IDs ||--------|-------------|

| `security_group_id` | The ID of the security group |

### Using Outputs| `security_group_arn` | The ARN of the security group |

| `security_group_name` | The name of the security group |

```hcl| `security_group_vpc_id` | The VPC ID of the security group |

# Use SG ID in other modules| `ingress_rules` | Map of ingress rule IDs |

module "ec2_instances" {| `egress_rules` | Map of egress rule IDs |

  source             = "./EC2"

  security_group_ids = [module.web_security_group.security_group_id]## Common Examples

  # ... other variables

}### Web Server Security Group



# Reference in ALB```hcl

resource "aws_lb_target_group" "web" {module "web_sg" {

  # ... other config  source = "./SecurityGroup"

  vpc_id = module.web_security_group.security_group_vpc_id  

}  sg_name = "web-servers"

```  vpc_id  = var.vpc_id

  

## 💻 Complete Usage Examples  ingress_rules = {

    "http" = {

### Example 1: Web Server Security Group      protocol    = "tcp"

      from_port   = 80

```hcl      to_port     = 80

module "web_sg" {      source      = "0.0.0.0/0"

  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"      description = "HTTP"

      }

  # Basic Configuration    "https" = {

  sg_name        = "web-servers-sg"      protocol    = "tcp"

  sg_description = "Security group for web servers"      from_port   = 443

  vpc_id         = "vpc-12345678"      to_port     = 443

        source      = "0.0.0.0/0"

  # Ingress Rules (Inbound)      description = "HTTPS"

  ingress_rules = {    }

    "http" = {    "ssh" = {

      protocol    = "tcp"      protocol    = "tcp"

      from_port   = 80      from_port   = 22

      to_port     = 80      to_port     = 22

      source      = "0.0.0.0/0"      source      = var.admin_cidr

      description = "Allow HTTP from anywhere"      description = "SSH from admin"

    }    }

    "https" = {  }

      protocol    = "tcp"}

      from_port   = 443```

      to_port     = 443

      source      = "0.0.0.0/0"### Database Security Group

      description = "Allow HTTPS from anywhere"

    }```hcl

    "ssh_admin" = {module "db_sg" {

      protocol    = "tcp"  source = "./SecurityGroup"

      from_port   = 22  

      to_port     = 22  sg_name = "database"

      source      = "10.0.0.0/8"  vpc_id  = var.vpc_id

      description = "SSH from internal network"  

    }  ingress_rules = {

  }    "from_app" = {

        protocol    = "tcp"

  # Egress Rules (Outbound) - Override default      from_port   = 5432

  egress_rules = {      to_port     = 5432

    "https_out" = {      source      = module.app_sg.security_group_id

      protocol    = "tcp"      description = "PostgreSQL from app servers"

      from_port   = 443    }

      to_port     = 443  }

      destination = "0.0.0.0/0"  

      description = "HTTPS for package updates"  egress_rules = {

    }    "none" = {

    "http_out" = {      protocol       = "-1"

      protocol    = "tcp"      from_port      = 0

      from_port   = 80      to_port        = 0

      to_port     = 80      destination    = "127.0.0.1/32"  # Deny all outbound

      destination = "0.0.0.0/0"      description    = "Deny all"

      description = "HTTP for package updates"    }

    }  }

  }}

  ```

  # Tags

  tags = {### Allow All Inbound (Development Only)

    "Environment" = "production"

    "Team"        = "platform"```hcl

    "Service"     = "web-servers"ingress_rules = {

  }  "all" = {

}    protocol    = "-1"

```    from_port   = 0

    to_port     = 0

### Example 2: Database Security Group with Cross-SG References    source      = "0.0.0.0/0"

    description = "Allow all inbound (DEV ONLY)"

```hcl  }

module "db_sg" {}

  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"```

  

  # Basic Configuration## Protocol Reference

  sg_name        = "database-sg"

  sg_description = "Security group for database servers"| Protocol | Value | From Port | To Port |

  vpc_id         = "vpc-12345678"|----------|-------|-----------|---------|

  | TCP | `tcp` | 0-65535 | 0-65535 |

  # Ingress Rules (Inbound) - Only from app servers| UDP | `udp` | 0-65535 | 0-65535 |

  ingress_rules = {| ICMP | `icmp` | -1 | -1 |

    "mysql_from_app" = {| All | `-1` | 0 | 0 |

      protocol    = "tcp"

      from_port   = 3306## Source/Destination Types

      to_port     = 3306

      source      = module.app_sg.security_group_id  # Reference another SG### CIDR Block

      description = "MySQL from application servers"```hcl

    }source = "0.0.0.0/0"           # Any IPv4

    "postgres_from_app" = {source = "10.0.0.0/8"          # Private network

      protocol    = "tcp"source = "192.168.1.0/24"      # Specific subnet

      from_port   = 5432```

      to_port     = 5432

      source      = module.app_sg.security_group_id### Security Group ID

      description = "PostgreSQL from application servers"```hcl

    }source = "sg-12345678"         # Direct SG ID

    "ssh_admin" = {source = module.app_sg.security_group_id  # Module reference

      protocol    = "tcp"```

      from_port   = 22

      to_port     = 22## Prerequisites

      source      = "10.0.0.0/16"

      description = "SSH from admin network"- AWS Account with appropriate permissions

    }- Terraform >= 1.0

  }- AWS CLI configured with credentials

  - VPC already created

  # Egress Rules - Restricted outbound

  egress_rules = {## Deploying

    "https_updates" = {

      protocol    = "tcp"```bash

      from_port   = 443# Initialize Terraform

      to_port     = 443terraform init

      destination = "0.0.0.0/0"

      description = "HTTPS for security updates"# Plan the deployment

    }terraform plan -var-file=terraform.tfvars

    "dns" = {

      protocol    = "udp"# Apply the configuration

      from_port   = 53terraform apply -var-file=terraform.tfvars

      to_port     = 53

      destination = "0.0.0.0/0"# Destroy resources

      description = "DNS resolution"terraform destroy -var-file=terraform.tfvars

    }```

  }

  ## Notes

  tags = {

    "Environment" = "production"- Egress rules default to allow all outbound traffic

    "Team"        = "database"- Ingress rules are optional (defaults to no inbound traffic)

    "Service"     = "mysql-cluster"- Each rule needs a unique key in the map

    "Backup"      = "daily"- Protocol `-1` means all protocols (TCP, UDP, ICMP, etc.)

  }- Port range 0-0 with protocol `-1` means all ports

}

```## Troubleshooting



### Example 3: Load Balancer Security Group### Error: "Invalid security group ID"

**Solution:** Ensure the security group ID exists in the same VPC

```hcl

module "alb_sg" {### Error: "CIDR block invalid"

  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"**Solution:** Verify CIDR notation (e.g., `10.0.0.0/8`, not `10.0.0.0`)

  

  sg_name        = "alb-security-group"### Rules not appearing

  sg_description = "Security group for Application Load Balancer"**Solution:** Check that `ingress_rules` and `egress_rules` are properly formatted maps

  vpc_id         = "vpc-12345678"

  ## License

  # Public-facing ingress

  ingress_rules = {This module is provided as-is for educational purposes.

    "http_public" = {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      source      = "0.0.0.0/0"
      description = "HTTP from internet"
    }
    "https_public" = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      source      = "0.0.0.0/0"
      description = "HTTPS from internet"
    }
  }
  
  # Egress to target instances
  egress_rules = {
    "to_web_servers" = {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      destination = module.web_sg.security_group_id
      description = "Forward to web servers"
    }
    "health_checks" = {
      protocol    = "tcp"
      from_port   = 8080
      to_port     = 8080
      destination = module.web_sg.security_group_id
      description = "Health check to web servers"
    }
  }
  
  tags = {
    "Environment" = "production"
    "Component"   = "load-balancer"
    "Public"      = "true"
  }
}
```

### Example 4: Multi-Protocol Rules

```hcl
module "multi_protocol_sg" {
  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"
  
  sg_name        = "multi-service-sg"
  sg_description = "Security group with multiple protocols"
  vpc_id         = "vpc-12345678"
  
  ingress_rules = {
    # TCP Rules
    "ssh" = {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      source      = "10.0.0.0/8"
      description = "SSH access"
    }
    "web_range" = {
      protocol    = "tcp"
      from_port   = 8000
      to_port     = 8999
      source      = "0.0.0.0/0"
      description = "Web services port range"
    }
    
    # UDP Rules
    "dns" = {
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      source      = "10.0.0.0/8"
      description = "DNS queries"
    }
    "ntp" = {
      protocol    = "udp"
      from_port   = 123
      to_port     = 123
      source      = "0.0.0.0/0"
      description = "NTP time synchronization"
    }
    
    # ICMP Rules
    "ping" = {
      protocol    = "icmp"
      from_port   = -1
      to_port     = -1
      source      = "10.0.0.0/8"
      description = "ICMP ping from internal"
    }
    
    # All Protocols
    "all_internal" = {
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      source      = "192.168.0.0/16"
      description = "All traffic from private network"
    }
  }
}
```

## 🔍 Protocol Reference

### Supported Protocols

| Protocol | Value | Port Behavior | Example Use Cases |
|----------|-------|---------------|-------------------|
| **TCP** | `"tcp"` | Specify from_port and to_port | HTTP (80), HTTPS (443), SSH (22), MySQL (3306) |
| **UDP** | `"udp"` | Specify from_port and to_port | DNS (53), NTP (123), DHCP (67/68) |
| **ICMP** | `"icmp"` | Use -1 for both ports | Ping, traceroute, network diagnostics |
| **All** | `"-1"` | Use 0 for both ports | Allow all protocols and ports |

### Common Port Examples

```hcl
# Web Services
"http"    = { protocol = "tcp", from_port = 80,   to_port = 80   }
"https"   = { protocol = "tcp", from_port = 443,  to_port = 443  }

# Remote Access
"ssh"     = { protocol = "tcp", from_port = 22,   to_port = 22   }
"rdp"     = { protocol = "tcp", from_port = 3389, to_port = 3389 }

# Databases
"mysql"   = { protocol = "tcp", from_port = 3306, to_port = 3306 }
"postgres"= { protocol = "tcp", from_port = 5432, to_port = 5432 }
"redis"   = { protocol = "tcp", from_port = 6379, to_port = 6379 }

# Network Services
"dns"     = { protocol = "udp", from_port = 53,   to_port = 53   }
"ntp"     = { protocol = "udp", from_port = 123,  to_port = 123  }

# Monitoring
"prometheus" = { protocol = "tcp", from_port = 9090, to_port = 9090 }
"grafana"    = { protocol = "tcp", from_port = 3000, to_port = 3000 }
```

## 🚀 Deployment Guide

### Step 1: Prepare Your Environment

```bash
# Ensure you have AWS CLI configured
aws configure list

# Ensure you have Terraform installed
terraform version
```

### Step 2: Set Up Your Project

```bash
# Create project directory
mkdir my-security-groups
cd my-security-groups

# Copy examples (if using local module)
cp /path/to/SecurityGroup/examples/* .

# Edit configuration
vim terraform.tfvars
```

### Step 3: Deploy

```bash
# Initialize Terraform (downloads modules)
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan -var-file=terraform.tfvars

# Apply changes
terraform apply -var-file=terraform.tfvars
```

### Step 4: Manage Multiple Environments

```bash
# Development environment
terraform apply -var-file=dev.tfvars

# Staging environment
terraform apply -var-file=staging.tfvars

# Production environment
terraform apply -var-file=prod.tfvars
```

## 🎯 Default Egress Rule

By default, the module includes an allow-all egress rule:

```hcl
egress_rules = {
  "default" = {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }
}
```

### Override Default Egress

To restrict outbound traffic, explicitly define egress rules:

```hcl
# Restrictive egress - only HTTPS and DNS
egress_rules = {
  "https_only" = {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    destination = "0.0.0.0/0"
    description = "HTTPS for updates"
  }
  "dns_only" = {
    protocol    = "udp"
    from_port   = 53
    to_port     = 53
    destination = "0.0.0.0/0"
    description = "DNS resolution"
  }
}
```

## 🔍 Prerequisites

### AWS Resources (Must exist before deployment)

1. **VPC**: A VPC where the security group will be created
2. **Referenced Security Groups**: Any SGs referenced in rules must exist

### AWS Permissions Required

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeSecurityGroups",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:CreateTags",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    }
  ]
}
```

## ⚠️ Important Notes

- **Rule Names**: Must be unique within each rule map (ingress/egress)
- **Cross-SG References**: Referenced security groups must exist before deployment
- **CIDR Validation**: Ensure CIDR blocks are valid (e.g., `10.0.0.0/8`, not `10.0.0.0`)
- **Port Ranges**: For ICMP and "all" protocols, use -1 or 0 for ports as appropriate
- **VPC Dependency**: Security groups are VPC-specific and cannot be moved between VPCs

## 🔧 Troubleshooting

### Common Issues

1. **"Invalid CIDR block"**
   - Verify CIDR format (e.g., `10.0.0.0/8`, `192.168.1.0/24`)
   - Check for typos in IP addresses

2. **"Security group not found"**
   - Ensure referenced security groups exist
   - Check security group IDs are correct
   - Verify they're in the same VPC

3. **"VPC not found"**
   - Verify VPC ID exists in the specified region
   - Check VPC ID format (`vpc-xxxxxxxx`)

4. **"Invalid port range"**
   - For ICMP: use from_port = -1, to_port = -1
   - For "all" protocols: use from_port = 0, to_port = 0
   - Ensure from_port ≤ to_port for TCP/UDP

5. **"Duplicate rule"**
   - Check for duplicate rule names in ingress_rules or egress_rules maps
   - Rule names must be unique within each map

## 📞 Support

- **Documentation**: See `examples/` folder for detailed examples
- **Version History**: Check `VERSION.md` for changes and updates
- **Issues**: Report issues in the GitHub repository

## 📄 License

This module is provided as-is for educational and production use.

---

**Version**: 1.0.0  
**Last Updated**: November 2, 2025  
**Terraform Compatibility**: >= 1.0  
**AWS Provider**: >= 5.0