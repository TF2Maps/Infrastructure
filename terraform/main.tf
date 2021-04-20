/*
GameServers
    Launch Template
Core Infra
    Route53 TF2Maps Zone
    VPC Network
    EC2
        Xenforo
        Discord Bot
        Feedback Site
        Maplist Site
    RDS
        Xenforo Database
    S3
        Maps + On upload do bz2 compress
        Demos
        Content pack bucket?
    Grafana + Prometheus
*/

/*
    TODO
    us-east-1-bos-1 Boston
    us-east-1-iah-1 Houston
    us-east-1-mia-1 Miami
*/
provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}
provider "aws" {
    alias = "us-east-2"
    region = "us-east-2"
}
provider "aws" {
    alias = "us-west-1"
    region = "us-west-1"
}
provider "aws" {
    alias = "us-west-2"
    region = "us-west-2"
}
provider "aws" {
    alias = "eu-central-1"
    region = "eu-central-1"
}

module "vpc-gameservers-us-east-1" {
    # Virginia
    source = "./network"
    providers = {
        aws = aws.us-east-1
    }
    vpc_cidr = "10.16.0.0/16"
}
module "vpc-gameservers-us-east-2" {
    # Ohio
    source = "./network"
    providers = {
        aws = aws.us-east-2
    }
    vpc_cidr = "10.17.0.0/16"
}
module "vpc-gameservers-us-west-1" {
    # North California
    source = "./network"
    providers = {
        aws = aws.us-west-1
    }
    vpc_cidr = "10.18.0.0/16"
}
module "vpc-gameservers-us-west-2" {
    # Oregon
    source = "./network"
    providers = {
        aws = aws.us-west-2
    }
    vpc_cidr = "10.19.0.0/16"
}
module "vpc-gameservers-eu-central-1" {
    # Frankfurt
    source = "./network"
    providers = {
        aws = aws.eu-central-1
    }
    vpc_cidr = "10.20.0.0/16"
}