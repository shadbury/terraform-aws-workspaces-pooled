locals {
  common_alarms = {
    evaluation_periods  = 3
    metric_name         = var.scaling_settings.percentage_type ? "UserSessionsCapacityUtilization" : "AvailableUserSessionCapacity"
    namespace           = "AWS/WorkSpaces"
    statistic           = "Average"
    period              = 120
    dimensions = {
      "WorkSpaces pool ID" = data.aws_cloudformation_stack.workspaces_pooled.outputs["PoolId"]
    }
  }

  cloudwatch_alarms = [
    {
      alarm_name          = "workspaces_scale_out"
      comparison_operator = "GreaterThanThreshold"
      threshold           = var.scaling_settings.scale_out_threshold
      alarm_description   = "Scale up WorkSpaces when the number of unused WorkSpaces exceeds ${var.scaling_settings.scale_out_threshold}."
      alarm_actions       = [aws_appautoscaling_policy.workspaces_scaling_policy_up[0].arn]
    },
    {
      alarm_name          = "workspaces_scale_in"
      comparison_operator = "LessThanThreshold"
      threshold           = var.scaling_settings.scale_in_threshold
      alarm_description   = "Scale down WorkSpaces when the number of unused WorkSpaces is below ${var.scaling_settings.scale_in_threshold}."
      alarm_actions       = [aws_appautoscaling_policy.workspaces_scaling_policy_down[0].arn]
    }
  ]
}

resource "aws_cloudwatch_metric_alarm" "scaling_alarm" {
  count = length(local.cloudwatch_alarms)

  alarm_name          = local.cloudwatch_alarms[count.index].alarm_name
  comparison_operator = local.cloudwatch_alarms[count.index].comparison_operator
  evaluation_periods  = local.common_alarms.evaluation_periods
  metric_name         = local.common_alarms.metric_name
  namespace           = local.common_alarms.namespace
  period              = local.common_alarms.period
  statistic           = local.common_alarms.statistic
  threshold           = local.cloudwatch_alarms[count.index].threshold
  dimensions          = local.common_alarms.dimensions
  alarm_description   = local.cloudwatch_alarms[count.index].alarm_description
  alarm_actions       = local.cloudwatch_alarms[count.index].alarm_actions
  actions_enabled     = true
}
