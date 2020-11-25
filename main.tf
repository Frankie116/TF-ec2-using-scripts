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

data "aws_availability_zones" "my-available-azs" {
  state                  = "available"
}

module "my-vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "2.44.0"
  cidr                   = var.my-vpc-cidr-block
  azs                    = data.aws_availability_zones.my-available-azs.names
  private_subnets        = slice(var.my-priv-subnet-cidr-blocks, 0, var.my-priv-subnets-per-vpc)
  public_subnets         = slice(var.my-pub-subnet-cidr-blocks, 0, var.my-pub-subnets-per-vpc)
  enable_nat_gateway     = true
  enable_vpn_gateway     = false
}

resource "random_string" "my-random-string" {
  length                 = 4
  special                = false
}



 