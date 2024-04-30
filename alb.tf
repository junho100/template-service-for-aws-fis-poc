module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name               = "test-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.security_group_temp.security_group_id]

  enable_deletion_protection = false

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        arn = aws_lb_target_group.test_tg.arn
      }
    }
  }

  depends_on = [aws_lb_target_group.test_tg, aws_lb_target_group_attachment.test_tg_attachment]
}

resource "aws_lb_target_group" "test_tg" {
  name     = "backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "test_tg_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id        = module.backend[count.index].id
  port             = 80
}
