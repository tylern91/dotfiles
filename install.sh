#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# tylern91/dotfiles installer — macOS only (Ghostty + Zsh + Antidote)
# Uses GNU Stow to symlink configs into $HOME
# ---------------------------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE="$DOTFILES_DIR/.install-state"

# ---------- Checkpoint ------------------------------------------------------

step_done()      { [[ -f "$STATE_FILE" ]] && grep -qxF "${1}:${2}" "$STATE_FILE"; }
mark_step_done() { echo "${1}:${2}" >> "$STATE_FILE"; }

clear_steps() {
  [[ -f "$STATE_FILE" ]] || return
  { grep -v "^${1}:" "$STATE_FILE" || true; } > "${STATE_FILE}.tmp"
  mv "${STATE_FILE}.tmp" "$STATE_FILE"
}

run_step() {
  local cmd="$1" step="$2" fn="$3"
  if step_done "$cmd" "$step"; then
    log_info "  [skip] $step (already completed)"
    return
  fi
  "$fn"
  mark_step_done "$cmd" "$step"
}

# ---------- Checks ---------------------------------------------------------

check_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    log_error "This dotfiles repo is for macOS only."
    exit 1
  fi
}

command_exists() { command -v "$1" &>/dev/null; }

ensure_homebrew() {
  if command_exists brew; then return; fi
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  log_success "Homebrew installed"
}

ensure_stow() {
  if command_exists stow; then return; fi
  log_info "Installing GNU Stow..."
  brew install stow
  log_success "GNU Stow installed"
}

# ---------- Backup ----------------------------------------------------------

backup_dotfiles() {
  local backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  local targets=(.zshrc .zsh_plugins.txt .p10k.zsh .config/ghostty .config/git)
  local backed_up=false

  for target in "${targets[@]}"; do
    local full="$HOME/$target"
    if [[ -e "$full" && ! -L "$full" ]]; then
      if [[ "$backed_up" == false ]]; then
        mkdir -p "$backup_dir"
        backed_up=true
        log_info "Backing up existing dotfiles to $backup_dir"
      fi
      mkdir -p "$(dirname "$backup_dir/$target")"
      mv "$full" "$backup_dir/$target"
      log_info "  backed up: $target"
    fi
  done

  if [[ "$backed_up" == true ]]; then
    log_success "Backup complete: $backup_dir"
  else
    log_info "No existing dotfiles to back up"
  fi
}

# ---------- Brew bundle -----------------------------------------------------

install_brewfile() {
  if [[ ! -f "$DOTFILES_DIR/Brewfile" ]]; then
    log_warning "No Brewfile found, skipping brew bundle"
    return
  fi
  log_info "Installing Homebrew dependencies from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  log_success "Brew dependencies installed"
}

# ---------- Stow ------------------------------------------------------------

stow_packages() {
  cd "$DOTFILES_DIR"

  log_info "Stowing common configurations..."
  stow -t "$HOME" -v --ignore='.*\.DS_Store.*' --adopt common

  if [[ -d macos ]]; then
    log_info "Stowing macOS-specific configurations..."
    stow -t "$HOME" -v --ignore='.*\.DS_Store.*' --adopt macos
  fi

  log_success "All packages stowed"
}

unstow_packages() {
  cd "$DOTFILES_DIR"
  log_info "Unstowing all packages..."
  stow -t "$HOME" -Dv common 2>/dev/null || true
  stow -t "$HOME" -Dv macos  2>/dev/null || true
  log_success "Unstow complete"
}

# ---------- Antidote --------------------------------------------------------

setup_antidote() {
  if ! command_exists antidote; then
    log_info "Installing Antidote..."
    brew install antidote
    log_success "Antidote installed"
  fi

  log_info "Generating Antidote static plugin bundle..."
  local plugins_txt="$HOME/.zsh_plugins.txt"
  local plugins_zsh="$HOME/.zsh_plugins.zsh"

  if [[ -f "$plugins_txt" ]]; then
    source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
    antidote bundle <"$plugins_txt" >"$plugins_zsh"
    log_success "Static plugin bundle generated: ~/.zsh_plugins.zsh"
  else
    log_warning "~/.zsh_plugins.txt not found — stow first, then re-run setup"
  fi
}

# ---------- Fonts -----------------------------------------------------------

install_fonts() {
  log_info "Installing terminal fonts..."
  brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
  log_success "Fonts installed"
}

# ---------- Usage -----------------------------------------------------------

show_usage() {
  echo "Usage: $0 [command]"
  echo ""
  echo "Commands:"
  echo "  install      Full install: backup, brew deps, stow, antidote (default)"
  echo "  uninstall    Remove all dotfile symlinks"
  echo "  restow       Re-stow (uninstall + install)"
  echo "  brew         Install Homebrew dependencies only"
  echo "  antidote     Regenerate Antidote static plugin bundle"
  echo "  fonts        Install terminal fonts"
  echo "  backup       Backup existing dotfiles only"
  echo "  status       Show current dotfiles status"
  echo "  reset        Clear checkpoint state (force fresh run)"
  echo "  help         Show this message"
}

# ---------- Status ----------------------------------------------------------

show_status() {
  echo "=== Dotfiles Status ==="
  echo "Directory: $DOTFILES_DIR"
  echo ""

  echo "Tools:"
  for tool in brew stow antidote ghostty zsh pyenv direnv goenv nvm kubectl terraform; do
    if command_exists "$tool"; then
      echo "  ✓ $tool"
    else
      echo "  ✗ $tool"
    fi
  done

  echo ""
  echo "Symlinks:"
  for target in .zshrc .zsh_plugins.txt .p10k.zsh .config/ghostty; do
    local full="$HOME/$target"
    if [[ -L "$full" ]]; then
      echo "  ✓ ~/$target -> $(readlink "$full")"
    elif [[ -e "$full" ]]; then
      echo "  ! ~/$target (exists but not a symlink)"
    else
      echo "  ✗ ~/$target (missing)"
    fi
  done

  echo ""
  echo "Checkpoints ($STATE_FILE):"
  if [[ -f "$STATE_FILE" ]] && [[ -s "$STATE_FILE" ]]; then
    while IFS= read -r line; do
      echo "  ✓ $line"
    done < "$STATE_FILE"
  else
    echo "  (none)"
  fi
}

# ---------- Main ------------------------------------------------------------

main() {
  local command="${1:-install}"

  check_macos

  case "$command" in
    install)
      run_step install homebrew  ensure_homebrew
      run_step install stow      ensure_stow
      run_step install backup    backup_dotfiles
      run_step install brewfile  install_brewfile
      run_step install stow_pkgs stow_packages
      run_step install antidote  setup_antidote
      run_step install fonts     install_fonts
      clear_steps install
      echo ""
      log_success "✓ Dotfiles installation complete!"
      log_info "Open a new terminal (Ghostty) to use your new config."
      ;;
    uninstall)
      unstow_packages
      ;;
    restow)
      run_step restow homebrew  ensure_homebrew
      run_step restow stow      ensure_stow
      run_step restow unstow    unstow_packages
      run_step restow stow_pkgs stow_packages
      run_step restow antidote  setup_antidote
      clear_steps restow
      log_success "Restow complete"
      ;;
    brew)
      ensure_homebrew
      install_brewfile
      ;;
    antidote)
      setup_antidote
      ;;
    fonts)
      ensure_homebrew
      install_fonts
      ;;
    backup)
      backup_dotfiles
      ;;
    status)
      show_status
      ;;
    reset)
      if [[ -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
        log_success "Checkpoint state cleared — next run will start fresh"
      else
        log_info "No checkpoint state found"
      fi
      ;;
    -h|--help|help)
      show_usage
      ;;
    *)
      log_error "Unknown command: $command"
      show_usage
      exit 1
      ;;
  esac
}

main "$@"
