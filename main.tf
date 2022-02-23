provider "aws" {
  region = var.aws_region
}

provider "alicloud" {}

module "lightsail-shadowsocks" {
  source = "./lightsail-shadowsocks"

  for_each = { for s in var.instances : format("%s-%s", var.aws_region, s.instance_name) => s }

  config     = each.value
  oss_bucket = var.alicloud_bucket
  aws_region = var.aws_region
}