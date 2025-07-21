#!/bin/bash

# ─────────────────────────────────────────────
#  Start macos configuration setup
# ─────────────────────────────────────────────

set -eo pipefail

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --verbose --apply toufikbakhtaoui
