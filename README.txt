### Project: terraform-CloudOps
# Purpose:
This repository contains the modular Terraform configuration to provision a secure, scalable, and fully automated 3-tier architecture on AWS, including:
Private/Public Subnets
NAT Gateway
EC2 Auto Scaling Group (Windows)
SSM access with Fleet Manager
ALB (internal)
RDS SQL Server (with credentials from Secrets Manager)
CloudWatch logging/monitoring

###Repository Structure:
terraform-CloudOps/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── providers.tf
├── .gitignore
├── .terraform.lock.hcl
├── Jenkinsfile
├── Jenkinsfile-destroy
├── modules/
│   ├── vpc/
│   ├── rds/
│   └── security/
├── scripts/
│   └── bootstrap.ps1





###File Overview & Purpose
##main.tf
Primary infrastructure configuration file.

Contains:
VPC, subnets, IGW, NAT Gateway, route tables
EC2 security groups
IAM role + instance profile for EC2
Launch template for Windows EC2 with SSM + IIS
Auto Scaling Group (ASG)
Internal ALB
RDS instance (SQL Server Express)
Secrets Manager for DB credentials
CloudWatch log group and metric alarm

##backend.tf
hcl
Copy
Edit
terraform {
  backend "s3" {
    bucket         = "amruta-tfstate-bucket2"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock2"
    encrypt        = true
  }
}
#Enables remote state storage with state locking via DynamoDB.

#providers.tf

provider "aws" {
  region = var.region
}
#Declares the AWS provider and reads region dynamically.


#variables.tf
Declares all configurable input variables (e.g. region, project, subnet CIDRs, db_user, db_pass).

# terraform.tfvars
Defines concrete values for variables (secrets are injected via Jenkins pipeline).

#outputs.tf
(Currently empty): Can be used to output ALB DNS, RDS endpoint, EC2 instance IDs, etc.

###Modules Directory
You organized reusable infrastructure components under modules/. This supports code reusability, clarity, and scalability.

modules/vpc/ – Contains VPC, subnets, IGW, NAT, and routing logic.

modules/security/ – Contains all security group definitions.

modules/rds/ – Logic for provisioning RDS and Secrets Manager.





### scripts/bootstrap.ps1
Executed by EC2 instances via user_data

# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Add index.html
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value "<h1>Hello from Amruta's Terraform IIS</h1>"

# Ensure SSM Agent is installed and running
Try {
    Start-Service AmazonSSMAgent -ErrorAction Stop
} Catch {
    Invoke-WebRequest -Uri "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/Windows/SSMAgentSetup.exe" -OutFile "$env:TEMP\SSMAgentSetup.exe" -UseBasicParsing
    Start-Process "$env:TEMP\SSMAgentSetup.exe" -ArgumentList "/quiet" -Wait
    Start-Service AmazonSSMAgent
}
Set-Service -Name AmazonSSMAgent -StartupType Automatic
 Validated via SSM Session Manager and Fleet Manager.

⚙️ CI/CD Integration
Jenkinsfile
Terraform automation pipeline (init → fmt → validate → plan → apply).

DB creds and AWS access keys injected securely via Jenkins credentials.

Jenkinsfile-destroy
Used to destroy the entire stack with one click.

##Design Rationale
#Area Rationale
Remote backend	S3 + DynamoDB ensures collaborative and state-safe automation.
Private EC2 + NAT	Secure instances not exposed to the internet.
SSM Session Manager	No key pairs required, secure and auditable access.
Secrets Manager	DB credentials are managed securely, not hardcoded.
ALB internal	Load balances EC2 instances within private subnets.
IIS + Custom Page	IIS installed with a visible index for verification.
Modular Design	Easily extendable and reusable architecture.
