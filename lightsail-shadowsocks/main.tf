locals {
  oss_object_key      = "outputs/${var.aws_region}/${var.config.instance_name}.json"
  local_oss_file_name = "shadowsocks-configs/${var.aws_region}-${var.config.instance_name}.json"
  shadowsocks_libev_config = {
    "server" = ["0.0.0.0"],
    "mode" : "tcp_and_udp",
    "server_port" = var.config.shadowsocks_libev_port,
    "local_port"  = 1080,
    "password"    = random_password.password.result,
    "timeout" : 60,
    "method" : var.config.shadowsocks_libev_method
  }
}

resource "aws_lightsail_static_ip_attachment" "instance" {
  count          = var.config.create_static_ip ? 1 : 0
  static_ip_name = aws_lightsail_static_ip.instance[count.index].id
  instance_name  = aws_lightsail_instance.instance.id
}

resource "aws_lightsail_static_ip" "instance" {
  count = var.config.create_static_ip ? 1 : 0
  name  = format("%s-%s", "static-ip", var.config.instance_name)
}

resource "random_password" "password" {
  length           = var.config.shadowsocks_libev_password_length
  special          = true
  override_special = "_%@"
}

resource "aws_lightsail_instance" "instance" {
  name              = format("%s-%s", "instance", var.config.instance_name)
  availability_zone = var.config.availability_zone
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"
  # key_pair_name     = "some_key_name"

  depends_on = [
    aws_lightsail_static_ip.instance
  ]

  user_data = <<-EOF
  #!/bin/bash
  apt update
  apt install shadowsocks-libev -y
  sudo sh -c 'echo "{
    \"server\":[\"0.0.0.0\"],
    \"mode\":\"tcp_and_udp\",
    \"server_port\":${var.config.shadowsocks_libev_port},
    \"local_port\":1080,
    \"password\":\"${random_password.password.result}\",
    \"timeout\":60,
    \"method\":\"${var.config.shadowsocks_libev_method}\"
  }" > /etc/shadowsocks-libev/config.json'
  systemctl restart shadowsocks-libev
  EOF
}

resource "aws_lightsail_instance_public_ports" "instance" {
  instance_name = aws_lightsail_instance.instance.name

  # for test
  # provisioner "local-exec" {
  #   command = <<EOF
  #   echo ${jsonencode({"shadowsocks-config"=local.shadowsocks_libev_config, "public_ip_address"=aws_lightsail_instance.instance.public_ip_address, "static_ip"=var.config.create_static_ip ? aws_lightsail_static_ip.instance[0].ip_address:""})} > ${var.instance_name}.json
  #   EOF
  # }

  port_info {
    protocol  = "all"
    from_port = 0
    to_port   = 65535
    cidrs = [
      "0.0.0.0/0"
    ]
  }

  depends_on = [
    aws_lightsail_instance.instance
  ]
}

# resource "alicloud_oss_bucket" "instance" {
#   bucket = var.oss_bucket
#   acl    = "private"
# }

resource "alicloud_oss_bucket_object" "object" {
  bucket  = var.oss_bucket
  key     = local.oss_object_key
  content = jsonencode({ "shadowsocks_config" = local.shadowsocks_libev_config, "public_ip_address" = aws_lightsail_instance.instance.public_ip_address, "static_ip" = var.config.create_static_ip ? aws_lightsail_static_ip.instance[0].ip_address : "" })

  provisioner "local-exec" {
    command = "./download-oss-file.sh ${var.oss_bucket} ${local.oss_object_key} ${local.local_oss_file_name}"
  }

  depends_on = [
    aws_lightsail_instance_public_ports.instance
  ]
}