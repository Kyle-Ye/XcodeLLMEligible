## <div align="center"><b><a href="README.md">English</a> | <a href="README_CN.md">简体中文</a></b></div>

# 国行 Mac 使用 Xcode LLM的方法

在不禁用系统完整性保护 (SIP) 的情况下在国行 Mac 上使用 Xcode LLM 的方法。

对于需要禁用系统完整性保护 (SIP) 的旧方法，请参阅 "相关链接" 部分。

## 注意事项

这个项目仅用于学习和研究目的。

如果您选择使用此项目，您将自行承担风险，并有责任遵守任何适用法律。

本项目的作者对您使用本项目可能产生的任何后果概不负责。

## 使用方式

### 脚本执行

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/blob/main/override_xcodellm.sh | bash
```

### 手动执行

#### 方案一（推荐）

在脚本执行期间需要临时禁用一次 SIP。

1. 在恢复模式下通过 `csrutil disable` 禁用 SIP 并重启。
2. 在发布页面中下载 `eligibility_util` 并执行 `./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4`
3. 在恢复模式下通过 `csrutil enable` 恢复 SIP 并重启。

> 如果你不熟悉 SIP 操作，请阅读 [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection)。


#### 方案二

完全不需要禁用 SIP。

1. 从发布页面下载 `eligibility_overrides.data` 文件
2. 在`~/Library/Daemon Containers/<UUID>`下找到`eligibilityd`的正确容器路径
3. 将下载的文件移动到相应的 Deamon 容器的 `Data/Library/Caches/NeverRestore/` 文件夹中。如果您不确定哪个是 eligibilityd 的容器目录，您可以一个一个地尝试，或者将下载的文件添加到所有 Deamon 容器中。

## 相关链接

- https://gist.github.com/Kyle-Ye/4ad1aa92df3a31bd812487af65e16947
- https://gist.github.com/unixzii/6f25be1842399022e16ad6477a304286

## 版权信息

MIT。详见 LICENSE 文件。