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



resource "random_string" "my-random-string" {
  length                 = 4
  special                = false
}



 