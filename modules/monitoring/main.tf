resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/aws/ec2/webapp"
  retention_in_days = 7

  tags = {
    Project = var.project
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "${var.project}-ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Trigger when EC2 CPU > 80%"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Project = var.project
  }
}

