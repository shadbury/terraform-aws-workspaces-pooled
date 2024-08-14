resource "aws_cloudformation_stack" "workspaces_pooled" {
  name = var.workspaces_pooled_settings.pool_name

  template_body = jsonencode({
    "Resources": {
      "WorkspacesPool": {
        "Type": "AWS::WorkSpaces::WorkspacesPool",
        "Properties": {
          "ApplicationSettings": {
            "SettingsGroup": aws_s3_bucket.s3.id,
            "Status": "ENABLED"
          },
          "BundleId": var.workspaces_pooled_settings.bundle_id,
          "Capacity": {
            "DesiredUserSessions": var.workspaces_pooled_settings.desired_user_sessions
          },
          "Description": var.workspaces_pooled_settings.description,
          "DirectoryId": var.directory_id,
          "PoolName": var.workspaces_pooled_settings.pool_name,
          "TimeoutSettings": {
            "DisconnectTimeoutInSeconds": var.timeout_settings.disconnect_timeout_in_seconds,
            "IdleDisconnectTimeoutInSeconds": var.timeout_settings.idle_disconnect_timeout_in_seconds,
            "MaxUserDurationInSeconds": var.timeout_settings.max_user_duration_in_seconds
          }
        }
      }
    },
    "Outputs": {
      "PoolId": {
        "Value": {
          "Ref": "WorkspacesPool"
        }
      }
    }
  })
}