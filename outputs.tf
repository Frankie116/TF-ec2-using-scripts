output this-public-dns-name {
  description = "Public DNS name of load balancer"
  value       = module.my-elb.this_elb_dns_name
}

output this-vpc-arn {
  description = "ARN of the vpc"
  value       = module.my-vpc.vpc_arn
}

output these-instance-ids {
  description = "IDs of EC2 instances"
  value       = [aws_instance.my-server.*.id]
}

