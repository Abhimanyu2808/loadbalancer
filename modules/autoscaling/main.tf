resource "aws_launch_configuration" "home-template" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    name = "${var.project}-home-template"
    security_groups = [var.security_group_id]
    user_data = <<-EOF
            #!/bin/bash
            apt-get update
            apt-get install nginx -y
            service nginx start
            echo "This is HOME-PAGE" >/var/www/html/index.html
            EOF
}

resource "aws_launch_configuration" "laptop-template" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    name = "${var.project}-laptop-template"
    security_groups = [var.security_group_id]
    user_data = <<-EOF
            #!/bin/bash
            apt-get update
            apt-get install nginx -y
            service nginx start
            mkdir /var/www/html/laptop
            echo "This is LAPTOP-PAGE" >/var/www/html/laptop/index.html
            EOF
} 

resource "aws_launch_configuration" "mobile-template" {
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_pair
    name = "${var.project}-mobile-template"
    security_groups = [var.security_group_id]
    user_data = <<-EOF
            #!/bin/bash
            apt-get update
            apt-get install nginx -y
            service nginx start
             mkdir /var/www/html/mobile
            echo "This is MOBILE-PAGE" >/var/www/html/mobile/index.html
            EOF
}  

resource "aws_autoscaling_group" "as-home-gp" {
    name = "${var.project}-as-home"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    availability_zones = var.azs
    launch_configuration = aws_launch_configuration.home-template.name
    tag {
        key = "Name"
        value = "home"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "as-home-policy" {
  autoscaling_group_name = aws_autoscaling_group.as-home-gp.name
  name                   = "${var.project}-as-home-policy"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "app/terraform-lb/778d41231b141a0f/targetgroup/terraform-tg-home/943f017f100becff"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.as-home-gp.name
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}

resource "aws_autoscaling_group" "as-laptop-gp" {
    name = "${var.project}-as-laptop"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    availability_zones = var.azs
    launch_configuration = aws_launch_configuration.laptop-template.name
    tag {
        key = "Name"
        value = "laptop"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "as-laptop-policy" {
  autoscaling_group_name = aws_autoscaling_group.as-laptop-gp.name
  name                   = "${var.project}-as-laptop-policy"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "app/terraform-lb/778d41231b141a0f/targetgroup/terraform-tg-laptop/943f017f100becff"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.as-laptop-gp.name
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
} 

resource "aws_autoscaling_group" "as-mobile-gp" {
    name = "${var.project}-as-mobile"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    availability_zones = var.azs
    launch_configuration = aws_launch_configuration.mobile-template.name
    tag {
        key = "Name"
        value = "mobile"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "as-mobile-policy" {
  autoscaling_group_name = aws_autoscaling_group.as-mobile-gp.name
  name                   = "${var.project}-as-mobile-policy"
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 50
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "app/terraform-lb/778d41231b141a0f/targetgroup/terraform-tg-mobile/943f017f100becff"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.as-mobile-gp.name
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
} 
