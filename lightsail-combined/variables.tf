variable "output_oss_bucket" {
  type    = string
  default = "aws-lightsail-terraform"
}

variable "config" {
  type = object({
    region                            = string # aws lightsail region
    instance_name                     = string # aws lightsail instance name
    availability_zone                 = string # aws lightsail instance availability zone
    create_static_ip                  = bool   # create lightsail static ip
    # 协议开关
    shadowsocks_enable                = bool # 是否启用 shadowsocks-libev
    hysteria_enable                   = bool # 是否启用 hysteria2
    # shadowsocks-libev（shadowsocks_enable = true 时生效）
    shadowsocks_libev_port            = number # shadowsocks-libev listen port
    shadowsocks_libev_password_length = number # shadowsocks-libev password length
    shadowsocks_libev_method          = string # shadowsocks-libev cipher method
    # hysteria2（hysteria_enable = true 时生效）
    hysteria_password_length          = number # hysteria2 password length
    hysteria_proxy_url                = string # masquerade proxy url, e.g. https://bing.com
  })
  default = {
    region                            = "ap-northeast-1"
    instance_name                     = "test1"
    availability_zone                 = "ap-northeast-1a"
    create_static_ip                  = true
    shadowsocks_enable                = true
    hysteria_enable                   = true
    shadowsocks_libev_port            = 8388
    shadowsocks_libev_password_length = 10
    shadowsocks_libev_method          = "chacha20-ietf-poly1305"
    hysteria_password_length          = 10
    hysteria_proxy_url                = "https://bing.com"
  }

  validation {
    condition     = var.config.region == substr(var.config.availability_zone, 0, length(var.config.availability_zone) - 1)
    error_message = "The instance availability_zone must be in the same region."
  }

  validation {
    condition     = var.config.shadowsocks_enable || var.config.hysteria_enable
    error_message = "At least one protocol must be enabled (shadowsocks_enable or hysteria_enable)."
  }

  validation {
    condition     = !var.config.hysteria_enable || can(regex("^https?://[^/]+", var.config.hysteria_proxy_url))
    error_message = "hysteria_proxy_url must be a valid http(s) url when hysteria_enable is true."
  }
}
