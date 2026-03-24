resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${local.name_prefix}-alb-5xx"
  alarm_description   = "Alarm when ALB generates 5xx responses"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = 0
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.alarm_period_seconds
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  alarm_name          = "${local.name_prefix}-alb-target-response-time"
  alarm_description   = "Alarm when ALB target response time is too high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.alb_target_response_time_threshold
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${local.name_prefix}-alb-unhealthy-hosts"
  alarm_description   = "Alarm when target group has unhealthy hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = 0
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
    TargetGroup  = aws_lb_target_group.app.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${local.name_prefix}-rds-cpu"
  alarm_description   = "Alarm when RDS CPU utilization is too high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_cpu_threshold
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name          = "${local.name_prefix}-rds-free-storage"
  alarm_description   = "Alarm when RDS free storage is too low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.rds_free_storage_threshold_bytes
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.alarm_period_seconds
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.id
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type"   = "metric"
        "x"      = 0
        "y"      = 0
        "width"  = 12
        "height" = 6
        "properties" = {
          "title"   = "ALB Request Count"
          "view"    = "timeSeries"
          "stacked" = false
          "region"  = var.aws_region
          "metrics" = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
          "stat"   = "Sum"
          "period" = 60
        }
      },
      {
        "type"   = "metric"
        "x"      = 12
        "y"      = 0
        "width"  = 12
        "height" = 6
        "properties" = {
          "title"   = "ALB Target Response Time"
          "view"    = "timeSeries"
          "stacked" = false
          "region"  = var.aws_region
          "metrics" = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
          "stat"   = "Average"
          "period" = 60
        }
      },
      {
        "type"   = "metric"
        "x"      = 0
        "y"      = 6
        "width"  = 12
        "height" = 6
        "properties" = {
          "title"   = "Target Group Healthy / Unhealthy Hosts"
          "view"    = "timeSeries"
          "stacked" = false
          "region"  = var.aws_region
          "metrics" = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", aws_lb_target_group.app.arn_suffix, "LoadBalancer", aws_lb.app.arn_suffix],
            [".", "UnHealthyHostCount", ".", ".", ".", "."]
          ]
          "stat"   = "Average"
          "period" = 60
        }
      },
      {
        "type"   = "metric"
        "x"      = 12
        "y"      = 6
        "width"  = 12
        "height" = 6
        "properties" = {
          "title"   = "ALB 5XX Count"
          "view"    = "timeSeries"
          "stacked" = false
          "region"  = var.aws_region
          "metrics" = [
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", aws_lb.app.arn_suffix]
          ]
          "stat"   = "Sum"
          "period" = 60
        }
      },
      {
        "type"   = "metric"
        "x"      = 0
        "y"      = 12
        "width"  = 12
        "height" = 6
        "properties" = {
          "title"   = "RDS CPU Utilization"
          "view"    = "timeSeries"
          "stacked" = false
          "region"  = var.aws_region
          "metrics" = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.mysql.id]
          ]
          "stat"   = "Average"
          "period" = 60
        }
      },
      {
        "type"   = "metric"
        "x"      = 12
        "y"      = 12
        "width"  = 12
        "height" = 6
        "properties" = {
          "title"   = "RDS Free Storage Space"
          "view"    = "timeSeries"
          "stacked" = false
          "region"  = var.aws_region
          "metrics" = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", aws_db_instance.mysql.id]
          ]
          "stat"   = "Average"
          "period" = 60
        }
      }
    ]
  })
}