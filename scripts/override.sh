#!/bin/bash

action=""
if [[ $# -gt 0 ]]; then
  action="$1"
fi

method=""
if [[ $# -gt 1 ]]; then
  method="$2"
fi

key=""
if [[ $# -gt 2 ]]; then
  key="$3"
fi

UTIL_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.2.0/eligibility_util"
UTIL_SIP_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.2.0/eligibility_util_sip"
DOWNLOAD_DIR="/tmp"
UTIL_FILE="${DOWNLOAD_DIR}/eligibility_util"
UTIL_SIP_FILE="${DOWNLOAD_DIR}/eligibility_util_sip"
OVERRIDE_FILE="${DOWNLOAD_DIR}/eligibility_overrides.data"
OVERRIDE_URL="https://github.com/Kyle-Ye/XcodeLLMEligible/releases/download/0.2.0/$key.eligibility_overrides.data"
DAEMON_CONTAINERS_DIR=/private/var/root/Library/Daemon\ Containers

show_usage() {
  echo "Usage: $0 install [util|override] [all|xcodellm|greymatter]"
  echo "Usage: $0 uninstall [util|override] [all|xcodellm|greymatter]"
  echo "Usage: $0 doctor"
  echo "Usage: $0 version"
}

download_file() {
  echo "[download_file] Download started"
  echo "[download_file] Downloading from $1 to $2"
  local url="$1"
  local output_path="$2"
  curl -L -o "$output_path" "$url"
  echo "[download_file] Download completed"
}

method_util() {
  download_file "$UTIL_URL" "$UTIL_FILE"
  chmod +x "$UTIL_FILE"
  case "$key" in
    all)
      echo "[method_util] Setting all to eligible..."
      $UTIL_FILE forceDomainSetAnswer --domain-set 1 --answer 4
      echo "[method_util] Setting Complete..."
      echo "[method_util] Checking the status..."
      "$UTIL_FILE" getDomainAnswer --all
      echo ""
      ;;
    xcodellm)
      echo "[method_util] Setting XcodeLLM to eligible..."
      "$UTIL_FILE" forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM --answer 4
      echo "[method_util] Setting Complete..."
      echo "[method_util] Checking the status..."
      "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
      echo ""
      ;;
    greymatter)
      echo "[method_util] Setting Apple Intelligence to eligible..."
      "$UTIL_FILE" forceDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER --answer 4
      echo "[method_util] Setting Complete..."
      echo "[method_util] Checking the status..."
      "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
      echo ""
      ;;
    *)
      echo "[method_util] Unknown key: $key"
      show_usage
      ;;
  esac
}

method_util_uninstall() {
  download_file "$UTIL_URL" "$UTIL_FILE"
  chmod +x "$UTIL_FILE"
  case "$key" in
    all)
      echo "[method_util_uninstall] Resetting all..."
      $UTIL_FILE resetDomain --all
      echo "[method_util_uninstall] Resetting Complete..."
      echo "[method_util_uninstall] Checking the status..."
      "$UTIL_FILE" getDomainAnswer --all
      echo ""
      ;;
    xcodellm)
      echo "[method_util_uninstall] Resetting XcodeLLM..."
      "$UTIL_FILE" resetDomain --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
      echo "[method_util_uninstall] Resetting Complete..."
      echo "[method_util_uninstall] Checking the status..."
      "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
      echo ""
      ;;
    greymatter)
      echo "[method_util_uninstall] Resetting Apple Intelligence..."
      "$UTIL_FILE" resetDomain --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
      echo "[method_util_uninstall] Resetting Complete..."
      echo "[method_util_uninstall] Checking the status..."
      "$UTIL_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
      echo ""
      ;;
    *)
      echo "[method_util_uninstall] Unknown key: $key"
      show_usage
      ;;
  esac
}

amfi_check() {
  echo "[amfi_check] checking boot-args"
  local boot_args=$(sudo nvram boot-args 2>/dev/null)
  if echo "$boot_args" | grep -q 'amfi_get_out_of_my_way=1'; then
      echo "[amfi_check] amfi_get_out_of_my_way=1 is present in boot-args"
      echo "[amfi_check] Note: You need to reboot to make boot-args changes take effect"
      return 0
  else
      echo "[amfi_check] amfi_get_out_of_my_way=1 is not present in boot-args"
      return 1
  fi
}

check_sip_status() {
  echo "[check_sip_status] checking SIP status..."
  local sip_status=$(csrutil status)
  if echo "$sip_status" | grep -q "enabled"; then
    echo "[check_sip_status] SIP is enabled"
    return 1
  else
    echo "[check_sip_status] SIP is disabled"
    return 0
  fi
}

method_util_check() {
  if check_sip_status && amfi_check; then
    echo "[method_util_check] 🎉 SIP is disabled and amfi_get_out_of_my_way=1 is present in boot-args"
    return 0
  else
    echo "[method_util_check] Please diable SIP and add amfi_get_out_of_my_way=1 to boot-args"
    echo "[method_util_check] Or you can use 'override' method to install"
    return 1
  fi
}

method_override() {
  download_file "$OVERRIDE_URL" "$OVERRIDE_FILE"
  echo "[method_override] Copying eligibility_overrides.data to each Daemon Container..."

  if ! sudo ls "$DAEMON_CONTAINERS_DIR" > /dev/null 2>&1; then
    echo "[method_override] You do not have the permission to read Daemon Container folder $DAEMON_CONTAINERS_DIR"
    echo "[method_override] Please considering granting full disk access in System Preferences > Security & Privacy > Full Disk Access to your Terminal app which the script is running on"
    echo "[method_override] Or you can follow the instruction on README.md"
    exit 1
  fi

  for container in $(sudo ls "$DAEMON_CONTAINERS_DIR"); do
    echo "[method_override] Copying for container $container"
    dest_dir="${DAEMON_CONTAINERS_DIR}/${container}/Data/Library/Caches/NeverRestore/"
    sudo mkdir -p "$dest_dir"
    sudo cp "$OVERRIDE_FILE" "$dest_dir"
    echo "[method_override] Copied to $dest_dir"
  done

  echo ["method_override" killing eligibilityd...]
  sudo pkill -9 eligibilityd
  sudo launchctl kickstart -k system/com.apple.eligibilityd
  download_file "$UTIL_SIP_URL" "$UTIL_SIP_FILE"
  chmod +x "$UTIL_SIP_FILE"
  echo "[method_override] Checking the status..."
  case "$key" in
    all)
      "$UTIL_SIP_FILE" getDomainAnswer --all
      ;;
    xcodellm)
      "$UTIL_SIP_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
      ;;
    greymatter)
      "$UTIL_SIP_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
      ;;
    *)
      echo "[method_override] Unknown key: $key"
      show_usage
      ;;
  esac
}

method_override_uninstall() {
  echo "[method_override_uninstall] Removing eligibility_overrides.data to each Daemon Container..."

  if ! sudo ls "$DAEMON_CONTAINERS_DIR" > /dev/null 2>&1; then
    echo "[method_override_uninstall] You do not have the permission to read Daemon Container folder $DAEMON_CONTAINERS_DIR"
    echo "[method_override_uninstall] Please considering granting full disk access in System Preferences > Security & Privacy > Full Disk Access to your Terminal app which the script is running on"
    echo "[method_override_uninstall] Or you can follow the instruction on README.md"
    exit 1
  fi

  for container in $(sudo ls "$DAEMON_CONTAINERS_DIR"); do
    echo "[method_override_uninstall] Removing for container $container"
    dest_dir="${DAEMON_CONTAINERS_DIR}/${container}/Data/Library/Caches/NeverRestore/"
    sudo rm -rf "$dest_dir"
    echo "[method_override_uninstall] Copied to $dest_dir"
  done

  echo ["method_override_uninstall" killing eligibilityd...]
  sudo pkill -9 eligibilityd
  sudo launchctl kickstart -k system/com.apple.eligibilityd
  download_file "$UTIL_SIP_URL" "$UTIL_SIP_FILE"
  chmod +x "$UTIL_SIP_FILE"
  echo "[method_override_uninstall] Checking the status..."
  case "$key" in
    all)
      "$UTIL_SIP_FILE" getDomainAnswer --all
      ;;
    xcodellm)
      "$UTIL_SIP_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_XCODE_LLM
      ;;
    greymatter)
      "$UTIL_SIP_FILE" getDomainAnswer --domain-name OS_ELIGIBILITY_DOMAIN_GREYMATTER
      ;;
    *)
      echo "[method_override_uninstall] Unknown key: $key"
      show_usage
      ;;
  esac
}

install() {
  echo "[install] started"
  case "$method" in
    util)
      if method_util_check; then
        method_util
      else
        exit 1
      fi
      ;;
    override)
      method_override
      ;;
    *)
      echo "[Install] Unknown method: $method"
      show_usage
      ;;
  esac
  echo "[install] completed"
}

uninstall() {
  echo "[uninstall] started"
  case "$method" in
    util)
      if method_util_check; then
        method_util_uninstall
      else
        exit 1
      fi
      ;;
    override)
      method_override_uninstall
      ;;
    *)
      echo "[uninstall] Unknown method: $method"
      show_usage
      ;;
  esac
  echo "[uninstall] completed"
}

doctor_check() {
  if check_sip_status && amfi_check; then
    echo "[doctor_check] 🎉 SIP is disabled and amfi_get_out_of_my_way=1 is present in boot-args"
    return 0
  else
    echo "[doctor_check] Please diable SIP and add amfi_get_out_of_my_way=1 to boot-args"
    return 1
  fi
}

doctor_action() {
  download_file "$UTIL_URL" "$UTIL_FILE"
  chmod +x "$UTIL_FILE"
  "$UTIL_FILE" getStateDump
}

doctor() {
  if doctor_check; then
    doctor_action
  else
    exit 1
  fi
}

entrypoint() {
  echo "Performing with [action]=$action [method]=$method [key]=$key"
  case "$action" in
    install)
      install
      ;;
    uninstall)
      uninstall
      ;;
    doctor)
      doctor
      ;;
    version)
      echo "Version: 0.2.0"
      ;;
    *)
      echo "Unknown action: $action"
      show_usage
      ;;
  esac

  echo "If you find this script helpful, please consider giving a star to the project."
  echo "🌟🌟🌟 https://github.com/Kyle-Ye/XcodeLLMEligible 🌟🌟🌟"
}

entrypoint