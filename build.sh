#! /bin/bash

export PLAYBOOK=$1

export ANSIBLE_FORCE_COLOR=0
export ANSIBLE_NOCOLOR=1

./packer.exe build -color=false -var playbook="$PLAYBOOK" -var aws_access_key_id=$AWS_ACCESS_KEY_ID -var aws_secret_access_key=$AWS_SECRET_ACCESS_KEY packer.pkr.hcl
