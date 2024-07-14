# Ways to enjoy Xcode LLM on ChinaSKU Mac

Ways to enjoy Xcode LLM on ChinaSKU Mac without disabling SIP.

在不禁用系统完整性保护 (SIP) 的情况下在国行 Mac 上使用 Xcode LLM 的方法。

For older methods which requires SIP disabled, please see Related links section.

对于需要禁用系统完整性保护 (SIP) 的旧方法，请参阅 "相关链接" 部分。

## Notes / 注意事项

## Usage

### Script Execution / 脚本执行

TODO

### Manual Execution / 手动执行

#### Method 1 (Recommended) / 方案一（推荐）

Need one time SIP disable during the script.

1. Disable SIP in recovery mode with `csrutil disable` and reboot.
2. Download `eligibility_util` in the release page and execute `eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4`
3. Enable SIP in recovery mode with `csrutil enable` and reboot.

> Read [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection) if you are unfamiliar with SIP operation.

在脚本执行期间需要临时禁用一次 SIP。

1. 在恢复模式下通过 `csrutil disable` 禁用 SIP 并重启。
2. 在发布页面中下载 `eligibility_util` 并执行 `eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4`
3. 在恢复模式下通过 `csrutil enable` 恢复 SIP 并重启。

> 如果你不熟悉 SIP 操作，请阅读 [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection)。


#### Method 2 / 方案二

No SIP disabled needed in total.

1. Download `eligibility_overrides.data` file from the release page
2. Find the correct container path for `eligibilityd` under `~/Library/Daemon Containers/<UUID>`
3. Move the downloaded file to `eligibilityd`'s daemon container's `Data/Library/Caches/NeverRestore/` folder. If you are not sure which one is for `eligibilityd`, you can try it one by one or just add the file to all of the containers.

完全不需要禁用 SIP。

1. 从发布页面下载 `eligibility_overrides.data` 文件
2. 在`~/Library/Daemon Containers/<UUID>`下找到`eligibilityd`的正确容器路径
3. 将下载的文件移动到相应的 Deamon 容器的 `Data/Library/Caches/NeverRestore/` 文件夹中。如果您不确定哪个是 eligibilityd 的容器目录，您可以一个一个地尝试，或者将下载的文件添加到所有 Deamon 容器中。

## Related links / 相关链接

- https://gist.github.com/Kyle-Ye/4ad1aa92df3a31bd812487af65e16947
- https://gist.github.com/unixzii/6f25be1842399022e16ad6477a304286

## License / 版权信息

MIT. See LICENSE file.

MIT。详见 LICENSE 文件。