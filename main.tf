provider "alicloud" {}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "ap-northeast-1"
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "ap-northeast-2"
}

provider "aws" {
  region = "ap-south-1"
  alias  = "ap-south-1"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "ap-southeast-1"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "ap-southeast-2"
}

provider "aws" {
  region = "ca-central-1"
  alias  = "ca-central-1"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "eu-central-1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu-west-1"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"
}

provider "aws" {
  region = "eu-west-3"
  alias  = "eu-west-3"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

locals {
  # region_instances 输出格式
  # {
  #   "ap-northeast-1" = {
  #     "ap-northeast-1-vpn-1" = {
  #       "instance_name" = "vpn-1"
  #       "region" = "ap-northeast-1"
  #     }
  #     "ap-northeast-1-vpn-2" = {
  #       "instance_name" = "vpn-2"
  #       "region" = "ap-northeast-1"
  #     }
  #   }
  #   "ap-south-1" = {
  #     "ap-south-1-vpn-1" = {
  #       "instance_name" = "vpn-1"
  #       "region" = "ap-south-1"
  #     }
  #   }
  # }
  region_instances = { for region, instances in { for s in var.instances : s.region => s... } : region => { for ins in instances : format("%s-%s", ins.region, ins.instance_name) => ins } }
}

module "lightsail-shadowsocks-ap-northeast-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "ap-northeast-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.ap-northeast-1
  }
}

module "lightsail-shadowsocks-ap-northeast-2" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "ap-northeast-2", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "lightsail-shadowsocks-ap-south-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "ap-south-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.ap-south-1
  }
}

module "lightsail-shadowsocks-ap-southeast-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "ap-southeast-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.ap-southeast-1
  }
}

module "lightsail-shadowsocks-ap-southeast-2" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "ap-southeast-2", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "lightsail-shadowsocks-ca-central-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "ca-central-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.ca-central-1
  }
}

module "lightsail-shadowsocks-eu-central-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "eu-central-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.eu-central-1
  }
}

module "lightsail-shadowsocks-eu-west-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "eu-west-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.eu-west-1
  }
}

module "lightsail-shadowsocks-eu-west-2" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "eu-west-2", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.eu-west-2
  }
}

module "lightsail-shadowsocks-eu-west-3" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "eu-west-3", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.eu-west-3
  }
}

module "lightsail-shadowsocks-us-east-1" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "us-east-1", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.us-east-1
  }
}

module "lightsail-shadowsocks-us-east-2" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "us-east-2", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.us-east-2
  }
}

module "lightsail-shadowsocks-us-west-2" {
  source = "./lightsail-shadowsocks"

  for_each = lookup(local.region_instances, "us-west-2", {})

  config            = each.value
  output_oss_bucket = var.output_oss_bucket

  providers = {
    aws = aws.us-west-2
  }
}