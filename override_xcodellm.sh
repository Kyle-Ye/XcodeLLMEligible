#!/bin/bash

UTIL_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/latest/download/eligibility_util"
UTIL_SIP_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/latest/download/eligibility_util_sip"
OVERRIDE_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/latest/download/eligibility_overrides.data"
DOWNLOAD_DIR="/tmp"
UTIL_FILE="${DOWNLOAD_DIR}/eligibility_util"
UTIL_SIP_FILE="${DOWNLOAD_DIR}/eligibility_util_sip"
OVERRIDES_FILE="${DOWNLOAD_DIR}/eligibility_overrides.data"
DAEMON_CONTAINERS_DIR=~/Library/Daemon\ Containers/

download_file() {
  local url="$1"
  local output_path="$2"
  curl -L -o "$output_path" "$url"
}

method_util() {
  echo "Downloading eligibility_util..."
  echo ""
  download_file "$UTIL_URL" "$UTIL_FILE"
  chmod +x "$UTIL_FILE"
  echo "Setting XcodeLLM to eligible..."
  "$UTIL_FILE" forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4
  echo "Setting Greymatter (Apple Intelligence) to eligible"
  "$UTIL_FILW" forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER --answer 4
  echo "Setting Complete..."
  echo ""
  echo "Checking the status..."
  "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
  "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
  echo ""
}

method_override() {
  echo "Downloading eligibility_overrides.data..."
  echo ""
  download_file "$OVERRIDE_URL" "$OVERRIDES_FILE"
  echo "Copying eligibility_overrides.data to each Daemon Container..."
  echo ""
  if ls "$DAEMON_CONTAINERS_DIR"; then
    for dir in "$DAEMON_CONTAINERS_DIR"*/ ; do
      if [[ -d "$dir" ]]; then
        dest_dir="${dir}Data/Library/Caches/NeverRestore/"
        mkdir -p "$dest_dir"
        cp "$OVERRIDES_FILE" "$dest_dir"
        echo "Copied to $dest_dir"
      fi
    done
    echo "Downloading eligibility_util_sip..."
    echo ""
    download_file "$UTIL_SIP_URL" "$UTIL_SIP_FILE"
    chmod +x "$UTIL_SIP_FILE"
    echo "Checking the status..."
    "$UTIL_SIP_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
    echo ""
  else
    echo "You do not have the permission to read Daemon Container folder."
    echo "Please considering granting full disk access in System Preferences > Security & Privacy > Full Disk Access to your Terminal app which the script is running on."
    echo "Or you can follow the instruction on README.md to copy the files manually via Finder operation."
    echo ""
    exit 1
  fi
}

check_sip_status() {
  local sip_status=$(csrutil status)
  if echo "$sip_status" | grep -q "enabled"; then
    echo "SIP is enabled."
    echo ""
    return 1
  else
    echo "SIP is disabled."
    echo ""
    return 0
  fi
}

amfi_check() {
    local boot_args=$(sudo nvram boot-args 2>/dev/null)
    if echo "$boot_args" | grep -q 'amfi_get_out_of_my_way=1'; then
        echo "amfi_get_out_of_my_way=1 is present in boot-args."
        return 0
    else
        echo "amfi_get_out_of_my_way=1 is not present in boot-args."
        return 1
    fi
}

uninstall() {
  echo "Uninstalling..."
  echo "Removing eligibility_overrides.data from Daemon Containers..."
  echo ""
  for dir in "$DAEMON_CONTAINERS_DIR"*/ ; do
    if [[ -d "$dir" ]]; then
      dest_file="${dir}Data/Library/Caches/NeverRestore/eligibility_overrides.data"
      if [[ -f "$dest_file" ]]; then
        rm -rf "$dest_file"
        echo "Removed $dest_file"
      fi
    fi
  done
}

action="install"
if [[ $# -gt 0 ]]; then
  action="$1"
fi

case "$action" in
  install)
    echo "Performing install action..."
    echo ""
    if check_sip_status; then
      if amfi_check; then
        echo "🎉 SIP is disabled and amfi_get_out_of_my_way=1 is present in boot-args."
        echo ""
        method_util
      else
        echo "[Warning] SIP is disabled but amfi_get_out_of_my_way=1 is not present in boot-args."
        echo "Fallback to use not recommended override file method."
        echo ""
        method_override
      fi
    else
      echo "[Warning] SIP is enabled."
      echo "Fallback to use not recommended override file method."
      echo ""
      method_override
    fi
    echo "XcodeLLM eligible override script install completed."
    echo "If you find this script helpful, please consider give a star to the project."
    echo "🌟🌟🌟 https://github.com/Kyle-Ye/XcodeLLMEligible 🌟🌟🌟"
    ;;
  uninstall)
    uninstall
    echo "XcodeLLM eligible override script uninstall completed."
    ;;
  *)
    echo "Unknown action: $action"
    echo "Usage: $0 [install|uninstall]"
    exit 1
    ;;
esac
