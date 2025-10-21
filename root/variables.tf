variable "region" {}
variable "aws_profile" {}
variable "project_name" {}
variable "vpc_cidr" {
  # 10.123.0.0 - 10.123.255.255 (65536 IPs)
  default = "10.0.0.0/16"
}

variable "pub_sub_a_cidr" {
  # 10.123.1.4 - 10.123.1.254 (251 IPs)
  default = "10.0.1.0/24"
}
variable "pub_sub_b_cidr" {
  # 10.123.2.4 - 10.123.2.254 (251 IPs)
  default = "10.0.2.0/24"
}

variable "pri_sub_web_a_cidr" {
  # 10.123.3.4 - 10.123.3.254 (251 IPs)
  default = "10.0.3.0/24"
}
variable "pri_sub_web_b_cidr" {
  # 10.123.4.4 - 10.123.4.254 (251 IPs)
  default = "10.0.4.0/24"
}
variable "pri_sub_data_a_cidr" {
  # 10.123.5.4 - 10.123.5.254 (251 IPs)
  default = "10.0.5.0/24"
}
variable "pri_sub_data_b_cidr" {
  # 10.123.6.4 - 10.123.6.254 (251 IPs)
  default = "10.0.6.0/24"
}

variable "db_username" {
  default = "admin"
}
variable "db_password" {
  default = "password"
}

variable "sub_domain" {
  default = "2tierapp"
}
