#!/usr/bin/env bash

set -euo pipefail

echo "🧹 Rollback script – attention : cette opération est destructive !"

# This script deletes chezmoi's state file so you can re-run run_once scripts.
# Useful during development or testing of your dotfiles on fresh macOS installs.

chezmoi state reset

rm -rf ~/.local/state/chezmoi

# 1. Supprimer .oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "🗑 Removing ~/.oh-my-zsh"
  rm -rf "$HOME/.oh-my-zsh"
fi

# 2. Supprimer fichiers générés par chezmoi
echo "🧼 Cleaning up dotfiles..."
rm -f "$HOME/.zshrc"
rm -f "$HOME/.zsh_aliases"
rm -rf "$HOME/.config/nvim"
rm -rf "$HOME/.config/zsh"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.gitignoreglobal"

# 4. Supprimer plugins installés par chezmoi (zsh-autosuggestions, etc.)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
rm -rf "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
rm -rf "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# 5. (Optionnel) Désinstaller tous les paquets installés via le Brewfile
read -p "❓ Veux-tu désinstaller tous les paquets installés via Homebrew ? (y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  echo "🍺 Uninstalling all Homebrew packages..."
  if command -v brew &>/dev/null; then
  echo -e "🍺 Uninstalling Homebrew packages..."
  brew bundle dump --force 2>/dev/null  # Backup current Brewfile
  brew remove --force $(brew list) 2>/dev/null
  brew cleanup --prune=all -s && echo -e "Brew packages removed."
  fi
fi

echo "✅ Environnement rollbacké. Tu peux maintenant tester chezmoi à nouveau."

