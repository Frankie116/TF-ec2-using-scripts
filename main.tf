# ---------------------------------------------------------------------------------------------------
# Project:  lab038-jenkins-cluster
# Author:   Frank Effrim-Botchey
# Purpuse:  Create a jenkins cluster behind an elb that is accessed by a registered route53 dns name
#           Provide SSH access, autoscaling, cloudwatch monitoring and alerting via sns msgs.
# ---------------------------------------------------------------------------------------------------

terraform {
  required_version       = ">= 0.13.0"
  required_providers {
    aws                  = {
      source             = "hashicorp/aws"
      version            = "2.69.0"
    }
  }
}

provider "aws" {
  region                 = var.my-region
}

locals {
  ami-mapping            = {
    true                 = aws_ami.my-snapshot-ami.id
    false                = data.aws_ami.amazon_linux.id, 
    }
  instance-count         = var.my-instances-per-subnet * length(module.my-vpc.private_subnets)
}

data "aws_availability_zones" "available" {
  state                  = "available"
}

module "my-vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "2.44.0"
  cidr                   = var.my-vpc-cidr-block
  azs                    = data.aws_availability_zones.available.names
  private_subnets        = slice(var.my-priv-subnet-cidr-blocks, 0, var.my-priv-subnets-per-vpc)
  public_subnets         = slice(var.my-pub-subnet-cidr-blocks, 0, var.my-pub-subnets-per-vpc)
  enable_nat_gateway     = true
  enable_vpn_gateway     = false
}

module "my-security-group" {
  source                 = "terraform-aws-modules/security-group/aws//modules/web"
  version                = "3.12.0"
  name                   = "${var.my-project-name}-my-server-sg-${var.my-environment}"
  description            = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id                 = module.my-vpc.vpc_id
  ingress_cidr_blocks    = module.my-vpc.public_subnets_cidr_blocks
}

module "my-lb-security-group" {
  source                 = "terraform-aws-modules/security-group/aws//modules/web"
  version                = "3.12.0"
  name                   = "${var.my-project-name}-my-lb-sg-${var.my-environment}"
  description            = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id                 = module.my-vpc.vpc_id
  ingress_cidr_blocks    = ["0.0.0.0/0"]
}

resource "random_string" "my-random-string" {
  length                 = 4
  special                = false
}

data "template_file" "my-user-data" {
  template               = file(var.my-scriptfile)
  vars                   = {
    my-scriptfile        = var.my-scriptfile
  }
}

resource "aws_instance" "my-server" {
  count                  = local.instance-count
  ami                    = lookup(local.ami-mapping, var.use-snapshot, "This option should never get chosen")
  instance_type          = var.my-instance-type
  subnet_id              = module.my-vpc.private_subnets[count.index % length(module.my-vpc.private_subnets)]
  vpc_security_group_ids = [module.my-security-group.this_security_group_id]
  user_data              = data.template_file.my-user-data.rendered
  tags = {
    Name                 = "${var.my-servername}-0${count.index+1}" 
    Terraform            = "true"
    Project              = var.my-project-name
    Environment          = var.my-environment
  }
}
 