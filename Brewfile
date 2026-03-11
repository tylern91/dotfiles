# ---------------------------------------------------------------------------
# Brewfile — tylern91/dotfiles
# Install with: brew bundle --file=Brewfile
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Taps
# ---------------------------------------------------------------------------
tap "coinbase/assume-role"
tap "derailed/popeye"
tap "devopyio/yamlfmt"
tap "discoteq/discoteq"
tap "etopeter/tap"
tap "golangci/tap"
tap "hashicorp/tap"
tap "johanhaleby/kubetail"
tap "martido/graph"
tap "remind101/formulae"
tap "robscott/tap"
tap "romkatv/powerlevel10k"
tap "snyk/tap"
tap "spacelift-io/spacelift"
tap "teamookla/speedtest"
tap "weaveworks/tap"

# ---------------------------------------------------------------------------
# Terminal & Shell
# ---------------------------------------------------------------------------
cask "ghostty"                          # GPU-accelerated terminal (primary)
brew "antidote"                         # Zsh plugin manager (static bundles)
brew "powerlevel10k"                    # Zsh prompt theme
brew "autojump"                         # Smart cd with `j`
brew "zsh"                              # Zsh shell
brew "zsh-autosuggestions"              # Fish-like autosuggestions
brew "zsh-completions"                  # Additional completion definitions
brew "zsh-syntax-highlighting"          # Fish-like syntax highlighting
brew "tmux"                             # Terminal multiplexer

# ---------------------------------------------------------------------------
# Version Managers & Language Runtimes
# ---------------------------------------------------------------------------
brew "pyenv"                            # Python version manager
brew "goenv"                            # Go version manager
brew "nvm"                              # Node version manager (lazy-loaded)
brew "node@24"                          # System Node.js
brew "poetry"                           # Python dependency management
brew "pipenv"                           # Python dependency management (alt)
brew "pipx"                             # Python package runner in isolated envs
brew "rbenv"                            # Ruby version manager
brew "ruby-build"                       # Ruby version installer
brew "ruby"                             # Ruby
brew "openjdk@25"                       # Java 25 LTS

# ---------------------------------------------------------------------------
# DevOps / Kubernetes
# ---------------------------------------------------------------------------
brew "kubernetes-cli"                   # kubectl
brew "kubectx"                          # Switch contexts/namespaces
brew "kubent"                           # Check deprecated APIs
brew "helm"                             # Kubernetes package manager
brew "argocd"                           # GitOps CD for Kubernetes
brew "stern"                            # Multi-pod log tailing
brew "velero"                           # Kubernetes backup/recovery
brew "minikube"                         # Local Kubernetes cluster
brew "chart-testing"                    # Helm chart linting/testing
brew "derailed/popeye/popeye"           # Kubernetes cluster sanitizer
brew "etopeter/tap/kubectl-view-utilization"  # CPU/Memory utilization
brew "johanhaleby/kubetail/kubetail"    # Multi-pod log tailing (alt)
brew "robscott/tap/kube-capacity"       # Cluster resource overview

# ---------------------------------------------------------------------------
# Infrastructure as Code
# ---------------------------------------------------------------------------
brew "tfenv"                            # Terraform version manager
brew "terraform-docs"                   # Terraform module documentation
brew "tflint"                           # Terraform linter
brew "tfsec"                            # Terraform security scanner
brew "tfupdate"                         # Update Terraform version constraints
brew "tfk8s"                            # Kubernetes YAML to Terraform HCL
brew "checkov"                          # IaC security scanner
brew "hashicorp/tap/vault"              # HashiCorp Vault
brew "spacelift-io/spacelift/spacectl"  # Spacelift CLI

# ---------------------------------------------------------------------------
# Cloud CLIs
# ---------------------------------------------------------------------------
brew "awscli"                           # AWS CLI
brew "azure-cli"                        # Azure CLI
brew "aws-cdk"                          # AWS CDK
brew "cfn-lint"                         # CloudFormation linter
brew "remind101/formulae/assume-role"   # Easily assume AWS IAM roles

# ---------------------------------------------------------------------------
# Containers & Virtualisation
# ---------------------------------------------------------------------------
brew "docker"                           # Docker engine
brew "colima"                           # Container runtimes on macOS
brew "lima"                             # Linux VMs
brew "dive"                             # Docker image layer explorer
brew "qemu"                             # Generic machine emulator

# ---------------------------------------------------------------------------
# Git & Dev Tools
# ---------------------------------------------------------------------------
brew "git"
brew "gh"                               # GitHub CLI
brew "git-crypt"                        # Transparent git encryption
brew "gitleaks"                         # Audit repos for secrets
brew "github-markdown-toc"              # Auto-generate ToC for README
brew "pre-commit"                       # Multi-language pre-commit hooks
brew "stow"                             # Dotfiles symlink manager
brew "gnupg"                            # GPG signing
brew "direnv"                           # Per-directory env vars

# ---------------------------------------------------------------------------
# Languages & Build Tools
# ---------------------------------------------------------------------------
brew "gradle@9"                         # Gradle 9
brew "maven"                            # Java build tool
brew "protobuf"                         # Protocol Buffers
brew "yarn"                             # JavaScript package manager

# ---------------------------------------------------------------------------
# Data & Databases
# ---------------------------------------------------------------------------
brew "avro-c"                           # Apache Avro C library
brew "librdkafka"                       # Kafka C/C++ library
brew "kcat"                             # Kafka CLI producer/consumer
brew "jq"                               # JSON processor
brew "yq"                               # YAML/JSON/XML/CSV processor
brew "mysql-client"                     # MySQL client
brew "postgresql@18"                    # PostgreSQL 18
brew "redis"                            # Redis
brew "pgvector"                         # Postgres vector similarity search

# ---------------------------------------------------------------------------
# Observability & Networking
# ---------------------------------------------------------------------------
brew "trivy"                            # Container/filesystem vulnerability scanner
brew "snyk/tap/snyk"                    # Open-source vulnerability scanner
brew "vegeta"                           # HTTP load testing
brew "iperf3"                           # TCP/UDP bandwidth measurement
brew "tcptraceroute"                    # Traceroute via TCP
brew "telnet"                           # Telnet client
brew "sslscan"                          # SSL/TLS cipher scanner
brew "wget"                             # HTTP file retriever
brew "pv"                               # Monitor data pipeline progress
brew "watch"                            # Periodic command execution
brew "stress"                           # System stress tester
brew "teamookla/speedtest/speedtest"    # Ookla Speedtest CLI

# ---------------------------------------------------------------------------
# Go Tooling
# ---------------------------------------------------------------------------
brew "golangci-lint"                    # Fast Go linter runner
brew "golangci/tap/golangci-lint"       # golangci-lint tap version

# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------
brew "adr-tools"                        # Architecture Decision Records
brew "afsctool"                         # APFS/ZFS file compression tool
brew "bash"                             # Latest Bash
brew "coreutils"                        # GNU core utilities
brew "fzf"                              # Fuzzy finder
brew "gawk"                             # GNU awk
brew "grep"                             # GNU grep
brew "groff"                            # GNU troff text formatter
brew "graphviz"                         # Graph visualization
brew "gtop"                             # System monitoring dashboard
brew "htop"                             # Improved top
brew "mactop"                           # macOS system monitor (Apple Silicon metrics)
brew "isort"                            # Python import sorter
brew "pylint"                           # Python linter
brew "tree"                             # Directory tree display
brew "tcl-tk"                           # Tcl/Tk
brew "yamllint"                         # YAML linter
brew "aom"                              # AV1 video codec
brew "webp"                             # WebP image codec
brew "jpeg-xl"                          # JPEG XL image format
brew "cntlm", restart_service: :changed  # NTLM auth proxy

# ---------------------------------------------------------------------------
# Fonts
# ---------------------------------------------------------------------------
cask "font-hack-nerd-font"              # Hack Nerd Font
cask "font-jetbrains-mono-nerd-font"    # JetBrains Mono Nerd Font (primary)

# ---------------------------------------------------------------------------
# macOS Apps
# ---------------------------------------------------------------------------
cask "visual-studio-code"               # Code editor
cask "powershell"                       # PowerShell

# ---------------------------------------------------------------------------
# VS Code Extensions
# ---------------------------------------------------------------------------
vscode "akamud.vscode-theme-onedark"
vscode "anthropic.claude-code"
vscode "bradlc.vscode-tailwindcss"
vscode "cdpautsch.tpl"
vscode "chrismeyers.vscode-pretty-json"
vscode "codezombiech.gitignore"
vscode "continue.continue"
vscode "davidanson.vscode-markdownlint"
vscode "dbaeumer.vscode-eslint"
vscode "docker.docker"
vscode "donjayamanne.githistory"
vscode "eamodio.gitlens"
vscode "editorconfig.editorconfig"
vscode "esbenp.prettier-vscode"
vscode "formulahendry.auto-rename-tag"
vscode "github.copilot-chat"
vscode "github.vscode-github-actions"
vscode "github.vscode-pull-request-github"
vscode "gitlab.gitlab-workflow"
vscode "golang.go"
vscode "hashicorp.terraform"
vscode "henriiik.docker-linter"
vscode "ipedrazas.kubernetes-snippets"
vscode "jasonlhy.hungry-delete"
vscode "kennylong.kubernetes-yaml-formatter"
vscode "lunuan.kubernetes-templates"
vscode "mechatroner.rainbow-csv"
vscode "ms-azuretools.vscode-containers"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-vscode-remote.remote-containers"
vscode "ms-vscode.makefile-tools"
vscode "oderwat.indent-rainbow"
vscode "pkief.material-icon-theme"
vscode "redhat.java"
vscode "redhat.vscode-yaml"
vscode "shd101wyy.markdown-preview-enhanced"
vscode "tberman.json-schema-validator"
vscode "tim-koehler.helm-intellisense"
vscode "tomoki1207.pdf"
vscode "tsandall.opa"
vscode "vincaslt.highlight-matching-tag"
vscode "vivaxy.vscode-conventional-commits"
vscode "vscjava.migrate-java-to-azure"
vscode "vscjava.vscode-gradle"
vscode "vscjava.vscode-java-debug"
vscode "vscjava.vscode-java-dependency"
vscode "vscjava.vscode-java-pack"
vscode "vscjava.vscode-java-test"
vscode "vscjava.vscode-java-upgrade"
vscode "vscjava.vscode-maven"
vscode "vscode-icons-team.vscode-icons"
vscode "yzhang.markdown-all-in-one"
