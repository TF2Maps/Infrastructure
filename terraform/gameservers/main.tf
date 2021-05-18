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


data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
    state = "available"
}
