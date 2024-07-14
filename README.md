## <div align="center"><b><a href="README.md">English</a> | <a href="README_CN.md">简体中文</a></b></div>

# Ways to enjoy Xcode LLM on ChinaSKU Mac

Ways to enjoy Xcode LLM on ChinaSKU Mac without disabling SIP.

For older methods which requires SIP disabled, please see Related links section.

## Notes

this project is for learning and research purposes only.

If you choose to use this project, you do so at your own risk and are responsible for compliance with any applicable laws.

The author of this project is not responsible for any consequences that may arise from your use of this project.

## Usage

### Script Execution

#### Install

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/main/override_xcodellm.sh | bash
```

#### Uninstall

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/main/override_xcodellm.sh | bash -s -- uninstall
```

### Manual Execution

#### Method 1 (Recommended)

Need one time SIP disable during the script.

1. Disable SIP in recovery mode with `csrutil disable` and reboot.
2. Download `eligibility_util` in the release page and execute `./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4`
3. Enable SIP in recovery mode with `csrutil enable` and reboot.

> Read [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection) if you are unfamiliar with SIP operation.

#### Method 2

No SIP disabled needed in total.

1. Download `eligibility_overrides.data` file from the release page
2. Find the correct container path for `eligibilityd` under `~/Library/Daemon Containers/<UUID>`
3. Move the downloaded file to `eligibilityd`'s daemon container's `Data/Library/Caches/NeverRestore/` folder. If you are not sure which one is for `eligibilityd`, you can try it one by one or just add the file to all of the containers.

## Related links

- https://gist.github.com/Kyle-Ye/4ad1aa92df3a31bd812487af65e16947
- https://gist.github.com/unixzii/6f25be1842399022e16ad6477a304286

## License

MIT. See LICENSE file.