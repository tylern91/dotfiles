# Homebrew prefix (Apple Silicon — hardcoded for startup performance)
BREW_PREFIX=/opt/homebrew

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------------------------------------------------------------------
# Antidote — static plugin bundle (regenerated only when .txt changes)
# ---------------------------------------------------------------------------
# Homebrew site-functions must be in FPATH before antidote processes kind:fpath plugins
[[ -d "$BREW_PREFIX/share/zsh/site-functions" ]] && FPATH="$BREW_PREFIX/share/zsh/site-functions:$FPATH"

# zsh-autosuggestions: async fetch (non-blocking) + completions as fallback strategy
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

zsh_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins"
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  source "$BREW_PREFIX/opt/antidote/share/antidote/antidote.zsh"
  antidote bundle <"${zsh_plugins}.txt" >"${zsh_plugins}.zsh"
fi
source "${zsh_plugins}.zsh"

# history-substring-search key bindings (must come after antidote bundle is sourced)
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# ---------------------------------------------------------------------------
# Completion system
# ---------------------------------------------------------------------------

# Cache dir for eval-output caches and third-party fpath completions
_ZSH_CACHE_DIR="$HOME/.zsh/cache"
_ZSH_COMPLETIONS_DIR="$HOME/.zsh/completions"
mkdir -p "$_ZSH_CACHE_DIR" "$_ZSH_COMPLETIONS_DIR"
FPATH="$_ZSH_COMPLETIONS_DIR:$FPATH"

# Poetry completions (cached as fpath file to avoid _tags errors)
if [[ ! -f "$_ZSH_COMPLETIONS_DIR/_poetry" ]] && command -v poetry &>/dev/null; then
  poetry completions zsh > "$_ZSH_COMPLETIONS_DIR/_poetry" 2>/dev/null
fi

# Initialize completion — full scan at most once per day
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion behaviour
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' rehash true

# ---------------------------------------------------------------------------
# Tool integrations (cached eval outputs)
# ---------------------------------------------------------------------------
# autojump (provides the `j` command)
[ -f "$BREW_PREFIX/etc/profile.d/autojump.sh" ] && source "$BREW_PREFIX/etc/profile.d/autojump.sh"

# npm completions (cached)
_NPM_COMPLETION_CACHE="$_ZSH_CACHE_DIR/npm_completion.zsh"
if [[ ! -f "$_NPM_COMPLETION_CACHE" ]] && command -v npm &>/dev/null; then
  npm completion > "$_NPM_COMPLETION_CACHE" 2>/dev/null
fi
[[ -f "$_NPM_COMPLETION_CACHE" ]] && source "$_NPM_COMPLETION_CACHE"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
_PYENV_CACHE="$_ZSH_CACHE_DIR/pyenv.zsh"
if [[ ! -f "$_PYENV_CACHE" || "$PYENV_ROOT/bin/pyenv" -nt "$_PYENV_CACHE" ]]; then
  pyenv init - zsh > "$_PYENV_CACHE" 2>/dev/null
fi
source "$_PYENV_CACHE"

# direnv (cached)
_DIRENV_CACHE="$_ZSH_CACHE_DIR/direnv.zsh"
if [[ ! -f "$_DIRENV_CACHE" ]]; then
  direnv hook zsh > "$_DIRENV_CACHE" 2>/dev/null
fi
source "$_DIRENV_CACHE"

# goenv (cached)
_GOENV_CACHE="$_ZSH_CACHE_DIR/goenv.zsh"
if [[ ! -f "$_GOENV_CACHE" ]]; then
  goenv init - > "$_GOENV_CACHE" 2>/dev/null
fi
source "$_GOENV_CACHE"

# NVM — lazy loaded on first call (node@24 in PATH handles daily use)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}

# Angular CLI autocompletion (cached)
_NG_COMPLETION_CACHE="$_ZSH_CACHE_DIR/ng_completion.zsh"
if [[ ! -f "$_NG_COMPLETION_CACHE" ]] && command -v ng &>/dev/null; then
  ng completion script > "$_NG_COMPLETION_CACHE" 2>/dev/null
fi
[[ -f "$_NG_COMPLETION_CACHE" ]] && source "$_NG_COMPLETION_CACHE"

# fzf — fuzzy finder keybindings + completion (Ctrl+R history, Ctrl+T file, Alt+C cd)
_FZF_CACHE="$_ZSH_CACHE_DIR/fzf.zsh"
if [[ ! -f "$_FZF_CACHE" ]] && command -v fzf &>/dev/null; then
  fzf --zsh > "$_FZF_CACHE" 2>/dev/null
fi
[[ -f "$_FZF_CACHE" ]] && source "$_FZF_CACHE"

# Azure CLI
autoload bashcompinit && bashcompinit
[[ -f "$BREW_PREFIX/etc/bash_completion.d/az" ]] && source "$BREW_PREFIX/etc/bash_completion.d/az"

# Ghostty shell-integration = zsh handles CWD (OSC 7), window title, and prompt
# marks natively — new tabs/splits inherit CWD automatically, no precmd hook needed.

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.kubescape/bin"
export PATH="$PATH:$HOME/.lmstudio/bin"

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export EDITOR="vim"
export VISUAL="vim"
export GPG_TTY=$(tty)
export HISTFILE=~/.zsh_history
export SAVEHIST=1000000000
export HISTSIZE=1000000000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# ---------------------------------------------------------------------------
# Aliases — Git
# ---------------------------------------------------------------------------
alias gitsync="git fetch && git pull"
alias grm="git rebase main"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias grs="git rebase --skip"
alias gpo="git push origin"
alias gpl="git pull"
alias gps="git push"
alias gplo="git pull origin"
alias gs="git stash"
alias gsa="git stash apply"

# ---------------------------------------------------------------------------
# Aliases — Docker
# ---------------------------------------------------------------------------
alias dps="docker ps"
alias dk="docker kill"
alias dpsa="docker ps -a"
alias drm="docker rm"

# ---------------------------------------------------------------------------
# Aliases — Kubernetes
# ---------------------------------------------------------------------------
alias k="kubectl"
alias kx="kubectx"
alias kinfo="kubectl cluster-info"
alias kneat="kubectl neat"
alias kns="kubens"
alias kgp="kubectl get pods"
alias kdp="kubectl describe pods"
alias kgs="kubectl get svc"
alias kds="kubectl describe svc"
alias kgcm="kubectl get configmap"
alias kdcm="kubectl describe configmap"
alias kging="kubectl get ingress"
alias kding="kubectl describe ingress"
alias kgsec="kubectl get secret"
alias kdsec="kubectl describe secret"
alias kgd="kubectl get deployment"
alias kdd="kubectl describe deployment"
alias kgpvc="kubectl get pvc"
alias kdpvc="kubectl describe pvc"
alias kgpv="kubectl get pv"
alias kdpv="kubectl describe pv"
alias kgc="kubectl get componentstatuses"

# ---------------------------------------------------------------------------
# Aliases — Terraform / Terragrunt
# ---------------------------------------------------------------------------
alias tf="terraform"
alias tfinit="terraform init"
alias tfplan="terraform plan"
alias tfapply="terraform apply"
alias tfmt="terraform fmt"
alias tg="terragrunt"
alias tginit="terragrunt init"
alias tgplan="terragrunt plan"
alias tgapply="terragrunt apply"

# ---------------------------------------------------------------------------
# Aliases — General
# ---------------------------------------------------------------------------
alias zshconf="vim ~/.zshrc"
alias vi="vim"
alias cl="clear"
alias la="ls -lah"
alias fopen="open"
alias git-sync="find . -maxdepth 1 -type d -print -exec git -C {} fetch \; -exec git -C {} pull \;"

# ---------------------------------------------------------------------------
# Aliases — Proxy / SOCKS
# ---------------------------------------------------------------------------
alias setsock='unset HTTP_PROXY && unset HTTPS_PROXY && unset ALL_PROXY && export HTTP_PROXY=socks5://localhost:4000 && export HTTPS_PROXY=socks5://localhost:4000 && export ALL_PROXY=socks5://localhost:4000'
alias unsetsock='unset HTTP_PROXY && unset HTTPS_PROXY && unset ALL_PROXY'

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------
function setawscontext() {
  export AWS_PROFILE="$1"
  unsetsock
  setsock
  kx "$2"
}
