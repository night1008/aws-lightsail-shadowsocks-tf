variable "output_oss_bucket" {
  description = "alicloud bucket name for config output"
  type        = string
  default     = "aws-lightsail-terraform"
}

variable "shadowsocks_instances" {
  description = "aws lightsail instance config"
  type = list(object({
    region                            = string # aws lightsail region
    instance_name                     = string # aws lightsail instance name
    availability_zone                 = string # aws lightsail instance availability zone
    create_static_ip                  = bool   # create lightsail static ip
    shadowsocks_libev_port            = number # shadowsocks-libev config port
    shadowsocks_libev_password_length = number # shadowsocks-libev password length
    shadowsocks_libev_method          = string # shadowsocks-libev config method
  }))
  default = [{
    region                            = "ap-northeast-1"
    instance_name                     = "vpn-1"
    availability_zone                 = "ap-northeast-1a"
    create_static_ip                  = true
    shadowsocks_libev_port            = 8388
    shadowsocks_libev_password_length = 10
    shadowsocks_libev_method          = "chacha20-ietf-poly1305"
  }]
  validation {
    condition     = length(var.shadowsocks_instances) == length(toset([for s in var.shadowsocks_instances : format("%s-%s", s.region, s.instance_name)]))
    error_message = "The shadowsocks_instances instance_name must be unique on a region."
  }
}

variable "hysteria_instances" {
  description = "aws lightsail hysteria2 instance config"
  type = list(object({
    region            = string # aws lightsail region
    instance_name     = string # aws lightsail instance name
    availability_zone = string # aws lightsail instance availability zone
    create_static_ip  = bool   # create lightsail static ip
    password_length   = number # hysteria2 password length
    proxy_url         = string # masquerade proxy url, e.g. https://bing.com
  }))
  default = []
  validation {
    condition     = length(var.hysteria_instances) == length(toset([for s in var.hysteria_instances : format("%s-%s", s.region, s.instance_name)]))
    error_message = "The hysteria_instances instance_name must be unique on a region."
  }
}