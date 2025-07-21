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
# Start chezmoi
# ─────────────────────────────────────────────

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --verbose --apply toufikbakhtaoui
