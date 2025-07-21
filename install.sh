#!/bin/bash

# ─────────────────────────────────────────────
# Start macOS configuration setup
# ─────────────────────────────────────────────

set -eo pipefail

# ─────────────────────────────────────────────
# Ensure the user has admin rights and sudo access
# ─────────────────────────────────────────────

if ! groups | grep -q admin; then
  echo "❌ You must run this script with an admin user (user must be in the 'admin' group)."
  exit 1
fi

echo "🔐 Requesting sudo permissions..."
sudo -v

# Keep sudo session alive while the script runs
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ─────────────────────────────────────────────
# Install Xcode CLI Tools
# ─────────────────────────────────────────────

echo "✓ Checking Xcode CLI Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "→ Installing Xcode CLI Tools"
    xcode-select --install || {
      echo "❌ Failed to trigger CLI Tools installation"
      exit 1
    }

    # Wait for installation to complete
    echo "⏳ Waiting for CLI Tools installation to complete..."
    while ! xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Accept Xcode license if full Xcode is installed (optional)
if command -v xcodebuild &>/dev/null; then
  if [[ "$(xcode-select -p)" != *"CommandLineTools" ]]; then
    echo "✓ Accepting Xcode license"
    sudo xcodebuild -license accept
  else
    echo "ℹ️ Full Xcode not installed — skipping license acceptance."
  fi
fi

# ─────────────────────────────────────────────
# Install Homebrew 
# ─────────────────────────────────────────────

echo "✓ Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "📦 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        echo "❌ Homebrew installation failed."
        exit 1
    }

    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
    else
        echo "❌ Homebrew installed but not found in standard locations."
        exit 1
    fi
else
    echo "✅ Homebrew is already installed."
    eval "$(brew shellenv)"
fi

# ─────────────────────────────────────────────
# Install and start chezmoi
# ─────────────────────────────────────────────
echo "📦 Installing chezmoi..."
brew install chezmoi

echo "🚀 Initializing chezmoi with your dotfiles..."
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --verbose --apply toufikbakhtaoui
