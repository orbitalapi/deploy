resource "random_id" "hash" {
   byte_length = 8
}

# Create a VPC to launch our instances into
resource "aws_vpc" "main" {
   cidr_block           = "10.0.0.0/16"
   enable_dns_hostnames = true
   enable_dns_support   = true
}

resource "aws_internet_gateway" "main" {
   vpc_id = aws_vpc.main.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
   route_table_id         = aws_vpc.main.main_route_table_id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.main.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "subnet_1" {
   vpc_id                  = aws_vpc.main.id
   cidr_block              = "10.0.2.0/24"
   map_public_ip_on_launch = true
   availability_zone       = var.az
}

# Create a subnet to launch our instances into
resource "aws_subnet" "subnet_2" {
   vpc_id                  = aws_vpc.main.id
   cidr_block              = "10.0.3.0/24"
   map_public_ip_on_launch = true
   availability_zone       = var.az2
}

resource "aws_security_group" "main" {
   name   = "${var.system_name}-${var.environment}-${random_id.hash.hex}"
   vpc_id = aws_vpc.main.id

   # Needed for HTTPS redirection
   ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [var.http_access_ip_range]
   }

   ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.http_access_ip_range]
   }

   # All ports open within the VPC
   ingress {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [
         "10.0.0.0/16"
      ]
      description = ""
   }

   # outbound internet access
   egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [
         "0.0.0.0/0"
      ]
   }

   tags = {
      Name = "${var.system_name}-external-connectivity-${random_id.hash.hex}"
   }
}

resource "aws_flow_log" "vpc_flow_log" {
   iam_role_arn    = aws_iam_role.vpc_flow_log.arn
   log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
   traffic_type    = "ALL"
   vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
   name = "vpc-flow-log-${var.system_name}-${var.environment}2"
}

resource "aws_iam_role" "vpc_flow_log" {
   name = "vpc-flow-log-${var.system_name}-${var.environment}"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log" {
   name = "vpc-flow-log-${var.system_name}-${var.environment}"
   role = aws_iam_role.vpc_flow_log.id

   policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
