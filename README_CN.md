## <div align="center"><b><a href="README.md">English</a> | <a href="README_CN.md">简体中文</a></b></div>

# Darwin Eligibility Override

本项目旨在不禁用系统完整性保护 (SIP) 或者仅禁用一次的情况下
实现永久在任意 Mac 上使用 Xcode LLM / Apple Intelligence。

> [!NOTE]
> Xcode LLM 仅支持在 macOS 15.0 及更高版本上使用。
>
> Apple Intelligence 仅支持在 macOS 15.1 及更高版本上使用。

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
# Force XcodeLLM to be eligible
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util xcodellm
# Force Apple Intelligence to be eligible
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util greymatter
# Force Cleanup to be eligible
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install util strontium
```

### 方案二 override 文件

完全不需要禁用 SIP。

```shell
# Override XcodeLLM only
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override xcodellm
# Override Apple Intelligence only
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- install override greymatter
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
# For Clenaup as part of Apple Intelligence feature
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall util strontium
```

### 方案二 override 文件

```shell
# For XcodeLLM:
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override xcodellm
# For Apple Intelligence
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.2/scripts/override.sh | bash -s -- uninstall override greymatter
```

## 手动执行

### 方案一 util 工具 （推荐）

1. 在恢复模式下通过 `csrutil disable` 禁用 SIP
2. 添加启动参数 `sudo nvram boot-args="amfi_get_out_of_my_way=1"`并**重启**
3. 从[发布页面](https://github.com/Kyle-Ye/XcodeLLMEligible/releases)下载可执行文件 `eligibility_util` 并执行以下命令

```shell
# For XcodeLLM:
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4
# For Apple Intelligence (macOS 15.1+ required)
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER --answer 4
# For Cleanup as part of Apple Intelligence feature (macOS 15.1 Beta 3+ required)
./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_STRONTIUM --answer 4
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

## 相关链接

- https://github.com/Kyle-Ye/eligibility/

- https://gist.github.com/Kyle-Ye/4ad1aa92df3a31bd812487af65e16947
- https://gist.github.com/unixzii/6f25be1842399022e16ad6477a304286

## 星星历史

[![Star History Chart](https://api.star-history.com/svg?repos=Kyle-Ye/XcodeLLMEligible&type=Date)](https://star-history.com/#Kyle-Ye/XcodeLLMEligible&Date)

## 版权信息

MIT。详见 LICENSE 文件。