## <div align="center"><b><a href="README.md">English</a> | <a href="README_CN.md">简体中文</a></b></div>

# Ways to enjoy Xcode LLM on ChinaSKU Mac

Ways to enjoy Xcode LLM / Apple Intelligence on ChinaSKU Mac without disabling SIP.

For older methods which requires SIP disabled, please see "Related links" section.

![Screenshot](images/XcodeLLM/screenshot.png)

## Notes

this project is for learning and research purposes only.

If you choose to use this project, you do so at your own risk and are responsible for compliance with any applicable laws.

The author of this project is not responsible for any consequences that may arise from your use of this project.

## Usage

> [!NOTE]
> Tested the script under macOS 15 Beta 1 ~ Beta 3
> 
> Should work on macOS 15.x release as long as Apple does not remove or change the override feature of eligibility service.

### Script Execution

#### Install

XcodeLLM:

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.1/override_xcodellm.sh | bash
```

Apple Intelligence:

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.1/override_apple_intelligence.sh | bash
```

#### Uninstall

XcodeLLM:

```shell
curl -L https://raw.githubusercontent.com/Kyle-Ye/XcodeLLMEligible/release/0.1/override_xcodellm.sh | bash -s -- uninstall
```

### Manual Execution

#### Method 1 (Recommended)

Need one time SIP disable during the script.

1. Disable SIP in recovery mode with `csrutil disable`
2. Add boot argument by `sudo nvram boot-args="amfi_get_out_of_my_way=1"` and reboot
3. Download `eligibility_util` from the [release page](https://github.com/Kyle-Ye/XcodeLLMEligible/releases) and execute `./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4`
4. Enable SIP in recovery mode with `csrutil enable` and reboot.
5. Remove boot argument by `sudo nvram -d boot-args`

> Read [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection) if you are unfamiliar with SIP operation.
>
> You can only set boot-args in recovery mode or normal mode with SIP disabled.
>
> After setting boot-args, remember to reboot to make the change take effect.

> [!TIP]
> Similarly if you'd like to try Apple Intelligence on unsupported location or device, you can use the following command:
>
> `./eligibility_util forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER --answer 4`
>
> For technical detail, see [Kyle-Ye/eligibility#3](https://github.com/Kyle-Ye/eligibility/pull/3)

#### Method 2

> [!NOTE]
> There is known issue for method 2. See [#3](https://github.com/Kyle-Ye/XcodeLLMEligible/issues/3) for more details.
>
> If this is not work for you, please try method 1.

No SIP disabled needed in total.

1. Download `eligibility_overrides.data` file from the [release page](https://github.com/Kyle-Ye/XcodeLLMEligible/releases)
2. Find the correct container path for `eligibilityd` under `~/Library/Daemon Containers/<UUID>`
3. Move the downloaded file to `eligibilityd`'s daemon container's `Data/Library/Caches/NeverRestore/` folder. If you are not sure which one is for `eligibilityd`, you can try it one by one or just add the file to all of the containers.

## Trouble Shooting

> [!TIP]
> The difference of eligibility_util and eligibility_util_sip is that the former is for SIP disabled environment and the latter is for SIP enabled environment.

### Xcode LLM

1. Confirom the override is working and you have the correct answer.

```
./eligibility_util_sip getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
```

2. Reenable SIP and then open Xcode to download Model.

See detail for [#4](https://github.com/Kyle-Ye/XcodeLLMEligible/issues/4)

### Apple Intelligence

> [!IMPORTANT]
> Suggestions:
> 1. Log in with a US Apple ID
> 2. Set Region to United States and English as the primary language
> 3. Set English (United States) as your Siri language

1. Confirom the override is working and you have the correct answer.

```
./eligibility_util_sip getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
```

2. Go to Setting.app and choose "Apple Intelligence & Siri", click "Join Apple Intelligence Waitlist" button.

![Step2](images/AppleIntelligence/Step2.png)

3. You'll see "Joined Waitlist" label and wait for a while.

![Step3](images/AppleIntelligence/Step3.png)

4. You'll see "Preparing" label and wait for a while.

![Step4](images/AppleIntelligence/Step4.png)

5. You'll receive "Apple Intelligence is Here" notification.

![Step5](images/AppleIntelligence/Step5.png)

6. You can now turn on Apple Intelligence to use it.

![Step6](images/AppleIntelligence/Step6.png)

## Related links

- https://github.com/Kyle-Ye/eligibility/

- https://gist.github.com/Kyle-Ye/4ad1aa92df3a31bd812487af65e16947
- https://gist.github.com/unixzii/6f25be1842399022e16ad6477a304286

## License

MIT. See LICENSE file.