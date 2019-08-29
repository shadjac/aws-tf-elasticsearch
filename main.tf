
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

resource "aws_security_group" "elasticsearch-sg" {
  name_prefix        = "elastic-search-sg-"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.es-vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.whitelist-cidr]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.whitelist-cidr]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "template_file" "es-bootstrap-script" {
    template = "${file("${path.module}/files/init.tpl")}"
}

resource "aws_launch_configuration" "es-launch-conf" {
  name_prefix          = "es_launch_config_"
  image_id      = var.ami-id
  instance_type = "t2.medium"
  iam_instance_profile = "elasticsearch-ec2-discovery-role"
  key_name = var.aws-pem-file-name
  security_groups = ["${aws_security_group.elasticsearch-sg.id}"]
  associate_public_ip_address = true
  user_data = "${data.template_file.es-bootstrap-script.rendered}"
}

resource "aws_autoscaling_group" "es-asg" {
  name = "${aws_launch_configuration.es-launch-conf.name}_asg"
  launch_configuration = "${aws_launch_configuration.es-launch-conf.name}"
  min_size             = 1
  desired_capacity     = var.es-node-count
  max_size             = 3
  vpc_zone_identifier = ["${aws_subnet.es-subnet.id}"]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "es"
    value               = "es_node"
    propagate_at_launch = true
  }
  tag {
    key                 = "name"
    value               = "elasticsearch-node"
    propagate_at_launch = true
  }
}


