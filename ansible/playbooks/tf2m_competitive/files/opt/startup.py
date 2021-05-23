#! /usr/bin/python3.8

"""
TODO Install Xenforo DB Config for SM and SP

Expected Secrets (SSM Parameters):
    - logstf_api_key
    - demostf_api_key
    - discord_api_key
    - tf2m_site_connection_str
    - tf2m_bot_connection_str

Expected Tags:
    - discord_message_id
    - discord_channel_id
    - server_password
    - spectate_password
    - request_id
    - location
"""

import boto3
import os
import requests
import subprocess
import json
from urllib.parse import urlparse

import vdf

TF2_SECRETS_FILE = "/usr/games/steam/tf2/tf/cfg/secrets.cfg"
DB_CONFIG_FILE = "/usr/games/steam/tf2/tf/addons/sourcemod/configs/databases.cfg"

SECRETS_FILE = "/opt/secrets.json"
TAGS_FILE = "/opt/tags.json"

# Get Region Info
response = requests.get("http://169.254.169.254/latest/meta-data/placement/availability-zone")
region_name = response.text[:-1]

# Get instance object
response = requests.get("http://169.254.169.254/latest/meta-data/instance-id")
ec2 = boto3.resource("ec2", region_name=region_name)
instance = ec2.Instance(response.text)

# Put tags into file
with open(TAGS_FILE, "w") as file:
    tags = {tag['Key']: tag['Value'] for tag in instance.tags}
    tags['launch_time'] = int(instance.launch_time.timestamp())
    file.write(json.dumps(tags, indent=4))

subprocess.run(["/bin/chown", "steam:steam", TAGS_FILE], check=True)
subprocess.run(["/usr/bin/chattr", "-i", TAGS_FILE], check=True)

# Get secrets
ssm = boto3.client('ssm', region_name=region_name)
response = ssm.get_parameters(
    Names=[
        "demostf_api_key",
        "logstf_api_key",
        "discord_api_key",
        "tf2m_site_connection_str",
        "tf2m_bot_connection_str"
    ]
)
secrets = response['Parameters']
secrets = {secret['Name']: secret['Value'] for secret in secrets}

# Put secrets
with open(TF2_SECRETS_FILE, "w") as file:
    file.write(f"logstf_apikey \"{secrets['logstf_api_key']}\"\n")
    file.write(f"logstf_api_key \"{secrets['logstf_api_key']}\"\n")
    file.write(f"demostf_api_key \"{secrets['demostf_api_key']}\"\n")
    file.write(f"sm_demostf_apikey \"{secrets['demostf_api_key']}\"\n")
    file.write(f"discord_api_key \"{secrets['discord_api_key']}\"\n")
    file.write(f"discord_message_id \"{tags['discord_message_id']}\"\n")
    file.write(f"discord_channel_id \"{tags['discord_channel_id']}\"\n")
    file.write(f"sv_password \"{tags['server_password']}\"\n")
    file.write(f"tv_password \"{tags['spectate_password']}\"\n")
    file.write(f"hostname \"TF2Maps.net | {tags['location']} | Comp-{tags['request_id']}\"\n")

with open(SECRETS_FILE, "w") as file:
    file.write(json.dumps(secrets, indent=4))

# Setup DB Configs
with open(DB_CONFIG_FILE) as file:
    db_config = vdf.load(file)

db_info = urlparse(secrets['tf2m_site_connection_str'])
db_config['Databases']['xenforo'] = {
    "driver": "default",
    "host": db_info.hostname,
    "user": db_info.username,
    "pass": db_info.password,
    "port": db_info.port,
    "database": db_info.path.replace("/", "")
}
db_info = urlparse(secrets['tf2m_bot_connection_str'])
db_config['Databases']['bot'] = {
    "driver": "default",
    "host": db_info.hostname,
    "user": db_info.username,
    "pass": db_info.password,
    "port": db_info.port,
    "database": db_info.path.replace("/", "")
}

with open(DB_CONFIG_FILE, "w") as file:
    vdf.dump(db_config, file, pretty=True)

# Set instance hostname
subprocess.run(["/usr/bin/hostnamectl", "set-hostname", f"{tags['Name']}"], check=True)
