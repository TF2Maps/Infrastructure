variable "playbook" {
    type = string
}
variable "aws_access_key_id" {
    type = string
}
variable "aws_secret_access_key" {
    type = string
}



locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
    # Find the Ubuntu base AMI
    source_ami_filter {
        filters = {
            name: "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*",
            # name = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-20201026"
            root-device-type = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners = ["099720109477"]
    }
    region = "us-east-2"

    # Launch options
    instance_type = "t3a.medium"
    launch_block_device_mappings {
        delete_on_termination = true
        device_name = "/dev/sda1"
        volume_size = 20
        volume_type = "gp2"
    }
    run_tags = {
        Name = "Packer Builder - ${var.playbook}"
    }

    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key

    # SSH Setup
    communicator = "ssh"
    ssh_username = "ubuntu"
    ssh_clear_authorized_keys = true

    # Output settings
    ena_support = true
    ami_name = "${var.playbook}-${local.timestamp}"
    tags = {
        Family = var.playbook
        SourceAMI = "{{ .SourceAMI }}"
    }

    # Copy AMI to multiple regions
    ami_regions = [
        "us-east-1",
        "us-east-2",
        "us-west-1",
        "us-west-2",
        "eu-central-1"
    ]
}

build {
    sources = ["source.amazon-ebs.ubuntu"]

    provisioner "shell" {
        inline = [
            "sudo apt-get install --yes software-properties-common",
            "sudo apt-add-repository --yes ppa:ansible/ansible",
            "sudo apt-get update",
            "sudo apt-get install --yes ansible"
        ]
    }

    provisioner "file" {
        source = "./ansible.cfg"
        destination = "/tmp/ansible.cfg"
    }

    provisioner "shell" {
        inline = [
            "sudo mv /tmp/ansible.cfg /etc/ansible/ansible.cfg &&",
            "sudo chown root:root /etc/ansible/ansible.cfg"
        ]
    }

    provisioner "ansible-local" {
        clean_staging_directory = "true"
        playbook_dir = "./ansible/playbooks/${var.playbook}"
        playbook_file = "./ansible/playbooks/${var.playbook}/main.yml"
        role_paths = [
            "./ansible/roles/srcds",
            "./ansible/roles/firewall",
            "./ansible/roles/monitoring",
            "./ansible/roles/security",
            "./ansible/roles/utils"
        ]
    }

    provisioner "shell" {
        inline = ["sudo rm -rf /tmp/*"]
    }

    post-processor "shell-local" {
        command = "cd terraform & terraform.exe apply -auto-approve"
    }
}
