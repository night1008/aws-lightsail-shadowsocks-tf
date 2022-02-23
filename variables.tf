variable "alicloud_bucket" {
  description = "alicloud bucket name for config output"
  type        = string
  default     = "aws-lightsail-terraform"
}

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "ap-northeast-1"
}

variable "instances" {
  description = "aws lightsail instance config"
  type = list(object({
    instance_name                     = string # aws lightsail instance name
    availability_zone                 = string # aws lightsail instance availability zone
    create_static_ip                  = bool   # create lightsail static ip
    shadowsocks_libev_port            = number # shadowsocks-libev config port
    shadowsocks_libev_password_length = number # shadowsocks-libev password length
    shadowsocks_libev_method          = string # shadowsocks-libev config method
  }))
  default = [{
    instance_name                     = "vpn-1"
    availability_zone                 = "ap-northeast-1a"
    create_static_ip                  = true
    shadowsocks_libev_port            = 8388
    shadowsocks_libev_password_length = 10
    shadowsocks_libev_method          = "chacha20-ietf-poly1305"
  }]
  validation {
    condition     = length(var.instances) == length(toset([for s in var.instances : s.instance_name]))
    error_message = "The instances instance_name must be unique on a region."
  }
}