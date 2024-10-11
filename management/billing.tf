
resource "aws_sns_topic" "billing_alert" {
  name = var.sns_topic_name

  tags = {
    Purpose = "BillingAlerts"
  }
}

resource "aws_sns_topic_policy" "account_billing_alarm_policy" {
  arn    = aws_sns_topic.billing_alert.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {

  statement {
    sid    = "AWSBudgetsSNS"
    effect = "Allow"

    actions = [
      "SNS:Receive",
      "SNS:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.billing_alert.arn
    ]
  }
}

resource "aws_budgets_budget" "total_charges" {
  count        = length(var.alert_thresholds)
  name         = "budget-monthly-${var.alert_thresholds[count.index]}"
  budget_type  = "COST"
  limit_amount = var.alert_thresholds[count.index]
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = var.alert_thresholds[count.index]
    threshold_type      = "PERCENTAGE"
    notification_type   = "FORECASTED"
    subscriber_sns_topic_arns = [
      aws_sns_topic.billing_alert.arn
    ]
  }
  depends_on = [
    aws_sns_topic.billing_alert
  ]
  tags = {
    Purpose = "BillingAlerts"
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