resource "aws_iam_saml_provider" "workspaces_saml_provider" {
  name                   = "workspaces_saml_provider"
  saml_metadata_document = var.saml_xml
}

resource "aws_iam_role" "workspaces_saml_role" {
  name = "workspaces_saml_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = ["sts:AssumeRoleWithSAML", "sts:TagSession"]
        Principal = {
          Federated = aws_iam_saml_provider.workspaces_saml_provider.arn
        }
        Condition = {
          StringEquals = {
            "SAML:aud" = [
              "https://signin.aws.amazon.com/saml"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "workspaces_policy" {
  name        = "workspaces_policy"
  description = "Policy for Workspaces"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "workspaces:Stream"
        Resource = "arn:aws:workspaces:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:directory/${var.directory_id}"
        Condition = {
          StringEquals = {
            "workspaces:userId" = "$${saml:sub}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "workspaces_policy_attachment" {
  role       = aws_iam_role.workspaces_saml_role.name
  policy_arn = aws_iam_policy.workspaces_policy.arn
}
