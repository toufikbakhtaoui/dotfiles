#!/bin/bash

# ─────────────────────────────────────────────
# Start macos configuration setup
# ─────────────────────────────────────────────

set -eo pipefail

LOG_PATH="${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}/scripts/log.sh"
source "$LOG_PATH"

# ─────────────────────────────────────────────
# Install Xcode ClI Tools
# ─────────────────────────────────────────────

log info "✓ Checking Xcode CLI Tools"
if ! xcode-select -p &>/dev/null; then
    log info "→ Installing Xcode CLI Tools"
    xcode-select --install || fail "Failed to install Xcode CLI Tools"
    # Wait for installation to complete
    while ! xcode-select -p &>/dev/null; do
        sleep 5
    done
    sudo xcodebuild -license accept
fi

# ─────────────────────────────────────────────
# Install Homebrew 
# ─────────────────────────────────────────────

log info "✓ Checking Homebrew..."

  if ! command -v brew &>/dev/null; then
    log info "📦 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || \
      fail "Homebrew installation failed."

    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    elif [[ -x "/usr/local/bin/brew" ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
    else
      fail "Homebrew was installed but not found in standard locations."
    fi
  else
    log success "✅ Homebrew is already installed."
    eval "$(brew shellenv)"
  fi
# ─────────────────────────────────────────────
# Install and start chezmoi
# ─────────────────────────────────────────────
brew install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --verbose --apply toufikbakhtaoui
