## <div align="center"><b><a href="README.md">English</a> | <a href="README_CN.md">简体中文</a></b></div>

# Darwin Eligibility Override

本项目旨在不禁用系统完整性保护 (SIP) 或者仅禁用一次的情况下
实现永久在任意 Mac 上使用 Xcode LLM / Apple Intelligence / iPhone 镜像功能。

> [!NOTE]
> Xcode LLM 仅支持在 macOS 15.0 及更高版本上使用。
>
> Apple Intelligence 仅支持在 macOS 15.1 及更高版本上使用。
>
> XcodeLLM, Apple Intelligence 和 ChatGPT 集成已在 Mac mini (M4 Pro, 2024) + macOS 15.2 上测试正常。

![屏幕截图](images/XcodeLLM/screenshot.png)

## 注意事项

这个项目仅用于学习和研究目的。

如果您选择使用此项目，您将自行承担风险，并有责任遵守任何适用法律。

本项目的作者对您使用本项目可能产生的任何后果概不负责。

## 使用方式

### 方案一 util 工具（推荐）

在脚本执行期间需要临时禁用一次 SIP 并在启动参数中添加 "amfi_get_out_of_my_way=1"。

> [!TIP]
> 如果你在如何禁用 SIP 或设置启动参数方面遇到问题，请参阅[手动执行](#manual-execution)部分以了解更多详细信息。

```shell
# For XcodeLLM 
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util xcodellm
# For Apple Intelligence
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util greymatter
# For Cleanup
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util strontium
# For iPhone Mirroring for EU Mac user
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util iron
```

### 方案二 override 文件

完全不需要禁用 SIP。

```shell
# For XcodeLLM
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override xcodellm
# For Apple Intelligence
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override greymatter
# For Apple Intelligence + Cleanup
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override greymatter+strontium
# For XcodeLLM + Apple Intelligence + Cleanup
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override xcodellm+greymatter+strontium
# For iPhone Mirroring
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override iron
```

> [!NOTE]
> override 文件方案是互斥的。
>
> 本仓库仅提供了单独了 Xcode LLM 和 Apple Intelligence 的 override 文件。
>
> 如果需要覆盖多个，请使用 util 工具方案分别覆盖后导出 override 文件供自己未来使用。

## 卸载

### 方案一 util 工具

```shell
# For XcodeLLM:
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall util xcodellm
# For Apple Intelligence
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall util greymatter
# For Clenaup
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall util strontium
# For iPhone Mirroring
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall util iron
```

### 方案二 override 文件

```shell
# For XcodeLLM:
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override xcodellm
# For Apple Intelligence
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override greymatter
# For Apple Intelligence + Cleanup
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override greymatter+strontium
# For XcodeLLM + Apple Intelligence + Cleanup
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override xcodellm+greymatter+strontium
# For iPhone Mirroring
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override iron
```

## 手动执行

### 方案一 util 工具 （推荐）

1. 在恢复模式下通过 `csrutil disable` 禁用 SIP

2. 添加启动参数 `sudo nvram boot-args="amfi_get_out_of_my_way=1"`并**重启**

3. 从[发布页面](https://github.com/Kyle-Ye/XcodeLLMEligible/releases)下载可执行文件 `eligibility_util` 并添加执行权限。

> 以下的命令假设下载的文件在 `~/Downloads` 文件夹。

```shell
chmod +x ~/Downloads/eligibility_util
```

4. 执行以下命令

```shell
cd ~/Downloads
# For XcodeLLM (macOS 15.0+ required)
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4
# For Apple Intelligence (macOS 15.1+ required)
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER --answer 4
# For Cleanup (macOS 15.1 Beta 3+ required)
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_STRONTIUM --answer 4
# For iPhone Mirroring (macOS 15.0+ required)
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_IRON --answer 4
```

4. 在恢复模式下通过 `csrutil enable` 恢复 SIP
5. 删除启动参数 `sudo nvram -d boot-args`

> 如果你不熟悉 SIP 操作，请阅读 [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection)。
>
> 你只能在恢复模式或禁用 SIP 的普通模式下设置boot-args。
>
> 设置boot-args后，记得重新启动以使更改生效。

> [!TIP]
> 更多技术细节，请参阅 [Kyle-Ye/eligibility](https://github.com/Kyle-Ye/eligibility)

### 方案二 override 文件

完全不需要禁用 SIP。

1. 从[发布页面](https://github.com/Kyle-Ye/XcodeLLMEligible/releases)下载需要的 `*.eligibility_overrides.data` 文件并重命名为 `eligibility_overrides.data`

> 对于 Xcode LLM，下载 [xcodellm.eligibility_overrides.data](https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.2.0/xcodellm.eligibility_overrides.data)
> 
> 对于 Apple Intelligence，下载 [greymatter.eligibility_overrides.data](https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.2.0/greymatter.eligibility_overrides.data)

2. 在 `/private/var/root/Library/Daemon\ Containers` 下找到 `eligibilityd` 的容器 UUID

通过以下命令查看所有的 UUID
```shell
sudo ls /private/var/root/Library/Daemon\ Containers
```

3. 将第一步下载的文件移动到相应的 Deamon 容器的 `Data/Library/Caches/NeverRestore/` 文件夹中。如果您不确定哪个是 eligibilityd 的容器目录，您可以一个一个地尝试，或者将下载的文件添加到所有 Deamon 容器中。

```shell
sudo mkdir /private/var/root/Library/Daemon\ Containers/<UUID>/Data/Library/Caches/NeverRestore
sudo cp eligibility_overrides.data /private/var/root/Library/Daemon\ Containers/<UUID>/Data/Library/Caches/NeverRestore/
```

4. 重启 eligitbilityd 服务

```shell
sudo pkill -9 eligibilityd
sudo launchctl kickstart -k system/com.apple.eligibilityd
```

## 故障排除

> [!TIP]
> eligibility_util 和 eligibility_util_sip 的区别在于，后者可以用于开启了SIP的环境（仅部分功能可用）。

### 方案一 util 工具问题

1. 如果看到以下输出

```shell
zsh: no such file or directory: ./eligibility_util
```

请确保当前工作路径含有 `eligibility_util` 的文件。

2. 如果看到以下输出

```shell
zsh permission denied: ./eligibility_util
```

请确保已添加了执行权限 `chmod +x ./eligibility_util`。(检查[手动执行](#手动执行)的第 3 步)

3. 如果看到以下输出

```shell
>[1]    61672 killed     ./eligibility_util
```

请确保已禁用了 SIP 设置了正确的 boot-args 并已重启。(检查[手动执行](#手动执行)的第 1 步和第 2 步)

4. 其他问题

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- doctor
```

### 方案二 override 文件问题

如果你无法访问 Daemon Container 相关文件夹，请检查你使用的终端App是否拥有完全磁盘访问权限。

路径：设置 App -> 隐私和安全性 -> 完全磁盘访问权限 -> 添加你的终端App并允许访问。

### 其他 Xcode LLM 相关问题

1. 确认覆盖生效并且你有正确的 Answer。
```
./eligibility_util_sip getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
```

2. 重新启用 SIP，然后打开 Xcode 下载模型。

See detail for [#4](https://github.com/Kyle-Ye/XcodeLLMEligible/issues/4)

### 其他 Apple Intelligence 相关问题

> [!IMPORTANT]
> 建议：
> 1. 登录美区 Apple ID
> 2. 将地区设置为美国，并将英语设置为首选语音
> 3. 将英语（美国）设置为 Siri 语言

1. 确认覆盖生效并且你有正确的 Answer。

```
./eligibility_util_sip getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
```

2. 进入设置 App > "Apple Intelligence & Siri"，点击 "Join Apple Intelligence Waitlist" 按钮。

![Step2](images/AppleIntelligence/Step2.png)

3. 你将看到 "Joined Waitlist" 标签，然后耐心等待一段时间。 

![Step3](images/AppleIntelligence/Step3.png)

4. 你将看到 "Preparing" 标签，然后继续耐心等待一段时间。

![Step4](images/AppleIntelligence/Step4.png)

5. 你将收到 "Apple Intelligence is Here" 通知。

![Step5](images/AppleIntelligence/Step5.png)

6. 你现在可以打开 Apple Intelligence 并使用它。

![Step6](images/AppleIntelligence/Step6.png)

## FAQ

1. 在系统更新之后这种方式还会生效吗？

大概率会。Eligibility Override 不需要你在系统更新后再次执行一遍命名。

但是 Apple 可能会在未来更改 eligibility 机制，所以不能保证在系统更新后仍然有效。

2. 为什么在设置里没有 Apple Intelligence？

Apple Intelligence 只在 macOS 15.1 及更高版本上可用。

3. 为什么在设置里没有 ChatGPT 相关?

ChatGPT 集成只在 macOS 15.2 及更高版本上可用。

4. 为什么开启 Apple Intelligence 后，Siri 仍然使用了百度的服务?

Siri 的搜索引擎是由你的地区语言设置和网络环境决定的。请参考互联网上的其他资料选择合适的网络代理进行配置。

eg. https://github.com/VirgilClyne/iRingo

5. 为什么我的 Apple Intelligence 一直卡在下载 100%?

可以尝试关闭 SIP 后删除 AssetsV2 文件夹，然后重新启用 SIP。

```shell
# 关闭SIP (恢复 OS 模式下执行)
csrutil disable
csrutil authenticated-root disable
# 重启进入到普通 macOS
# 设置中关闭 Apple Intelligence
# 普通 macOS 的终端中执行
sudo rm -rf /System/Library/AssetsV2/*
# 开启 SIP (恢复 OS 模式下执行)
csrutil enable
csrutil authenticated-root enable
# 设置中开启 Apple Intelligence
```

> See [#62](https://github.com/Kyle-Ye/XcodeLLMEligible/issues/62#issuecomment-2541993096).

6. 为什么我的 Apple Intelligence 中无法使用 ChatGPT?

大概率是网络原因导致，如果你处在不受支持的地区，请确保你使用了全局网络代理等方式来访问该服务。

- 对于 Shadowrocket，开启全局代理即可。
- 对于其他代理工具，请参考其官方文档。

> [!NOTE]
> 仅代理 Web 的网络流量是不够的，请在 OS 或者本地网络（路由器）层面进行代理。
>
> 可以通过直接启动终端并运行 `ping google.com` 或 `curl cip.cc` 来进行验证。（警告：`cip.cc`是第三方服务。请自行决定使用它。）
>
> See [#60](https://github.com/Kyle-Ye/XcodeLLMEligible/issues/60#issuecomment-2541349746) for more details.

## 相关链接

- https://github.com/Kyle-Ye/eligibility/

- https://gist.github.com/Kyle-Ye/4ad1aa92df3a31bd812487af65e16947
- https://gist.github.com/unixzii/6f25be1842399022e16ad6477a304286

## 星星历史

[![Star History Chart](https://api.star-history.com/svg?repos=Kyle-Ye/XcodeLLMEligible&type=Date)](https://star-history.com/#Kyle-Ye/XcodeLLMEligible&Date)

## 版权信息

MIT。详见 LICENSE 文件。