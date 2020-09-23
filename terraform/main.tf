provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "k8s-vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.k8s-vpc.id
  cidr_block = "10.0.${10+count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.k8s-vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.k8s-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = length(var.networks)
  subnet_id     = aws_subnet.subnets.*.id[count.index]
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route53_zone" "domain" {
  name = var.domain_name
  vpc {
    vpc_id = aws_vpc.k8s-vpc.id
  }
}