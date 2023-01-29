# ddns-scripts-aliyun

ddns-scripts-aliyun是OpenWrt软件包ddns-scripts的扩展, 实现阿里云域名的动态DNS解析。

## 使用前提

在使用该脚本之前，需要满足以下前提

- 请确保拥有公网IPv4或IPv6地址，不确定可以[点击这里](http://www.test-ipv6.com/)进行检查。
- 在阿里云拥有一个域名，并在阿里云后台配置了相应的A或AAAA记录。详见[配置使用](#配置使用)
- 已申请好阿里云的AccessKey，推荐使用子账户进行配置
- 为子账户配置了`AliyunDNSReadOnlyAccess`和`AliyunDNSFullAccess`的权限策略

## 安装之前

如果网络环境较差，推荐先更换OpenWrt的软件源，可以加快下载软件包的速度。这里使用[阿里云](https://developer.aliyun.com/mirror/openwrt?spm=a2c6h.13651102.0.0.56cb1b11HkJNeY)的软件源。

终端执行以下命令即可完成更换：

```bash
sed -i 's_downloads.openwrt.org_mirrors.aliyun.com/openwrt_' /etc/opkg/distfeeds.conf
```

## 安装

首先在[Release页面](https://github.com/renndong/ddns-scripts-aliyun/releases)下载好ipk软件包

### LuCI后台安装（推荐

1. 进入LuCI管理后台，选择「系统」>「软件包」，进入软件包管理界面
2. 点击「更新」按钮，更新软件包索引
3. 点击「上传软件包」按钮，选择下载好的ipk文件，上传后选择安装即可

### 终端安装

1. 本地终端执行 `scp -O {ipk软件包路径} root@{路由器IP}:/root` 将软件包上传到路由器`/root`目录下
2. 进入路由器终端，执行命令`opkg update`更新软件包索引
3. 执行命令`opkg install {ipk软件包路径}`即可完成安装

安装完成后，即可在动态DNS服务的DNS提供商列表中，看到`aliyun.com`选项。

## 配置使用

下面以主域名`example.com`为例，介绍如何配置使用：

由于ddns-scripts暂时无法自动创建域名解析记录，所以使用之前，需要先在阿里云DNS控制台配置一条解析记录：

- 记录类型：如果配置IPv4解析记录，选择A，如果配置IPv6，则选择AAAA
- 主机记录：如果想直接解析主域名`example.com`，则填写`@`；如果想配置子域名解析记录，如`host.example.com`，则填写`host`,
- 记录值：可随意填写，只要符合IP地址格式即可，之后DDNS服务启动后会被修改掉。

**注意：对同一域名的同一记录类型可以配置多条记录，但是这里只推荐配置一条。如果检测到了多条记录，脚本只会使用第一条。**

进入LuCI后台，选择「服务」>「动态DNS」，选择「添加新服务」或直接编辑原有的服务：

- 主机名填写要进行动态DNS的域名，如`example.com`、`host.example.com`
- DNS提供商选择`aliyun.com`，并切换服务
- 填写域名，以`host@yourdomain.LTD`格式进行填写：
    - 如果为主域名`example.com`配置，则填写`@example.com`，注意前面有`@`
    - 如果为子域名配置，如`host.example.com`, 则填写`host@example.com`
    - 对一些多级域名如`host.example.com.cn`, 请确保`@`后为你购买的主域名，如`host@example.com.cn`、`@example.com.cn`
- 用户名填写阿里云AccessKey ID，密码填写AccessKey Secret

其他一些配置依据自己的需求配置即可，配置完保存并应用，过一会后即可在阿里云DNS控制台看到已更新的记录值。

有问题欢迎提[Issue](https://github.com/renndong/ddns-scripts-aliyun/issues).