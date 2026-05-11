# aws-lightsail-shadowsocks-tf
use terraform manage shadowsocks on aws lightsail

---

### 准备工作
1. aws access key
2. oss access key
3. 创建一个 oss bucket

### 注意点
1. 当前 oss backend 需要和 variables.tf 的 alicloud_bucket 指定同一个 bucket
2. 可以在任意 aws region 内建立多个实例

### 执行命令

```
export AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=xxx

export ALICLOUD_ACCESS_KEY=xxx ALICLOUD_SECRET_KEY=xxx ALICLOUD_REGION=cn-hangzhou ALICLOUD_BUCKET=aws-lightsail-terraform

cp terraform.tfvars.json.example terraform.tfvars.json

terraform init -backend-config="bucket=aws-lightsail-terraform"

terraform apply
```

### 执行结果
> 意外：有几个实例输出几个 oss 配置文件，实例删除时 oss 配置文件也会删除

每个实例的 ip 信息和 shadowsocks 的配置信息会同时写入 OSS 和本地 `outputs/` 目录。
本地文件由 Terraform 直接生成，不再依赖额外的下载脚本，目录结构如下：

```
/aws-lightsail-terraform
  /outputs/shadowsocks-configs
    /ap-northeast-1
      /vpn-1.json
      /vpn-2.json
  /outputs/hysteria-configs
    /ap-northeast-1
      /hy2-1.json
```

shadowsocks 本地输出文件位于 `outputs/shadowsocks-configs/${region}-${instance_name}.json`。

hysteria2 实例对应的本地输出文件位于 `outputs/hysteria-configs/${region}-${instance_name}.json`，
其中 `hysteria_url` 字段（`hysteria2://...?sni=...&insecure=1#...`）可直接在
Shadowrocket / Clash / Clash Verge 中通过 URL 导入。

### 测试工具

通过 [TCP port check](http://port.ping.pe) 测试实例连接情况

### TODO
- [ ] 输出 oss config file url
- [x] 一次开启多个地区实例
- [ ] 一个实例开启多个 shadowsocks
- [x] 支持 hysteria2
- [x] 一个实例同时开启 shadowsocks + hysteria2