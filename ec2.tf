module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"
  count  = 2
  name   = "test-ec2-instance"

  ami                         = "ami-0b23bb3616e3892a6"
  instance_type               = "t2.micro"
  availability_zone           = (count.index + 1) % 2 == 0 ? "ap-northeast-2c" : "ap-northeast-2a"
  subnet_id                   = element(module.vpc.private_subnets, count.index)
  vpc_security_group_ids      = [module.security_group_temp.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false

  user_data = <<-EOF
              #!/bin/bash
                yum update -y
                yum install -y httpd.x86_64
                systemctl start httpd.service
                systemctl enable httpd.service
                echo “Hello World from $(hostname -f)” > /var/www/html/index.html
              EOF

  user_data_replace_on_change = true

  tags = {
    Ec2InstanceFailure = (count.index + 1) % 2 == 0 ? "Allowed" : "NotAllowed"
  }
}
