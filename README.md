AWS CloudOps Infrastructure with Terraform + Jenkins CI/CD

This project automates the provisioning and destruction of AWS infrastructure using Terraform modules and a Jenkins-based CI/CD pipeline.

CI Pipeline → `terraform apply`  
Destroy Pipeline → `terraform destroy`  
Modular Code with Reusable Terraform Modules


 Final Directory Structure
terraform-CloudOps/
├── backend.tf # Remote backend config (S3 + DynamoDB)
├── main.tf # Root file connecting all modules
├── providers.tf # AWS provider config
├── terraform.tfvars # User-defined variable values
├── variables.tf # Input variables for root module
├── outputs.tf # Root output values
├── Jenkinsfile # CI pipeline to deploy infrastructure
├── Jenkinsfile-destroy # CI pipeline to destroy infrastructure
├── scripts/
│ └── bootstrap.ps1 # Windows IIS setup script
├── modules/
│ ├── vpc/ # Custom VPC module
│ │ ├── main.tf
│ │ └── variables.tf
│ ├── compute/ # Launch Template + ASG + ALB
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── rds/ # RDS SQL Server + Secrets Manager
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── security/ # IAM roles, SSM, security groups
│ │ ├── main.tf
│ │ ├── ec2_read_secret.tf
│ │ ├── ssm_secrets.tf
│ │ └── outputs.tf
│ └── monitoring/ # CloudWatch log group and alarms
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf




What Each File/Module Does

Root Files

- `main.tf` — Connects all modules like VPC, compute, RDS, security, monitoring
- `backend.tf` — Stores Terraform state in S3, locks state via DynamoDB
- `terraform.tfvars` — Sets values for variables like project name, db_user, db_pass
- `variables.tf` — Declares inputs required for the root module
- `Jenkinsfile` — Runs `terraform init`, `validate`, `plan`, and `apply`
- `Jenkinsfile-destroy` — Automates `terraform destroy` for safe teardown

---

 1.modules/vpc/

Creates a private network with:
- Public & Private subnets
- NAT Gateway + Internet Gateway
- Route Tables

resource "aws_vpc" ...
resource "aws_subnet" ...
resource "aws_nat_gateway" ...

2. modules/compute/
Launches EC2 Windows IIS in private subnet using:
Launch Template with user_data (PowerShell)
Auto Scaling Group (2 instances)
Internal ALB to distribute traffic

resource "aws_db_instance" ...
resource "aws_secretsmanager_secret" ...


3.modules/rds/

Deploys SQL Server instance with:
Private subnet group
Secrets Manager storing credentials
Encrypted storage

resource "aws_db_instance" ...
resource "aws_secretsmanager_secret" ...

4.  modules/security/
IAM and Security Groups:
EC2 IAM role with SSM + SecretsManager permissions
Security groups for EC2, ALB, RDS
Instance profile

resource "aws_iam_role" ...
resource "aws_security_group" ...


5.modules/monitoring/

Creates:
CloudWatch Log Group
Alarm for ASG metrics

resource "aws_cloudwatch_metric_alarm" ...
resource "aws_cloudwatch_log_group" ...

$$Secrets Management:

DB credentials stored securely in Secrets Manager
Retrieved using:
jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["username"]


$$How to Run Locally:
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan


$$Jenkins Pipelines:
Apply Pipeline (Jenkinsfile)
Runs on push or manually
Prompts approval before:: terraform apply

Destroy Pipeline (Jenkinsfile-destroy)
Manually triggered pipeline
Runs terraform destroy -auto-approve


Clean Up Resources:
terraform destroy -auto-approve

$$Important point:
ALB is internal-facing (not public)
Everything is modular & reusable
RDS secrets are auto-generated and securely handled
Jenkins installed in London region EC2
Infra deployed in us-east-1
