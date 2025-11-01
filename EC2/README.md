# EC2 Module# EC2 Module



A comprehensive and flexible Terraform module to deploy **multiple EC2 instances** with advanced configuration options, multi-subnet support, and enterprise-grade features.We have created a Terraform module to deploy **multiple EC2 instances** with flexible configuration options.



## 🚀 Features## Features



- ✅ **Multiple Instances**: Deploy 1-N EC2 instances using `for_each`- ✅ Create multiple EC2 instances using `for_each`

- ✅ **Multi-Subnet Support**: Deploy instances across different subnets/AZs- ✅ Configurable instance type, AMI, and count

- ✅ **Flexible Storage**: Configurable root volume + multiple additional EBS volumes- ✅ VPC and subnet selection

- ✅ **Security**: Security group integration and IAM instance profiles- ✅ Security group management

- ✅ **User Data**: Support for Linux and Windows initialization scripts- ✅ Root volume customization

- ✅ **Enterprise Tags**: Mandatory tag validation with custom requirements- ✅ Additional EBS volumes support

- ✅ **Placement Groups**: Optional placement group support for performance- ✅ Mandatory tag validation

- ✅ **Version Controlled**: GitHub sourced with semantic versioning- ✅ IAM instance profile support

- ✅ Automatic tagging

## 📁 Module Structure

## Module Structure

```

EC2/```

├── main.tf           # EC2 instance and EBS volume resourcesEC2/

├── variables.tf      # Input variable definitions with validation├── main.tf           # EC2 instance resource definitions

├── output.tf         # Output values (IDs, IPs, details)├── variables.tf      # Input variable definitions

├── provider.tf       # AWS provider configuration├── output.tf         # Output values

├── VERSION.md        # Version history and changelog└── provider.tf       # AWS provider configuration

├── README.md         # This documentation```

└── examples/         # Usage examples and configurations

    ├── main.tf## Usage

    ├── variables.tf

    ├── output.tf### Basic Example

    ├── terraform.tfvars

    ├── backend.tfCreate a `terraform.tfvars` file in your root directory:

    ├── user_data.sh

    ├── user_data.ps1```hcl

    └── README.md# AWS Configuration

```aws_region = "us-east-1"



## 🔧 Quick Start# Instance Configuration

instance_count  = 2

### 1. Source the Moduleinstance_type   = "t3.small"

ami_id          = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 in us-east-1

Choose your preferred sourcing method:instance-prefix = "my-app"



#### Option A: GitHub (Recommended for Production)# Networking

```hclvpc_id     = "vpc-12345678"

module "ec2_instances" {subnet_ids = {

  source = "git@github.com:tzo11/Terraform-modules.git//EC2?ref=ec2-v1.0.1"  "0" = "subnet-12345678"

    "1" = "subnet-87654321"

  # Required variables}

  ami_id               = "ami-0c55b159cbfafe1f0"security_group_ids = ["sg-12345678"]

  instance-prefix      = "my-app"

  vpc_id               = "vpc-12345678"# IAM

  subnet_ids           = {iam_instance_profile = "EC2-Role"

    "0" = "subnet-12345678"

    "1" = "subnet-87654321"# Storage

  }root_volume_size = 20

  security_group_ids   = ["sg-12345678"]root_volume_type = "gp3"

  iam_instance_profile = "EC2-Role"

  mandatory_tags       = {# User Data

    "Environment"      = "production"user_data = file("${path.module}/user_data.sh")

    "Technical Owner"  = "DevOps Team"

    "Name"             = "my-ec2"# Additional Volumes (Optional)

    "AppID"            = "APP-001"additional_volumes = {

    "SysID"            = "SYS-001"  "1" = {

  }    size                  = 100

}    type                  = "gp3"

```    delete_on_termination = true

    encrypted             = true

#### Option B: Local Path (Development)  }

```hcl  "2" = {

module "ec2_instances" {    size                  = 50

  source = "./EC2"    type                  = "gp2"

      delete_on_termination = false

  # Same variables as above...    encrypted             = true

}  }

```}



### 2. Copy Examples and Customize# Mandatory Tags

mandatory_tags = {

```bash  "Environment"      = "production"

# Copy example files to your project root  "Technical Owner"  = "DevOps Team"

cp EC2/examples/* .  "Name"             = "my-ec2"

  "AppID"            = "APP-001"

# Edit terraform.tfvars with your values  "SysID"            = "SYS-001"

# Deploy}

terraform init```

terraform plan -var-file=terraform.tfvars

terraform apply -var-file=terraform.tfvars### Calling the Module

```

In your main Terraform configuration:

## 📋 Input Variables

```hcl

### 🔴 MANDATORY Variables (Must be provided)module "ec2_instances" {

  source = "./EC2"

| Variable | Type | Description | Example |  

|----------|------|-------------|---------|  aws_region           = var.aws_region

| **`ami_id`** | `string` | AMI ID for EC2 instances | `"ami-0c55b159cbfafe1f0"` |  instance_count       = 2

| **`instance-prefix`** | `string` | Prefix for instance names | `"web-server"` |  instance_type        = "t3.small"

| **`vpc_id`** | `string` | VPC ID where instances will be created | `"vpc-12345678"` |  ami_id               = "ami-0c55b159cbfafe1f0"

| **`subnet_ids`** | `map(string)` | Map of subnet IDs (one per instance) | `{"0" = "subnet-123", "1" = "subnet-456"}` |  instance-prefix      = "my-app"

| **`security_group_ids`** | `list(string)` | List of security group IDs | `["sg-12345678", "sg-87654321"]` |  vpc_id               = "vpc-12345678"

| **`iam_instance_profile`** | `string` | IAM instance profile name | `"EC2-Role"` |  subnet_ids           = {

| **`mandatory_tags`** | `map(string)` | Required tags (see validation below) | See tags section |    "0" = "subnet-12345678"

    "1" = "subnet-87654321"

### 🟡 OPTIONAL Variables (Have defaults)  }

  security_group_ids   = ["sg-12345678"]

| Variable | Type | Default | Description |  iam_instance_profile = "EC2-Role"

|----------|------|---------|-------------|  root_volume_size     = 20

| `aws_region` | `string` | `"us-east-1"` | AWS region for deployment |  root_volume_type     = "gp3"

| `instance_count` | `number` | `1` | Number of instances to create |  

| `instance_type` | `string` | `"t3.small"` | EC2 instance type |  additional_volumes = {

| `key_pair` | `string` | `null` | AWS key pair for SSH access |    "1" = {

| `root_volume_size` | `number` | `20` | Root volume size in GB |      size                  = 100

| `root_volume_type` | `string` | `"gp3"` | Root volume type (gp2, gp3, io1, io2) |      type                  = "gp3"

| `placement_group` | `string` | `null` | Placement group name |      delete_on_termination = true

| `user_data` | `string` | `""` | User data script content |      encrypted             = true

| `user_data_base64` | `string` | `""` | Base64 encoded user data |    }

| `additional_volumes` | `map(object)` | `{}` | Additional EBS volumes (see below) |  }

  

### 🏷️ Mandatory Tags Validation  mandatory_tags = {

    "Environment"      = "production"

The module enforces these tag keys (you must provide values):    "Technical Owner"  = "DevOps Team"

    "Name"             = "my-ec2"

```hcl    "AppID"            = "APP-001"

mandatory_tags = {    "SysID"            = "SYS-001"

  "Environment"      = "production"     # Environment name (dev, staging, prod)  }

  "Technical Owner"  = "DevOps Team"    # Team responsible for resources}

  "Name"             = "my-application" # Application/service name```

  "AppID"            = "APP-001"        # Application identifier

  "SysID"            = "SYS-001"        # System identifier## Input Variables

}

```| Variable | Type | Default | Required | Description |

|----------|------|---------|----------|-------------|

**❌ Missing any key will cause deployment to fail with validation error.**| `aws_region` | string | `us-east-1` | No | AWS region for resources |

| `instance_count` | number | `1` | No | Number of EC2 instances to create |

### 💾 Additional Volumes Configuration| `instance_type` | string | `t3.small` | No | EC2 instance type |

| `ami_id` | string | - | **Yes** | AMI ID for instances |

```hcl| `instance-prefix` | string | - | **Yes** | Prefix for instance names |

additional_volumes = {| `vpc_id` | string | - | **Yes** | VPC ID for instances |

  "1" = {                              # Volume identifier (used for device naming)| `subnet_ids` | map(string) | - | **Yes** | Map of subnet IDs (one per instance) |

    size                  = 100        # Size in GB| `security_group_ids` | list(string) | - | **Yes** | Security group IDs |

    type                  = "gp3"      # Volume type (gp2, gp3, io1, io2)| `iam_instance_profile` | string | - | **Yes** | IAM instance profile name |

    delete_on_termination = true       # Delete when instance terminates| `root_volume_size` | number | `20` | No | Root volume size in GB |

    encrypted             = true       # Enable encryption| `root_volume_type` | string | `gp3` | No | Root volume type (gp2, gp3, io1) |

  }| `additional_volumes` | map(object) | `{}` | No | Additional EBS volumes |

  "2" = {| `user_data` | string | `""` | No | User data script (Linux or Windows) |

    size                  = 200| `user_data_base64` | string | `""` | No | Base64 encoded user data script |

    type                  = "io1"| `mandatory_tags` | map(string) | - | **Yes** | Required tags (Environment, Technical Owner, Name, AppID, SysID) |

    delete_on_termination = false

    encrypted             = true## Outputs

  }

}| Output | Description |

```|--------|-------------|

| `instance_ids` | Map of instance IDs |

**Device naming:** Volumes are mapped to `/dev/sda`, `/dev/sdb`, etc. based on numeric keys.| `private_ips` | Map of private IP addresses |

| `instances` | Complete instance details |

## 📤 Outputs

## Example Output

| Output | Type | Description |

|--------|------|-------------|```hcl

| `instance_ids` | `map(string)` | Map of instance IDs keyed by instance number |# Access outputs

| `private_ips` | `map(string)` | Map of private IP addresses |output "app_instances" {

| `public_ips` | `map(string)` | Map of public IP addresses (if assigned) |  value = module.ec2_instances.instance_ids

| `instances` | `object` | Complete instance details (marked sensitive) |  # Output: { "0" = "i-12345", "1" = "i-67890" }

}

### Using Outputs

output "app_private_ips" {

```hcl  value = module.ec2_instances.private_ips

# Access specific instance ID  # Output: { "0" = "10.0.1.10", "1" = "10.0.1.11" }

instance_0_id = module.ec2_instances.instance_ids["0"]}

```

# Get all private IPs

private_ips = module.ec2_instances.private_ips## User Data Examples



# Use in other modules### Linux (Amazon Linux 2 / Ubuntu)

module "load_balancer" {

  source      = "./ALB"Create a file `user_data.sh`:

  instance_ids = values(module.ec2_instances.instance_ids)

}```bash

```#!/bin/bash

set -e

## 💻 Complete Usage Examples

# Update system

### Example 1: Basic Web Server Deploymentyum update -y



```hcl# Install Docker

module "web_servers" {amazon-linux-extras install docker -y

  source = "git@github.com:tzo11/Terraform-modules.git//EC2?ref=ec2-v1.0.1"systemctl start docker

  systemctl enable docker

  # Instance Configuration

  instance_count  = 2# Install Docker Compose

  instance_type   = "t3.medium"curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

  ami_id          = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2chmod +x /usr/local/bin/docker-compose

  instance-prefix = "web-server"

  key_pair        = "my-keypair"echo "Initialization complete!"

  ```

  # Networking

  vpc_id         = "vpc-12345678"Use in `terraform.tfvars`:

  subnet_ids     = {

    "0" = "subnet-web-1a"```hcl

    "1" = "subnet-web-1b"user_data = file("${path.module}/user_data.sh")

  }```

  security_group_ids = ["sg-web-servers"]

  ### Windows (Base64 Encoded)

  # IAM

  iam_instance_profile = "WebServerRole"Create a PowerShell script `user_data.ps1`:

  

  # Storage```powershell

  root_volume_size = 30<powershell>

  root_volume_type = "gp3"# Update system

  Install-WindowsUpdate -AcceptAll -AutoReboot

  # User Data

  user_data = file("${path.module}/web-server-init.sh")# Install Chocolatey

  Set-ExecutionPolicy Bypass -Scope Process -Force

  # Tags[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

  mandatory_tags = {iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    "Environment"      = "production"

    "Technical Owner"  = "Platform Team"# Install applications

    "Name"             = "web-servers"choco install -y docker-desktop

    "AppID"            = "WEB-001"choco install -y git

    "SysID"            = "SYS-WEB"

  }Write-Host "Initialization complete!"

}</powershell>

``````



### Example 2: Database Servers with Additional StorageUse in `terraform.tfvars`:



```hcl```hcl

module "db_servers" {user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))

  source = "git@github.com:tzo11/Terraform-modules.git//EC2?ref=ec2-v1.0.1"```

  

  # Instance ConfigurationOr use the `file()` function directly:

  instance_count  = 3

  instance_type   = "r5.xlarge"```hcl

  ami_id          = "ami-0abcdef123456789"user_data = file("${path.module}/user_data.ps1")

  instance-prefix = "db-server"```

  placement_group = "db-placement-group"

  ### Inline User Data

  # Networking

  vpc_id         = "vpc-87654321"You can also provide inline scripts:

  subnet_ids     = {

    "0" = "subnet-db-1a"**Linux:**

    "1" = "subnet-db-1b"```hcl

    "2" = "subnet-db-1c"user_data = <<-EOF

  }              #!/bin/bash

  security_group_ids = ["sg-database"]              echo "Hello from $(hostname)" > /tmp/hello.txt

                EOF

  # IAM```

  iam_instance_profile = "DatabaseRole"

  **Windows:**

  # Storage Configuration```hcl

  root_volume_size = 50user_data = <<-EOF

  root_volume_type = "gp3"              <powershell>

                Write-Host "Hello from $(hostname)"

  additional_volumes = {              </powershell>

    "1" = {                           # Data volume              EOF

      size                  = 500```

      type                  = "gp3"

      delete_on_termination = false## How It Works

      encrypted             = true

    }### Multiple Instances with for_each

    "2" = {                           # Log volume

      size                  = 100The module uses `for_each` to create multiple instances:

      type                  = "gp3"

      delete_on_termination = false```hcl

      encrypted             = truefor_each = toset([for i in range(var.instance_count) : tostring(i)])

    }```

  }

  This creates instances numbered `0`, `1`, `2`, etc.

  # Tags

  mandatory_tags = {### Instance Naming

    "Environment"      = "production"

    "Technical Owner"  = "Database Team"Instances are named using the pattern: `{instance-prefix}-{number}`

    "Name"             = "postgresql-cluster"

    "AppID"            = "DB-001"Example: `my-app-0`, `my-app-1`, `my-app-2`

    "SysID"            = "SYS-DB"

  }### Mandatory Tag Validation

}

```The module enforces the following tag keys:

- `Environment` - Environment name (dev, staging, prod)

### Example 3: Windows Servers- `Technical Owner` - Team responsible

- `Name` - Instance name

```hcl- `AppID` - Application identifier

module "windows_servers" {- `SysID` - System identifier

  source = "git@github.com:tzo11/Terraform-modules.git//EC2?ref=ec2-v1.0.1"

  If any key is missing, Terraform will show an error.

  # Instance Configuration

  instance_count  = 2### Root Volume

  instance_type   = "t3.large"

  ami_id          = "ami-windows-2019"- Encrypted by default

  instance-prefix = "win-server"- Size and type configurable

  - Automatically deleted on termination

  # Networking

  vpc_id         = "vpc-windows"### Additional Volumes

  subnet_ids     = {

    "0" = "subnet-win-1a"Additional volumes are mapped to device names:

    "1" = "subnet-win-1b"- `"1"` → `/dev/sda`

  }- `"2"` → `/dev/sdb`

  security_group_ids = ["sg-windows-servers"]- `"3"` → `/dev/sdc`

  - etc.

  # IAM

  iam_instance_profile = "WindowsServerRole"## Prerequisites

  

  # Storage1. **AWS Account** with appropriate permissions

  root_volume_size = 1002. **Terraform** >= 1.0

  root_volume_type = "gp3"3. **AWS CLI** configured with credentials

  4. **VPC, Subnet, and Security Group** already created

  # Windows User Data (PowerShell)5. **IAM Instance Profile** already created

  user_data_base64 = base64encode(file("${path.module}/windows-init.ps1"))

  ## Deploying

  # Tags

  mandatory_tags = {```bash

    "Environment"      = "development"# Initialize Terraform

    "Technical Owner"  = "Windows Team"terraform init

    "Name"             = "iis-servers"

    "AppID"            = "IIS-001"# Plan the deployment

    "SysID"            = "SYS-WIN"terraform plan -var-file=terraform.tfvars

  }

}# Apply the configuration

```terraform apply -var-file=terraform.tfvars



## 📜 User Data Scripts# Destroy resources

terraform destroy -var-file=terraform.tfvars

### Linux User Data Example```



Create `user_data.sh`:## Notes



```bash- Instances can now be created in **different subnets** (specify one subnet per instance in `subnet_ids` map)

#!/bin/bash- All instances have the **same instance type** (unless customized)

set -e- Root volume is **always encrypted**

- Additional volumes are optional

# Log all output- Mandatory tags are **required** for all instances

exec > >(tee /var/log/user-data.log)

exec 2>&1## Troubleshooting



echo "Starting EC2 initialization..."### Error: Missing mandatory tags

**Solution:** Ensure all required tag keys are provided in `mandatory_tags`

# Update system

yum update -y### Error: Invalid device name

**Solution:** Use numeric keys for `additional_volumes` (e.g., "1", "2", not "vol1", "vol2")

# Install essential packages

yum install -y docker git htop wget curl### Error: Subnet not found

**Solution:** Verify `subnet_id` exists in the specified `vpc_id`

# Start Docker

systemctl start docker## License

systemctl enable docker

usermod -aG docker ec2-userThis module is provided as-is for educational purposes.


# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create app directory
mkdir -p /opt/myapp
cd /opt/myapp

echo "EC2 initialization completed!"
```

Usage in module:
```hcl
user_data = file("${path.module}/user_data.sh")
```

### Windows User Data Example

Create `user_data.ps1`:

```powershell
<powershell>
# Log output
Start-Transcript -Path "C:\ProgramData\user-data.log"

Write-Host "Starting Windows EC2 initialization..."

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install applications
choco install -y git docker-desktop vscode

# Configure Windows features
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -All

Write-Host "Windows EC2 initialization completed!"
Stop-Transcript
</powershell>
```

Usage in module:
```hcl
user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))
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
mkdir my-ec2-project
cd my-ec2-project

# Copy examples (if using local module)
cp /path/to/EC2/examples/* .

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

## 🔍 Prerequisites

### AWS Resources (Must exist before deployment)

1. **VPC**: A VPC where instances will be deployed
2. **Subnets**: One or more subnets in the VPC
3. **Security Groups**: Security groups with appropriate rules
4. **IAM Instance Profile**: IAM role for EC2 instances
5. **Key Pair**: EC2 Key Pair for SSH access (optional)
6. **AMI**: Valid AMI ID in your target region

### AWS Permissions Required

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:CreateTags",
        "ec2:AttachVolume",
        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:DescribeVolumes",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
```

## ⚠️ Important Notes

- **Instance Count vs Subnets**: Ensure you provide enough subnet IDs for your instance count
- **Tag Validation**: All mandatory tag keys are required, deployment will fail without them
- **EBS Encryption**: Root volumes are always encrypted, additional volumes can be configured
- **User Data Size**: User data is limited to 16KB, use external scripts for larger installations
- **Regional AMIs**: AMI IDs are region-specific, update for different regions

## 🔧 Troubleshooting

### Common Issues

1. **"Subnet not found"**
   - Verify subnet IDs exist in the specified VPC
   - Check region configuration

2. **"Security group not found"**
   - Ensure security group is in the same VPC
   - Verify security group IDs are correct

3. **"IAM instance profile not found"**
   - Create the IAM role and instance profile
   - Ensure proper permissions

4. **"Insufficient subnet capacity"**
   - Choose different subnets with available IP addresses
   - Check subnet CIDR blocks

5. **Tag validation errors**
   - Ensure all mandatory tag keys are provided
   - Check for typos in tag keys

## 📞 Support

- **Documentation**: See `examples/` folder for detailed examples
- **Version History**: Check `VERSION.md` for changes and updates
- **Issues**: Report issues in the GitHub repository

## 📄 License

This module is provided as-is for educational and production use.

---

**Version**: 1.0.1  
**Last Updated**: November 2, 2025  
**Terraform Compatibility**: >= 1.0  
**AWS Provider**: >= 5.0