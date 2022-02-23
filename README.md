# aws-lightsail-shadowsocks-tf
use terraform manage shadowsocks on aws lightsail

---

### 准备工作
1. aws access key
2. oss access key
3. 创建一个 oss bucket

### 注意点
1. 当前 oss backend 需要和 variables.tf 的 alicloud_bucket 指定同一个 bucket
2. 当前只能在一个 aws region 内建立多个实例

### 执行命令

```
export AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=xxx

export ALICLOUD_ACCESS_KEY=xxx ALICLOUD_SECRET_KEY=xxx ALICLOUD_REGION=cn-hangzhou

cp terraform.tfvars.json.example terraform.tfvars.json

terraform init -backend-config="bucket=aws-lightsail-terraform" -backend-config="prefix=state"

terraform apply
```

### 执行结果
> 意外：有几个实例输出几个 oss 配置文件，实例删除时 oss 配置文件也会删除

每个实例的 ip 信息和 shadowsocks 的配置信息会下载到当前 shadowsocks-configs 目录下，
同时也会存储到 oss 文件中，oss 输出文件目录如下

```
/aws-lightsail-terraform
  /state
    /terraform.tfstate
  /outputs
    /ap-northeast-1
      /vpn-1.json
      /vpn-2.json
```

### 测试工具

通过 [TCP port check](http://port.ping.pe) 测试实例连接情况

### TODO
- [ ] 输出 oss config file url
- [ ] 一次开启多个地区实例
