
# ----------------------
# Global Infra
# ----------------------
provider "aws" {
    region = "us-east-2"
}

data "aws_ssm_parameter" "logstf_api_key" {
    name  = "logstf_api_key"
}
data "aws_ssm_parameter" "demostf_api_key" {
    name  = "demostf_api_key"
}
data "aws_ssm_parameter" "discord_api_key" {
    name  = "discord_api_key"
}
data "aws_ssm_parameter" "tf2m_site_connection_str" {
    name  = "tf2m_site_connection_str"
}
data "aws_ssm_parameter" "tf2m_bot_connection_str" {
    name  = "tf2m_bot_connection_str"
}


# ----------------------
# US East 2 - Ohio
# ----------------------
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

    # Secrets
    logstf_api_key = data.aws_ssm_parameter.logstf_api_key.value
    demostf_api_key = data.aws_ssm_parameter.demostf_api_key.value
    discord_api_key = data.aws_ssm_parameter.discord_api_key.value
    tf2m_site_connection_str = data.aws_ssm_parameter.tf2m_site_connection_str.value
    tf2m_bot_connection_str = data.aws_ssm_parameter.tf2m_bot_connection_str.value
}

# ----------------------
# US East 1 - Virginia
# ----------------------
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

    # Secrets
    logstf_api_key = data.aws_ssm_parameter.logstf_api_key.value
    demostf_api_key = data.aws_ssm_parameter.demostf_api_key.value
    discord_api_key = data.aws_ssm_parameter.discord_api_key.value
    tf2m_site_connection_str = data.aws_ssm_parameter.tf2m_site_connection_str.value
    tf2m_bot_connection_str = data.aws_ssm_parameter.tf2m_bot_connection_str.value
}

# ----------------------
# EU Central 1 - Frankfurt
# ----------------------
provider "aws" {
    alias = "eu-central-1"
    region = "eu-central-1"
}

module "gameservers-eu-central-1" {
    source = "./gameservers"
    providers = {
        aws = aws.eu-central-1
    }

    vpc_cidr = "10.12.0.0/16"

    # Secrets
    logstf_api_key = data.aws_ssm_parameter.logstf_api_key.value
    demostf_api_key = data.aws_ssm_parameter.demostf_api_key.value
    discord_api_key = data.aws_ssm_parameter.discord_api_key.value
    tf2m_site_connection_str = data.aws_ssm_parameter.tf2m_site_connection_str.value
    tf2m_bot_connection_str = data.aws_ssm_parameter.tf2m_bot_connection_str.value
}
