# ---------------------------------------------------------------------------------------------------
# Project:  lab038-jenkins-cluster
# Author:   Frank Effrim-Botchey
# ---------------------------------------------------------------------------------------------------


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