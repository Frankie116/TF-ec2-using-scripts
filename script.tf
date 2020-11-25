data "template_file" "my-ec2-script" {
  template               = file(var.my-scriptfile)
  vars                   = {
    my-scriptfile        = var.my-scriptfile
  }
}