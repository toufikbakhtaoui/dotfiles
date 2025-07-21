# ~/scripts/log.sh
log() {
  local level="$1"
  local message="$2"

  local color_code=""
  local reset_code="\033[0m"
  local prefix=""

  case "$level" in
    info)
      color_code="\033[0;34m" # blue
      prefix="ℹ️  INFO:"
      ;;
    success)
      color_code="\033[0;32m" # green
      prefix="✅ SUCCESS:"
      ;;
    warn)
      color_code="\033[1;33m" # yellow
      prefix="⚠️  WARNING:"
      ;;
    error)
      color_code="\033[0;31m" # red
      prefix="❌ ERROR:"
      ;;
    *)
      prefix="👉 LOG:"
      ;;
  esac

  if [[ "$level" == "error" ]]; then
    echo -e "${color_code}${prefix} ${message}${reset_code}" >&2
  else
    echo -e "${color_code}${prefix} ${message}${reset_code}"
  fi
}

