# AWS WorkSpaces Pooled Module

## Overview

This Terraform module provisions an AWS WorkSpaces environment with pooled directory settings. It includes resources for:
- AWS WorkSpaces Pool
- Auto Scaling policies
- CloudWatch alarms
- Security groups
- S3 buckets for application settings persistence
- IAM roles and policies for SAML authentication

## Prerequisites

Before using this module, ensure you have:
1. Workspaces Pooled Directory set up in AWS.
2. SAML authentication configured for WorkSpaces pooled directory.
3. SAML metadata file downloaded to your local machine.

## Manual Steps

### 1. Create the WorkSpaces Pooled Directory

You need to manually create the WorkSpaces pooled directory. Follow the instructions in the AWS documentation to set up SAML for WorkSpaces:

[Create and configure a directory for WorkSpaces pooled environment](https://docs.aws.amazon.com/workspaces/latest/adminguide/create-directory-pools.html#saml-directory-create-wsp-pools-directory)

### 2. Set Up SAML Authentication

1. [Create and configure SAML to for use with workspaces pooled](https://docs.aws.amazon.com/workspaces/latest/adminguide/create-directory-pools.html#saml-directory-create-assertions)

2. Download the SAML metadata file and save it to your local machine.

3. Use the SAML metadata file as an input variable for the module.


## Usage

```hcl
module "workspaces_pooled" {
  source  = "shadbury/workspaces-pooled/aws"
  version = "x.y.z"

  vpc_id                    = "vpc-xxxxxx"
  subnet_ids                = ["subnet-xxxxxx", "subnet-yyyyyy"]
  directory_id              = "wsd-xxxxxx"
  saml_xml                  = file("path/to/your/saml_metadata.xml")
  
  workspaces_pooled_settings = {
    bundle_id                = "wsb-xxxxxx"
    desired_user_sessions    = 2
    description              = "Pooled WorkSpaces"
    pool_name                = "MyWorkspacesPooled"
  }

  timeout_settings = {
    disconnect_timeout_in_seconds      = 3600
    idle_disconnect_timeout_in_seconds = 1800
    max_user_duration_in_seconds       = 7200
  }

  scaling_settings = {
    percentage_type          = true
    maximum_capacity         = 10
    minimum_capacity         = 1
    increment                = 1
    decrement                = 1
    scale_out_threshold      = 80
    scale_in_threshold       = 20
  }

  security_group = {
    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.workspaces_scaling_policy_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.workspaces_scaling_policy_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.workspaces_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudformation_stack.workspaces_pooled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_cloudwatch_metric_alarm.scaling_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.workspaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.workspaces_saml](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.workspaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_saml_provider.workspaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.workspace_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.workspace_sg_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workspace_sg_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudformation_stack.workspaces_pooled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudformation_stack) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_directory_id"></a> [directory\_id](#input\_directory\_id) | The ID of the directory for WorkSpaces. | `string` | n/a | yes |
| <a name="input_saml_xml"></a> [saml\_xml](#input\_saml\_xml) | The SAML XML configuration for SAML authentication. | `string` | n/a | yes |
| <a name="input_scaling_settings"></a> [scaling\_settings](#input\_scaling\_settings) | Settings for scaling policies. | <pre>object({<br>    percentage_type     = bool<br>    maximum_capacity    = number<br>    minimum_capacity    = number<br>    increment           = number<br>    decrement           = number<br>    scale_out_threshold = number<br>    scale_in_threshold  = number<br>  })</pre> | n/a | yes |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Security group configuration for inbound and outbound traffic. | <pre>object({<br>    ingress = list(object({<br>      from_port   = number<br>      to_port     = number<br>      protocol    = string<br>      cidr_blocks = list(string)<br>    }))<br>    egress = list(object({<br>      from_port   = number<br>      to_port     = number<br>      protocol    = string<br>      cidr_blocks = list(string)<br>    }))<br>  })</pre> | <pre>{<br>  "egress": [<br>    {<br>      "cidr_blocks": [<br>        "0.0.0.0/0"<br>      ],<br>      "from_port": 0,<br>      "protocol": "-1",<br>      "to_port": 0<br>    }<br>  ],<br>  "ingress": [<br>    {<br>      "cidr_blocks": [<br>        "0.0.0.0/0"<br>      ],<br>      "from_port": 80,<br>      "protocol": "tcp",<br>      "to_port": 80<br>    },<br>    {<br>      "cidr_blocks": [<br>        "0.0.0.0/0"<br>      ],<br>      "from_port": 443,<br>      "protocol": "tcp",<br>      "to_port": 443<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs where resources will be deployed. | `list(string)` | n/a | yes |
| <a name="input_timeout_settings"></a> [timeout\_settings](#input\_timeout\_settings) | Timeout settings for WorkSpaces. | <pre>object({<br>    disconnect_timeout_in_seconds      = number<br>    idle_disconnect_timeout_in_seconds = number<br>    max_user_duration_in_seconds       = number<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where resources are deployed. | `string` | n/a | yes |
| <a name="input_workspaces_pooled_settings"></a> [workspaces\_pooled\_settings](#input\_workspaces\_pooled\_settings) | Configuration settings for WorkSpaces pooled environment. | <pre>object({<br>    bundle_id             = string<br>    desired_user_sessions = number<br>    description           = string<br>    pool_name             = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->