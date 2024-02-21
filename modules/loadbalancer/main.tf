resource "aws_lb_target_group" "home-tg" {
  name     = "${var.project}-home-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = {
    Env = var.env
  }
  health_check {
    path = "/"
  }
}
 
 resource "aws_lb_target_group" "laptop-tg" {
  name     = "${var.project}-laptop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = {
    Env = var.env
  }
  health_check {
    path = "/laptop/"
  }
}
 
 resource "aws_lb_target_group" "mobile-tg" {
  name     = "${var.project}-mobile-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = {
    Env = var.env
  }
  health_check {
    path = "/mobile/"
  }
}
  
  resource "aws_lb" "my-lb" {
  name               = "${var.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
  tags = {
    Env = var.env
  }
}
 
 resource "aws_lb_listener" "home-listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home-tg.arn
  }
}

resource  "aws_lb_listener_rule" "laptop-listener" {
  listener_arn = aws_lb_listener.home-listener.arn
  priority     = 101

  condition {
    path_pattern {
      values = ["/laptop*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.laptop-tg.arn
  }
}

resource  "aws_lb_listener_rule" "mobile-listener" {
  listener_arn = aws_lb_listener.home-listener.arn
  priority     = 102

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile-tg.arn
  }
}  

resource "aws_autoscaling_attachment" "home-asg-attach" {
  autoscaling_group_name = var.autoscaling_group_name_home
  lb_target_group_arn    = aws_lb_target_group.home-tg.arn
}

resource "aws_autoscaling_attachment" "laptop-asg-attach" {
  autoscaling_group_name = var.autoscaling_group_name_laptop
  lb_target_group_arn    = aws_lb_target_group.laptop-tg.arn
} 

resource "aws_autoscaling_attachment" "mobile-asg-attach" {
  autoscaling_group_name = var.autoscaling_group_name_mobile
  lb_target_group_arn    = aws_lb_target_group.mobile-tg.arn
}  