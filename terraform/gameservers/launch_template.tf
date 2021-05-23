locals {
    userdata = <<EOF
#!/bin/bash -v
/usr/bin/python3.8 /opt/startup.py
EOF

    security_group_ids = concat(
        var.security_group_ids,
        [
            aws_security_group.tf2_srcds.id
        ]
    )
}

data "aws_ami" "tf2_competitive" {
    most_recent = true

    filter {
        name   = "name"
        values = ["tf2m_competitive-*"]
    }

    owners = ["${data.aws_caller_identity.current.account_id}"]
}

resource "aws_key_pair" "bastion" {
    key_name = "bastion"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCGX6FT1sVg+Dm5aaWbOYOMLRDUeuEd4qBg8YZyWOacECMsuXo3Z5n3jEjzrXciCrlu0Y0lrzMAgCG85mKsCg/JDfU9RUaAG6Z7dL1wS1FF93+Ilk+oP/5Sq8UDb9b4S+rpqSXrWrPwjqn4GwyRmB9Up6CKJ5fF5os8YTcnz8bKg/G3JsS1dH7a/8CF5YvKKtJeA5ZdMpnnEMN/nPGTaPyhnR8igHKXPMYGkJ1wkeqjz3By6cff7wxhjjejC9X6D0H0XC0F/um0CFPg13CIkAHHc5Zr7oq5lTe5YEnwPyPPMlXIfzE7UpnvzAQNFvxl9BaNULEnj8FtB/85rrm9cprt"
}

resource "aws_launch_template" "tf2_competitive" {
    name = "tf2-competitive"

    # Provisioning
    image_id = data.aws_ami.tf2_competitive.id
    instance_type = "t3a.medium"
    key_name = var.ssh_keyname
    user_data = base64encode(local.userdata)

    # Network
    network_interfaces {
        associate_public_ip_address = true
        delete_on_termination = true
        subnet_id = values(aws_subnet.this)[0].id       # TODO How to make multi a-z?
        security_groups = local.security_group_ids
    }

    # Disk
    ebs_optimized = true
    block_device_mappings {
        device_name = "/dev/sda1"
        ebs {
            volume_size = 20
            delete_on_termination = true
        }
    }

    # Permissions
    iam_instance_profile {
        name = aws_iam_instance_profile.tf2_competitive.name
    }

    # Other
    monitoring {
        enabled = false
    }
    disable_api_termination = false
    instance_initiated_shutdown_behavior = "terminate"
}