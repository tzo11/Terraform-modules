# EC2 Module

We have created a Terraform module to deploy **multiple EC2 instances** with flexible configuration options.

## Features

- ✅ Create multiple EC2 instances using `for_each`
- ✅ Configurable instance type, AMI, and count
- ✅ VPC and subnet selection
- ✅ Security group management
- ✅ Root volume customization
- ✅ Additional EBS volumes support
- ✅ Mandatory tag validation
- ✅ IAM instance profile support
- ✅ Automatic tagging

## Module Structure

```
EC2/
├── main.tf           # EC2 instance resource definitions
├── variables.tf      # Input variable definitions
├── output.tf         # Output values
└── provider.tf       # AWS provider configuration
```

## Usage

### Basic Example

Create a `terraform.tfvars` file in your root directory:

```hcl
# AWS Configuration
aws_region = "us-east-1"

# Instance Configuration
instance_count  = 2
instance_type   = "t3.small"
ami_id          = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 in us-east-1
instance-prefix = "my-app"

# Networking
vpc_id     = "vpc-12345678"
subnet_ids = {
  "0" = "subnet-12345678"
  "1" = "subnet-87654321"
}
security_group_ids = ["sg-12345678"]

# IAM
iam_instance_profile = "EC2-Role"

# Storage
root_volume_size = 20
root_volume_type = "gp3"

# User Data
user_data = file("${path.module}/user_data.sh")

# Additional Volumes (Optional)
additional_volumes = {
  "1" = {
    size                  = 100
    type                  = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
  "2" = {
    size                  = 50
    type                  = "gp2"
    delete_on_termination = false
    encrypted             = true
  }
}

# Mandatory Tags
mandatory_tags = {
  "Environment"      = "production"
  "Technical Owner"  = "DevOps Team"
  "Name"             = "my-ec2"
  "AppID"            = "APP-001"
  "SysID"            = "SYS-001"
}
```

### Calling the Module

In your main Terraform configuration:

```hcl
module "ec2_instances" {
  source = "./EC2"
  
  aws_region           = var.aws_region
  instance_count       = 2
  instance_type        = "t3.small"
  ami_id               = "ami-0c55b159cbfafe1f0"
  instance-prefix      = "my-app"
  vpc_id               = "vpc-12345678"
  subnet_ids           = {
    "0" = "subnet-12345678"
    "1" = "subnet-87654321"
  }
  security_group_ids   = ["sg-12345678"]
  iam_instance_profile = "EC2-Role"
  root_volume_size     = 20
  root_volume_type     = "gp3"
  
  additional_volumes = {
    "1" = {
      size                  = 100
      type                  = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }
  
  mandatory_tags = {
    "Environment"      = "production"
    "Technical Owner"  = "DevOps Team"
    "Name"             = "my-ec2"
    "AppID"            = "APP-001"
    "SysID"            = "SYS-001"
  }
}
```

## Input Variables

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `aws_region` | string | `us-east-1` | No | AWS region for resources |
| `instance_count` | number | `1` | No | Number of EC2 instances to create |
| `instance_type` | string | `t3.small` | No | EC2 instance type |
| `ami_id` | string | - | **Yes** | AMI ID for instances |
| `instance-prefix` | string | - | **Yes** | Prefix for instance names |
| `vpc_id` | string | - | **Yes** | VPC ID for instances |
| `subnet_ids` | map(string) | - | **Yes** | Map of subnet IDs (one per instance) |
| `security_group_ids` | list(string) | - | **Yes** | Security group IDs |
| `iam_instance_profile` | string | - | **Yes** | IAM instance profile name |
| `root_volume_size` | number | `20` | No | Root volume size in GB |
| `root_volume_type` | string | `gp3` | No | Root volume type (gp2, gp3, io1) |
| `additional_volumes` | map(object) | `{}` | No | Additional EBS volumes |
| `user_data` | string | `""` | No | User data script (Linux or Windows) |
| `user_data_base64` | string | `""` | No | Base64 encoded user data script |
| `mandatory_tags` | map(string) | - | **Yes** | Required tags (Environment, Technical Owner, Name, AppID, SysID) |

## Outputs

| Output | Description |
|--------|-------------|
| `instance_ids` | Map of instance IDs |
| `private_ips` | Map of private IP addresses |
| `instances` | Complete instance details |

## Example Output

```hcl
# Access outputs
output "app_instances" {
  value = module.ec2_instances.instance_ids
  # Output: { "0" = "i-12345", "1" = "i-67890" }
}

output "app_private_ips" {
  value = module.ec2_instances.private_ips
  # Output: { "0" = "10.0.1.10", "1" = "10.0.1.11" }
}
```

## User Data Examples

### Linux (Amazon Linux 2 / Ubuntu)

Create a file `user_data.sh`:

```bash
#!/bin/bash
set -e

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Initialization complete!"
```

Use in `terraform.tfvars`:

```hcl
user_data = file("${path.module}/user_data.sh")
```

### Windows (Base64 Encoded)

Create a PowerShell script `user_data.ps1`:

```powershell
<powershell>
# Update system
Install-WindowsUpdate -AcceptAll -AutoReboot

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install applications
choco install -y docker-desktop
choco install -y git

Write-Host "Initialization complete!"
</powershell>
```

Use in `terraform.tfvars`:

```hcl
user_data_base64 = base64encode(file("${path.module}/user_data.ps1"))
```

Or use the `file()` function directly:

```hcl
user_data = file("${path.module}/user_data.ps1")
```

### Inline User Data

You can also provide inline scripts:

**Linux:**
```hcl
user_data = <<-EOF
              #!/bin/bash
              echo "Hello from $(hostname)" > /tmp/hello.txt
              EOF
```

**Windows:**
```hcl
user_data = <<-EOF
              <powershell>
              Write-Host "Hello from $(hostname)"
              </powershell>
              EOF
```

## How It Works

### Multiple Instances with for_each

The module uses `for_each` to create multiple instances:

```hcl
for_each = toset([for i in range(var.instance_count) : tostring(i)])
```

This creates instances numbered `0`, `1`, `2`, etc.

### Instance Naming

Instances are named using the pattern: `{instance-prefix}-{number}`

Example: `my-app-0`, `my-app-1`, `my-app-2`

### Mandatory Tag Validation

The module enforces the following tag keys:
- `Environment` - Environment name (dev, staging, prod)
- `Technical Owner` - Team responsible
- `Name` - Instance name
- `AppID` - Application identifier
- `SysID` - System identifier

If any key is missing, Terraform will show an error.

### Root Volume

- Encrypted by default
- Size and type configurable
- Automatically deleted on termination

### Additional Volumes

Additional volumes are mapped to device names:
- `"1"` → `/dev/sda`
- `"2"` → `/dev/sdb`
- `"3"` → `/dev/sdc`
- etc.

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** >= 1.0
3. **AWS CLI** configured with credentials
4. **VPC, Subnet, and Security Group** already created
5. **IAM Instance Profile** already created

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

- Instances can now be created in **different subnets** (specify one subnet per instance in `subnet_ids` map)
- All instances have the **same instance type** (unless customized)
- Root volume is **always encrypted**
- Additional volumes are optional
- Mandatory tags are **required** for all instances

## Troubleshooting

### Error: Missing mandatory tags
**Solution:** Ensure all required tag keys are provided in `mandatory_tags`

### Error: Invalid device name
**Solution:** Use numeric keys for `additional_volumes` (e.g., "1", "2", not "vol1", "vol2")

### Error: Subnet not found
**Solution:** Verify `subnet_id` exists in the specified `vpc_id`

## License

This module is provided as-is for educational purposes.
