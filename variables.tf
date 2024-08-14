variable "vpc_id" {
  description = "The ID of the VPC where resources are deployed."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where resources will be deployed."
  type        = list(string)
}

variable "directory_id" {
  description = "The ID of the directory for WorkSpaces."
  type        = string
}

variable "saml_xml" {
  description = "The SAML XML configuration for SAML authentication."
  type        = string
}

variable "workspaces_pooled_settings" {
  description = "Configuration settings for WorkSpaces pooled environment."
  type = object({
    app_settings_persistence = string
    bundle_id                = string
    desired_user_sessions    = number
    description              = string
    pool_name                = string
  })
}

variable "timeout_settings" {
  description = "Timeout settings for WorkSpaces."
  type = object({
    disconnect_timeout_in_seconds      = number
    idle_disconnect_timeout_in_seconds = number
    max_user_duration_in_seconds       = number
  })
}

variable "scaling_settings" {
  description = "Settings for scaling policies."
  type = object({
    percentage_type          = bool
    maximum_capacity         = number
    minimum_capacity         = number
    increment                = number
    decrement                = number
    scale_out_threshold      = number
    scale_in_threshold       = number
  })
}

variable "security_group" {
  description = "Security group configuration for inbound and outbound traffic."
  type = object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
  default = {
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
