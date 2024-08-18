#!/bin/bash

UTIL_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.1.0/eligibility_util"
DOWNLOAD_DIR="/tmp"
UTIL_FILE="${DOWNLOAD_DIR}/eligibility_util"

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
  echo "Setting Apple Intelligence to eligible..."
  "$UTIL_FILE" forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER --answer 4
  echo "Setting Complete..."
  echo ""
  echo "Checking the status..."
  "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
  echo ""
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
        echo "[Error] SIP is disabled but amfi_get_out_of_my_way=1 is not present in boot-args."
        exit 1
      fi
    else
      echo "[Error] SIP is enabled."
      exit 1
    fi
    echo "Apple Intelligence eligible override script install completed."
    echo "If you find this script helpful, please consider giving a star to the project."
    echo "🌟🌟🌟 https://github.com/Kyle-Ye/XcodeLLMEligible 🌟🌟🌟"
    ;;
  *)
    echo "Unknown action: $action"
    echo "Usage: $0 [install]"
    exit 1
    ;;
esac