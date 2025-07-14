output "ec2_log_group_name" {
  value = aws_cloudwatch_log_group.ec2_log_group.name
}

output "ec2_alarm_name" {
  value = aws_cloudwatch_metric_alarm.ec2_cpu_alarm.alarm_name
}

