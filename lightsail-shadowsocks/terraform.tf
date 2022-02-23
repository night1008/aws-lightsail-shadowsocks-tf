terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.157.0"
    }
  }
}