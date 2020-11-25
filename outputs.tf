output this-public-dns-name {
  description = "Public DNS name of load balancer"
  value       = aws_lb.my-alb.dns_name
}

output this-vpc-arn {
  description = "ARN of the vpc"
  value       = module.my-vpc.vpc_arn
}

output these-instance-ids {
  description = "IDs of EC2 instances"
  value       = [aws_instance.my-server.*.id]
}

