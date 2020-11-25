# ---------------------------------------------------------------------------------------------------
# Project:  lab038-jenkins-cluster
# Author:   Frank Effrim-Botchey
# ---------------------------------------------------------------------------------------------------

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