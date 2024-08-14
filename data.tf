data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_cloudformation_stack" "workspaces_pooled" {
  name = "workspaces-pooled"

  depends_on = [aws_cloudformation_stack.workspaces_pooled]
}
