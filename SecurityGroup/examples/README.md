# Security Group Module - Examples

This folder contains example configurations for using the Security Group module with tfvars and proper variable passing.

## Files Included

### 1. `terraform.tfvars`
Example variable values showing:
- Web security group with HTTP, HTTPS, and SSH rules
- Inbound rules from CIDR blocks
- Outbound rules allowing all traffic
- Additional tags

### 2. `main.tf`
Module call that passes variables from tfvars to the Security Group module

### 3. `variables.tf`
Variable definitions that receive values from terraform.tfvars and pass to module

### 4. `output.tf`
Exports key outputs from the module (security group ID, ARN, name)

### 5. `backend.tf`
Backend configurations:
- S3 Backend (recommended for production)
- Local Backend (development only)

## Quick Start

### Step 1: Copy All Example Files to Root Directory

```bash
cp examples/* .
```

### Step 2: Update terraform.tfvars

Replace placeholder values:
```hcl
vpc_id = "vpc-12345678"  # Your actual VPC ID
```

### Step 3: Deploy

```bash
# Initialize
terraform init

# Plan
terraform plan -var-file=terraform.tfvars

# Apply
terraform apply -var-file=terraform.tfvars
```

## How It Works

### Data Flow
```
terraform.tfvars (values) → variables.tf (definitions) → main.tf (module call) → SecurityGroup module
```

### Example Flow
1. `terraform.tfvars` provides: `sg_name = "web-sg"`
2. `variables.tf` defines: `variable "sg_name" { type = string }`
3. `main.tf` passes: `sg_name = var.sg_name`
4. SecurityGroup module receives: `sg_name = "web-sg"`

## Multiple Environments

You can create multiple tfvars files:

```bash
# Development
terraform apply -var-file=dev.tfvars

# Production  
terraform apply -var-file=prod.tfvars
```

**dev.tfvars:**
```hcl
sg_name = "dev-web-sg"
vpc_id  = "vpc-dev-123"
```

**prod.tfvars:**
```hcl
sg_name = "prod-web-sg"
vpc_id  = "vpc-prod-456"
```

## Common Patterns

### Pattern 1: Web Server Security Group

```hcl
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
}
```

### Pattern 2: Database with Security Group Source

```hcl
ingress_rules = {
  "from_app" = {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    source      = module.app_sg.security_group_id
    description = "PostgreSQL from app servers"
  }
}
```

### Pattern 3: Restrict Outbound

```hcl
egress_rules = {
  "to_db" = {
    protocol       = "tcp"
    from_port      = 5432
    to_port        = 5432
    destination    = module.db_sg.security_group_id
    description    = "To database"
  }
  "to_internet" = {
    protocol       = "tcp"
    from_port      = 443
    to_port        = 443
    destination    = "0.0.0.0/0"
    description    = "To internet HTTPS only"
  }
}
```

## Uncomment Examples

The `main.tf` file includes commented examples for:

### Database Security Group

Uncomment to create a database security group that:
- Accepts PostgreSQL (5432) from web SG
- Accepts MySQL (3306) from web SG

### Load Balancer Security Group

Uncomment to create an ALB security group that:
- Accepts HTTP/HTTPS from internet
- Forwards to web servers on port 80

## Multi-Security Group Setup

Example with 3 security groups:

```hcl
# 1. Load Balancer
module "alb_sg" {
  source = "../"
  sg_name = "alb"
  # Accepts HTTP/HTTPS from internet
  # Forwards to web servers
}

# 2. Web Servers
module "web_sg" {
  source = "../"
  sg_name = "web"
  # Accepts from ALB
  # Forwards to database
}

# 3. Database
module "db_sg" {
  source = "../"
  sg_name = "database"
  # Accepts from web servers only
}
```

## Testing Rules

### Check if rule works

```bash
# List security group details
aws ec2 describe-security-groups --group-ids sg-12345678

# List ingress rules
aws ec2 describe-security-group-rules \
  --filters "Name=group-id,Values=sg-12345678" \
  --query 'SecurityGroupRules[?IsEgress==`false`]'
```

## Troubleshooting

### Rules not appearing

Check:
1. Terraform apply was successful
2. Rules are in correct format
3. VPC ID is correct

### Can't reach service

Verify:
1. Security group is attached to EC2/RDS
2. Ingress rule exists for your source
3. CIDR or source SG is correct
4. Port and protocol match service

### CIDR block rejected

Common mistakes:
- Missing /CIDR notation: `10.0.0.0/8` not `10.0.0.0`
- Wrong IP range
- Using domain name instead of CIDR

## Best Practices

1. **Use descriptive rule names** - Clear purpose
2. **Group related rules** - Organize by service
3. **Reference security groups** - Safer than CIDR for internal traffic
4. **Restrict by default** - Add only needed rules
5. **Document intentions** - Use description field
6. **Use variables** - Reuse across environments
7. **Tag rules** - Track ownership and purpose

## Common Ports

| Service | Port | Protocol |
|---------|------|----------|
| HTTP | 80 | tcp |
| HTTPS | 443 | tcp |
| SSH | 22 | tcp |
| RDP | 3389 | tcp |
| PostgreSQL | 5432 | tcp |
| MySQL | 3306 | tcp |
| MongoDB | 27017 | tcp |
| Redis | 6379 | tcp |
| Elasticsearch | 9200 | tcp |
| DNS | 53 | udp/tcp |
| NTP | 123 | udp |

---

For detailed module documentation, see `../README.md`
