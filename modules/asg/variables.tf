variable "module_prefix" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "user_data" {}
variable "web_sg_id" {}
variable "max_size" {
  default = 4
}
variable "min_size" {
  default = 2
}
variable "desired_cap" {
  default = 2
}
variable "asg_health_check_type" {
  default = "ELB"
}
variable "pri_sub_web_a_id" {}
variable "pri_sub_web_b_id" {}
variable "tg_arn" {}
