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
    app_settings_persistence = "ENABLED"
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

