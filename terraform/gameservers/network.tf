locals {
    subnets = {
        for i, v in data.aws_availability_zones.available.names :
        v => cidrsubnet(var.vpc_cidr, 8, i)
    }
}

resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "gameservers-${data.aws_region.current.name}"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "gameservers-${data.aws_region.current.name}"
    }
}

resource "aws_route_table" "this" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }
}

resource "aws_subnet" "this" {
    for_each = local.subnets

    availability_zone = each.key
    vpc_id = aws_vpc.this.id
    cidr_block = each.value
    map_public_ip_on_launch  = true

    tags = {
        Name = "gameservers-${each.key}"
        AvailabilityZone = each.key
    }
}

resource "aws_route_table_association" "this" {
    for_each = local.subnets
    subnet_id = aws_subnet.this[each.key].id
    route_table_id = aws_route_table.this.id
}

resource "aws_network_acl" "this" {
    vpc_id = aws_vpc.this.id
    subnet_ids = [ for i in aws_subnet.this: i.id ]

    ingress {
        protocol = "tcp"
        rule_no = 999
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
    egress {
        protocol = "tcp"
        rule_no = 999
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 65535
    }
}


output "subnets" {
    value = local.subnets
}

output "vpc_id" {
    value = aws_vpc.this.id
}
