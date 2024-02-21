provider "aws" {
   region = "ap-south-1"
}
  
  module "asg" {
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
    autoscaling_group_name_home = module.asg.asg_home_name
    autoscaling_group_name_laptop = module.asg.asg_laptop_name
    autoscaling_group_name_mobile = module.asg.asg_mobile_name
}
