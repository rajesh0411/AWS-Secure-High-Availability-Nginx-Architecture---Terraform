
# Terraform AWS Secure High Availability Nginx Architecture

## Project Overview

This project demonstrates a production-style AWS infrastructure deployed using Terraform.

The architecture hosts a highly available static Nginx web application behind an Application Load Balancer with Auto Scaling across multiple Availability Zones.

The project follows AWS cloud security and infrastructure best practices including:

- Infrastructure as Code (Terraform)
- Private EC2 instances
- Public-facing Application Load Balancer
- Auto Scaling Group
- Multi-AZ deployment
- IAM Roles instead of access keys
- AWS Systems Manager Session Manager
- NAT Gateway for controlled outbound access
- Encrypted EBS volumes
- IMDSv2 enforcement
- Security Group based access control

---

# Architecture Diagram

![Architecture Diagram](architecture-diagram.png)

---

# Architecture Components

## Networking
- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

## Compute
- EC2 Instances
- Launch Template
- Auto Scaling Group

## Load Balancing
- Application Load Balancer
- Target Group
- Health Checks

## Security
- IAM Roles
- Instance Profiles
- Security Groups
- IMDSv2
- Session Manager

## Monitoring
- CloudWatch Metrics
- Target Health Monitoring

---

# High Level Architecture

```text
Users
  ↓
Internet
  ↓
Internet Gateway
  ↓
Application Load Balancer (Public Subnets)
  ↓
Target Group
  ↓
Auto Scaling Group
  ↓
EC2 Instances running Nginx (Private Subnets)
```

---

# VPC Design

| Component | CIDR |
|---|---|
| VPC | 10.0.0.0/16 |
| Public Subnet A | 10.0.1.0/24 |
| Public Subnet B | 10.0.2.0/24 |
| Private Subnet A | 10.0.11.0/24 |
| Private Subnet B | 10.0.12.0/24 |

---

# Security Design

## Network Security
- EC2 instances deployed in private subnets
- No public IP addresses assigned to EC2
- Internet-facing access restricted to ALB only
- Security Groups enforce traffic restrictions

## Access Management
- IAM Roles attached to EC2 instances
- No hardcoded AWS credentials
- Session Manager used instead of SSH

## EC2 Hardening
- IMDSv2 enforced
- EBS encryption enabled
- Least privilege IAM design

## High Availability
- Multi-AZ deployment
- ALB deployed across two Availability Zones
- Auto Scaling Group spans multiple AZs

---

# Terraform Resources Used

## Core Infrastructure
- aws_vpc
- aws_subnet
- aws_internet_gateway
- aws_route_table
- aws_route
- aws_nat_gateway
- aws_eip

## Security
- aws_security_group
- aws_iam_role
- aws_iam_instance_profile
- aws_iam_role_policy_attachment

## Compute
- aws_launch_template
- aws_autoscaling_group

## Load Balancing
- aws_lb
- aws_lb_listener
- aws_lb_target_group

---

# Terraform Project Structure

```text
terraform-aws-secure-nginx/
│
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── userdata/
│   └── nginx.sh
│
├── screenshots/
│   ├── architecture.png
│   ├── alb.png
│   ├── asg.png
│   ├── target-group.png
│   └── nginx-page.png
│
├── .gitignore
│
└── README.md
```

---

# Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Preview Infrastructure Changes

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# Launch Template Security Features

## Implemented Security Controls

### IMDSv2 Enforcement

```hcl
metadata_options {
  http_endpoint = "enabled"
  http_tokens   = "required"
}
```

### EBS Encryption

```hcl
encrypted = true
```

### Disable Public IPs

```hcl
associate_public_ip_address = false
```

---

# Auto Scaling Configuration

| Setting | Value |
|---|---|
| Desired Capacity | 2 |
| Minimum Capacity | 2 |
| Maximum Capacity | 4 |

---

# Load Balancer Configuration

| Setting | Value |
|---|---|
| Type | Application Load Balancer |
| Scheme | Internet Facing |
| Listener | HTTP : 80 |
| Target Type | Instance |

---

# EC2 Configuration

| Setting | Value |
|---|---|
| Operating System | Amazon Linux 2023 |
| Web Server | Nginx |
| Access Method | AWS Systems Manager |
| Instance Type | t3.micro |

---

# Nginx User Data

The EC2 instances automatically:
- Install Nginx
- Start the web server
- Fetch EC2 instance metadata securely using IMDSv2
- Display instance ID on webpage

---

# Important Terraform Security Notes

## Files Excluded from GitHub

The following files are excluded using `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
```

## Safe to Commit
- `.tf` files
- `.terraform.lock.hcl`
- README
- User data scripts

## Never Commit
- Terraform state files
- AWS credentials
- Secrets
- Private keys

---

# Screenshots

## Application Load Balancer
![ALB](screenshots/alb.png)

## Auto Scaling Group
![ASG](screenshots/asg.png)

## Target Group
![Target Group](screenshots/target-group.png)

## Nginx Webpage
![Nginx](screenshots/nginx-page.png)

---

# Key Learnings

- Infrastructure as Code
- Terraform dependency management
- AWS networking
- Secure VPC architecture
- High availability design
- IAM Roles and Instance Profiles
- Auto Scaling
- Load balancing
- Session Manager administration
- EC2 hardening
- Cloud security best practices

---

# Future Improvements

## Planned Enhancements
- HTTPS using ACM
- CloudFront integration
- AWS WAF
- Route53 DNS
- Remote Terraform state
- DynamoDB state locking
- GitHub Actions CI/CD
- Docker containerization
- ECS Fargate migration
- Centralized logging
- GuardDuty integration

---

# Author

Rajesh Tyson

Cloud Security & AWS Learning Project