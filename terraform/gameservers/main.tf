terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
    }
}

variable "vpc_cidr" {
    type = string
}

variable "ssh_keyname" {
    type = string
    default = "bastion"
}

variable "security_group_ids" {
    type = list
    default = []
}

variable "logstf_api_key" {
    type = string
}
variable "demostf_api_key" {
    type = string
}
variable "discord_api_key" {
    type = string
}
variable "tf2m_site_connection_str" {
    type = string
}
variable "tf2m_bot_connection_str" {
    type = string
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
    state = "available"
}
