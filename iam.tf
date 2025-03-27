resource "aws_iam_saml_provider" "workspaces" {
  name                   = "${var.workspaces_pooled_settings.pool_name}-saml-provider-${data.aws_region.current.name}"
  saml_metadata_document = var.saml_xml

  tags = {
    Name = "${var.workspaces_pooled_settings.pool_name}-saml-provider-${data.aws_region.current.name}"
  }
}

resource "aws_iam_role" "workspaces_saml" {
  name = "${var.workspaces_pooled_settings.pool_name}-saml-role-${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = ["sts:AssumeRoleWithSAML", "sts:TagSession"]
        Principal = { Federated = aws_iam_saml_provider.workspaces.arn }
        Condition = { StringEquals = { "SAML:aud" = "https://signin.aws.amazon.com/saml" } }
      }
    ]
  })

  tags = {
    Name = "${var.workspaces_pooled_settings.pool_name}-saml-role-${data.aws_region.current.name}"
  }
}

resource "aws_iam_policy" "workspaces" {
  name        = "${var.workspaces_pooled_settings.pool_name}-workspaces-policy-${data.aws_region.current.name}"
  description = "Policy for WorkSpaces access in ${data.aws_region.current.name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "workspaces:Stream"
        Resource = "arn:aws:workspaces:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:directory/${var.directory_id}"
        Condition = {
          StringEquals = { "workspaces:userId" = "$${saml:sub}" }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "workspaces" {
  role       = aws_iam_role.workspaces_saml.name
  policy_arn = aws_iam_policy.workspaces.arn
}