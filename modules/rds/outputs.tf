output "rds_endpoint" {
  value = aws_db_instance.sql.endpoint
}

output "rds_identifier" {
  value = aws_db_instance.sql.id
}

output "rds_secret_arn" {
  value = aws_secretsmanager_secret.rds.arn
}

