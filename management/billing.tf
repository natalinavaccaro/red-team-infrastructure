
resource "aws_sns_topic" "billing_alert" {
  name = var.sns_topic_name
  
  tags = {
    Purpose     = "BillingAlerts"
  }
}
 
resource "aws_cloudwatch_metric_alarm" "estimated_charges" {
  count               = length(var.alert_thresholds)
  alarm_name          = "estimated-charges-${var.alert_thresholds[count.index]}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = var.alert_thresholds[count.index]
  alarm_description   = "Alarm when AWS charges go above ${var.alert_thresholds[count.index]} USD"
  alarm_actions       = [aws_sns_topic.billing_alert.arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    Currency = "USD"
  }
  tags = {
    Purpose     = "BillingAlerts"
  }
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.billing_alert.arn
  protocol  = "email"
  endpoint  = var.billing_email

  depends_on = [aws_sns_topic.billing_alert]
}

# Outputs for easier management and monitoring
output "sns_topic_arn" {
  description = "The ARN of the SNS billing sns topic"
  value       = aws_sns_topic.billing_alert.arn
}

output "cloudwatch_alarm_names" {
  description = "List of names for cloudwatch alarms"
  value       = [for alarm in aws_cloudwatch_metric_alarm.estimated_charges : alarm.alarm_name]
} 