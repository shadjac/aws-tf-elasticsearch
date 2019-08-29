
provider "aws" {
  region     = var.region
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "es-vpc" {
  cidr_block       = var.vpc-cidr
  enable_dns_hostnames = true
  tags = {
    Name = "elasticsearch-vpc"
  }
}

resource "aws_subnet" "es-subnet" {
  vpc_id     = "${aws_vpc.es-vpc.id}"
  cidr_block = var.subnet-cidr
  availability_zone = var.availability-zone
  map_public_ip_on_launch = true
  tags = {
    Name = "elasticsearch-subnet"
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = "${aws_vpc.es-vpc.id}"

  tags = {
    Name = "elasticsearch-igw"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.es-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gw.id}"
  }
}

resource "aws_route_table_association" "rt-association" {
  subnet_id      = "${aws_subnet.es-subnet.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

