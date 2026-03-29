# terraform-aws-nginx-server

Terraform configuration that deploys a single EC2 instance running nginx on AWS.
The instance is provisioned using an Amazon Linux 2 AMI and a `user-data.sh` bootstrap
script that installs and starts nginx automatically.

## Features

- Launches an EC2 instance with nginx installed via user data
- Creates a dedicated security group with HTTP (port 80) access
- Optional SSH access when an EC2 key pair name is supplied
- Defaults to the latest Amazon Linux 2 AMI when no AMI ID is specified
- Fully configurable: region, instance type, VPC, subnet, CIDR allowlists, and tags

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- An AWS account with credentials configured (e.g. via `aws configure` or environment variables)

## Usage

```hcl
module "nginx_server" {
  source = "github.com/SpirSpir/terraform-aws-nginx-server"

  aws_region    = "us-east-1"
  instance_type = "t3.micro"
  instance_name = "my-nginx-server"
  key_name      = "my-key-pair"

  tags = {
    Environment = "production"
  }
}
```

### Quick start

```bash
# 1. Copy the example variable file and edit it
cp terraform.tfvars.example terraform.tfvars

# 2. Initialize Terraform
terraform init

# 3. Preview the changes
terraform plan

# 4. Apply the configuration
terraform apply
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `aws_region` | AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` | no |
| `ami_id` | AMI ID for the EC2 instance. Uses the latest Amazon Linux 2 AMI when empty. | `string` | `""` | no |
| `key_name` | Name of an existing EC2 key pair to enable SSH access | `string` | `""` | no |
| `instance_name` | Name tag for the EC2 instance | `string` | `"nginx-server"` | no |
| `vpc_id` | ID of the VPC to deploy the instance into. Uses the default VPC when empty. | `string` | `""` | no |
| `subnet_id` | ID of the subnet to deploy the instance into. Uses a default subnet when empty. | `string` | `""` | no |
| `allowed_http_cidr_blocks` | CIDR blocks allowed to access nginx over HTTP | `list(string)` | `["0.0.0.0/0"]` | no |
| `allowed_ssh_cidr_blocks` | CIDR blocks allowed to SSH into the instance | `list(string)` | `["0.0.0.0/0"]` | no |
| `associate_public_ip_address` | Whether to associate a public IP address with the instance | `bool` | `true` | no |
| `tags` | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | ID of the EC2 instance |
| `public_ip` | Public IP address of the EC2 instance |
| `public_dns` | Public DNS name of the EC2 instance |
| `security_group_id` | ID of the security group attached to the EC2 instance |

## File Structure

```
├── main.tf                   # EC2 instance, security group, and provider configuration
├── variables.tf              # Input variable definitions
├── outputs.tf                # Output value definitions
├── versions.tf               # Terraform and provider version constraints
├── terraform.tfvars.example  # Example variable values (copy to terraform.tfvars)
├── user-data.sh              # Bootstrap script to install and start nginx
├── .gitignore                # Ignores state files, .terraform directory, and tfvars
└── README.md                 # This file
```

## License

MIT