# dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), built around **Ghostty + Zsh + Antidote**.

## Stack

| Layer | Tool |
| :---: | :--- |
| Terminal | [Ghostty](https://ghostty.org/) — GPU-accelerated, native macOS |
| Shell | Zsh (macOS default) |
| Plugin manager | [Antidote](https://getantidote.github.io/) — static bundles, zero runtime overhead |
| Prompt | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) with instant prompt |
| Dotfile manager | [GNU Stow](https://www.gnu.org/software/stow/) |

## Quick Start

```sh
# Clone
git clone https://github.com/tylern91/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Full install (backup existing, brew deps, stow, antidote, fonts)
./install.sh install

# Or run components separately
./install.sh brew         # Install Homebrew dependencies only
./install.sh antidote     # Regenerate Antidote static plugin bundle
./install.sh fonts        # Install terminal fonts
./install.sh backup       # Backup existing dotfiles only
./install.sh uninstall    # Remove all symlinks
./install.sh restow       # Re-stow (uninstall + install)
./install.sh status       # Show current dotfiles status
```

## Repository Structure

```sh
dotfiles/
├── common/                    # Configs stowed to $HOME
│   ├── .zshrc                 # Zsh configuration
│   ├── .zsh_plugins.txt       # Antidote plugin list
│   └── .config/
│       └── git/config         # Git configuration
├── macos/                     # macOS-specific configs stowed to $HOME
│   └── .config/
│       └── ghostty/config     # Ghostty terminal configuration
├── Brewfile                   # Homebrew dependencies
├── install.sh                 # Installation script
├── .stow-local-ignore         # Files Stow should skip
└── README.md
```

## How It Works

GNU Stow creates symlinks from the repo into `$HOME`. Each top-level directory (`common/`, `macos/`) is a "stow package":

```sh
# After stowing:
~/.zshrc              → ~/.dotfiles/common/.zshrc
~/.zsh_plugins.txt    → ~/.dotfiles/common/.zsh_plugins.txt
~/.config/ghostty/    → ~/.dotfiles/macos/.config/ghostty/
~/.config/git/config  → ~/.dotfiles/common/.config/git/config
```

## Zsh Performance

Startup is optimised with:

- **Antidote static bundles** — plugins compiled to a single `.zsh` file, regenerated only when the plugin list changes
- **Cached eval outputs** — `pyenv init`, `direnv hook`, `goenv init`, `npm completion` cached to `~/.zsh/cache/`
- **Lazy-loaded NVM** — only initialises on first `nvm` call; `node@24` in PATH handles daily use
- **Smart compinit** — full completion rescan at most once per day

## Cache Invalidation

After updating tools, clear the relevant cache:

```sh
# Delete one:
rm ~/.zsh/cache/pyenv.zsh       # regenerates on next shell start
rm ~/.zsh/cache/direnv.zsh
rm ~/.zsh/cache/goenv.zsh
rm ~/.zsh/cache/npm_completion.zsh
rm ~/.zsh/cache/ng_completion.zsh
rm ~/.zsh/completions/_poetry    # regenerates on next shell start

# Or nuke all caches:
rm -rf ~/.zsh/cache ~/.zsh/completions

# Regenerate Antidote bundle after editing .zsh_plugins.txt:
./install.sh antidote
```

## Adding New Configs

```sh
# Cross-platform tool → common/
mkdir -p common/.config/new-tool
cp ~/.config/new-tool/* common/.config/new-tool/
stow -t "$HOME" -v --adopt common

# macOS-specific tool → macos/
mkdir -p macos/.config/mac-tool
cp ~/.config/mac-tool/* macos/.config/mac-tool/
stow -t "$HOME" -v --adopt macos
```

## License

MIT License. See [LICENSE](LICENSE).
