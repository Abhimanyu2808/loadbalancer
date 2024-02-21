variable "image_id" {
    default = "ami-03f4878755434977f"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_pair" {
    default = "new-key"
}

variable "project" {
    default = "terraform"
}

variable "security_group_id" {
    default = "sg-05730f6b6db3fc19b"
}

variable "min_size" {
    default = 2
}

variable "max_size" {
    default = 4
}

variable "desired_capacity" {
    default = 2
}

variable "subnet_ids" {
    default = ["subnet-07592a5f661ebb68c", "subnet-0da54f43144cbf0c0"]
}

variable "env" {
    default = "dev"
}

variable "vpc_id" {
    default = "vpc-09bc2175df40869c8"
}
variable "azs" {
    default = ["ap-south-1a", "ap-south-1b"]
}
