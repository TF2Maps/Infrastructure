resource "aws_ssm_parameter" "logstf_api_key" {
    name  = "logstf_api_key"
    type  = "String"
    value = var.logstf_api_key
    overwrite = true
}
resource "aws_ssm_parameter" "demostf_api_key" {
    name  = "demostf_api_key"
    type  = "String"
    value = var.demostf_api_key
    overwrite = true
}
resource "aws_ssm_parameter" "discord_api_key" {
    name  = "discord_api_key"
    type  = "String"
    value = var.discord_api_key
    overwrite = true
}
resource "aws_ssm_parameter" "tf2m_site_connection_str" {
    name  = "tf2m_site_connection_str"
    type  = "String"
    value = var.tf2m_site_connection_str
    overwrite = true
}
resource "aws_ssm_parameter" "tf2m_bot_connection_str" {
    name  = "tf2m_bot_connection_str"
    type  = "String"
    value = var.tf2m_bot_connection_str
    overwrite = true
}