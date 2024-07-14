#!/bin/bash

UTIL_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.1.0/eligibility_util"
OVERRIDE_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.1.0/eligibility_overrides.data"
DOWNLOAD_DIR="/tmp"
UTIL_FILE="${DOWNLOAD_DIR}/eligibility_util"
OVERRIDES_FILE="${DOWNLOAD_DIR}/eligibility_overrides.data"
DAEMON_CONTAINERS_DIR=~/Library/Daemon\ Containers/

download_file() {
  local url="$1"
  local output_path="$2"
  curl -L -o "$output_path" "$url"
}

method_util() {
  echo "Downloading eligibility_util..."
  download_file "$UTIL_URL" "$UTIL_FILE"
  chmod +x "$UTIL_FILE"
  echo "Setting XcodeLLM to eligible..."
  "$UTIL_FILE" forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4
  echo "Setting Complete..."
  echo "You can check the status by running $UTIL_FILE getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
}

method_override() {
  echo "Downloading eligibility_overrides.data..."
  download_file "$OVERRIDE_URL" "$OVERRIDES_FILE"
  echo "Copying eligibility_overrides.data to each Daemon Container..."
  for dir in "$DAEMON_CONTAINERS_DIR"*/ ; do
    if [[ -d "$dir" ]]; then
      dest_dir="${dir}Data/Library/Caches/NeverRestore/"
      mkdir -p "$dest_dir"
      cp "$OVERRIDES_FILE" "$dest_dir"
      echo "Copied to $dest_dir"
    fi
  done
}

check_sip_status() {
  local sip_status=$(csrutil status)
  if echo "$sip_status" | grep -q "enabled"; then
    echo "SIP is enabled."
    return 1
  else
    echo "SIP is disabled."
    return 0
  fi
}

uninstall() {
  echo "Uninstalling..."
  echo "Removing eligibility_overrides.data from Daemon Containers..."
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
    if check_sip_status; then
      method_util
    else
      method_override
    fi
    echo "XcodeLLM eligible override script completed."
    echo "If you find this script helpful, please consider give a star to the project.
    echo "🌟🌟🌟 https://github.com/Kyle-Ye/XcodeLLMEligible 🌟🌟🌟"
    ;;
  uninstall)
    uninstall
    ;;
  *)
    echo "Unknown action: $action"
    echo "Usage: $0 [install|uninstall]"
    exit 1
    ;;
esac
