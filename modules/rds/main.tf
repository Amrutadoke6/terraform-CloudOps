resource "aws_db_instance" "sql" {
  identifier             = "${var.project}-rds-sql"
  engine                 = "sqlserver-ex"
  instance_class         = "db.t3.medium"
  allocated_storage      = 20
  username               = var.db_user
  password               = var.db_pass
  license_model          = "license-included"
  storage_encrypted      = true
  multi_az               = false
  publicly_accessible    = false
  vpc_security_group_ids = [var.sg_id]
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name

}

resource "aws_secretsmanager_secret" "rds" {
  name = "${var.project}-rds-credentials-v5"
}

resource "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username = var.db_user
    password = var.db_pass
  })
}


resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

