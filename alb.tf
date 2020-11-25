
resource "aws_lb" "my-alb" {
  name                       = "my-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [module.my-lb-security-group.this_security_group_id]
  subnets                    = module.my-vpc.public_subnets
  tags                       = {
    Terraform                = "true"
    Project                  = var.my-project-name
    Environment              = var.my-environment
  }
}

resource "aws_lb_target_group" "my-alb-target-group" {
  name                       = "my-alb-target-group"
  port                       = 8080
  protocol                   = "HTTP"
  vpc_id                     = module.my-vpc.vpc_id
  tags                       = {
    Terraform                = "true"
    Project                  = var.my-project-name
    Environment              = var.my-environment
  }
}

resource "aws_lb_target_group_attachment" "my-alb-attachment" {
  count                      = local.instance-count
  target_group_arn           = aws_lb_target_group.my-alb-target-group.arn
  target_id                  = aws_instance.my-server[count.index].id
#   port                =     80
}

resource "aws_lb_listener" "my-alb-listener-http" {
  load_balancer_arn          = aws_lb.my-alb.arn
  port                       = 80
  protocol                   = "HTTP"

  default_action {
    type                     = "forward"
    target_group_arn         = aws_lb_target_group.my-alb-target-group.arn
  }
}

resource "aws_lb_listener" "my-alb-listener-8080" {
  load_balancer_arn          = aws_lb.my-alb.arn
  port                       = 8080
  protocol                   = "HTTP"

  default_action {
    type                     = "forward"
    target_group_arn         = aws_lb_target_group.my-alb-target-group.arn
  }
}







