data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_cloudformation_stack" "workspaces_pooled" {
  name = var.workspaces_pooled_settings.pool_name

  depends_on = [aws_cloudformation_stack.workspaces_pooled]
}
