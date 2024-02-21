provider "aws" {
   region = "ap-south-1"
}
  
  module "autoscaling" {
    source = "./modules/autoscaling"
    image_id = var.image_id
    instance_type = var.instance_type
    key_pair = var.key_pair
    project = var.project
    security_group_id = var.security_group_id
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    subnet_ids = var.subnet_ids
    azs = var.azs
}
 

 module "loadbalancer" {
    source = "./modules/loadbalancer"
    project = var.project
    env = var.env
    security_group_id = var.security_group_id
    subnet_ids =var.subnet_ids
    vpc_id = var.vpc_id
    autoscaling_group_name_home = module.autoscaling.asg_home_name
    autoscaling_group_name_laptop = module.autoscaling.asg_laptop_name
    autoscaling_group_name_mobile = module.autoscaling.asg_mobile_name
}
