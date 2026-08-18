resource "aws_instance" "vm" {
  ami                    = var.ami_id
  instance_type          = var.inst_type
  key_name               = var.key_pair
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  user_data              = <<-EOF
     #!/bin/bash
     sudo -i
     yum install httpd -y
     systemctl start httpd
     echo "Infra As a Code" > /var/www/html/index.html
    EOF
  tags = {
    Name = "TF-Server"
  }
}
