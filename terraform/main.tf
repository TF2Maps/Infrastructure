/*
    todo
    - permissions for users - read from xenforo?
    - allow one to download maps
    - add additional configs for RGL
    - s3 mirror

    TODO
    us-east-1-bos-1 Boston
    us-east-1-iah-1 Houston
    us-east-1-mia-1 Miami
*/
locals {
    tf2_competitive_ami = ""
    tf2_casual_ami = ""
    tf2_mvm_ami = ""
}


provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

module "gameservers-us-east-1" {
    source = "./gameservers"
    providers = {
        aws = aws.us-east-1
    }

    vpc_cidr = "10.10.0.0/16"
}



provider "aws" {
    alias = "us-east-2"
    region = "us-east-2"
}

module "gameservers-us-east-2" {
    source = "./gameservers"
    providers = {
        aws = aws.us-east-2
    }

    vpc_cidr = "10.11.0.0/16"
}
