---
title: Stow a Specific App
type: command
icon: 📦
---

# Stow a Specific Application

Install configuration for a specific application.

Usage:
```bash
stow -t "$HOME" -v --adopt <package>
```

Available packages: common, macos

Examples:
```bash
# Stow cross-platform configs (zsh, git, etc.)
stow -t "$HOME" -v --adopt common

# Stow macOS-specific configs (ghostty, etc.)
stow -t "$HOME" -v --adopt macos

# Or use the installer to stow everything
./install.sh restow
```
