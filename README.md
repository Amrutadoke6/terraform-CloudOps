AWS CloudOps Infrastructure with Terraform + Jenkins CI/CD

This project automates the provisioning and destruction of AWS infrastructure using Terraform modules and a Jenkins-based CI/CD pipeline.


CI Pipeline → `terraform apply`  

Destroy Pipeline → `terraform destroy`  

Modular Code with Reusable Terraform Modules



$Final Directory Structure

terraform-CloudOps/

1.backend.tf # Remote backend config (S3 + DynamoDB)

2.main.tf # Root file connecting all modules

3.providers.tf # AWS provider config

4.terraform.tfvars # User-defined variable values

5.variables.tf # Input variables for root module

6.outputs.tf # Root output values

7.Jenkinsfile # CI pipeline to deploy infrastructure

8.Jenkinsfile-destroy # CI pipeline to destroy infrastructure

9.scripts/bootstrap.ps1 # Windows IIS setup script


10.modules/


vpc/ # Custom VPC module

 1.main.tf

 2.variables.tf

 3.outputs.tf


compute/ # Launch Template + ASG + ALB

 1.main.tf

 2.variables.tf

 3.outputs.tf

rds/ # RDS SQL Server + Secrets Manager

  1.main.tf

  2.variables.tf

  3.outputs.tf



security/ # IAM roles, SSM, security groups

  1.main.tf

  2.ec2_read_secret.tf

  3. ssm_secrets.tf

  4. outputs.tf



 monitoring/ # CloudWatch log group and alarms

  1.main.tf

  2.riables.tf

  3.outputs.tf





What Each File/Module Does

Root Files

1.main.tf — Connects all modules like VPC, compute, RDS, security, monitoring

2.backend.tf— Stores Terraform state in S3, locks state via DynamoDB

3.terraform.tfvars — Sets values for variables like project name, db_user, db_pass

4.variables.tf — Declares inputs required for the root module

5.Jenkinsfile — Runs `terraform init`, `validate`, `plan`, and `apply`

6.Jenkinsfile-destroy — Automates `terraform destroy` for safe teardown



 1.modules/vpc/

-Creates a private network with:

- Public & Private subnets

- NAT Gateway + Internet Gateway

- Route Tables


resource "aws_vpc" 

resource "aws_subnet" 

resource "aws_nat_gateway" 



2. modules/compute/


Launches EC2 Windows IIS in private subnet using:

Launch Template with user_data (PowerShell)

Auto Scaling Group (2 instances)

Internal ALB to distribute traffic



resource "aws_db_instance" 

resource "aws_secretsmanager_secret" 




3.modules/rds/


Deploys SQL Server instance with:

Private subnet group


Secrets Manager storing credentials

Encrypted storage


resource "aws_db_instance" 

resource "aws_secretsmanager_secret" 




4.  modules/security/


IAM and Security Groups:

EC2 IAM role with SSM + SecretsManager permissions

Security groups for EC2, ALB, RDS

Instance profile


resource "aws_iam_role" 

resource "aws_security_group" 



5.modules/monitoring/

Creates:

CloudWatch Log Group

Alarm for ASG metrics

resource "aws_cloudwatch_metric_alarm" 

resource "aws_cloudwatch_log_group" 



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


$$Clean Up Resources:

terraform destroy -auto-approve



$$Important point:

ALB is internal-facing (not public)


Everything is modular & reusable


RDS secrets are auto-generated and securely handled


Jenkins installed in London region EC2

Infra deployed in us-east-1
