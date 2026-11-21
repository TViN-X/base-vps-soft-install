#!/bin/bash
# =============================================
# Base VPS Soft Install Script
# Ubuntu 24.04 / Debian 12
# =============================================

set -e

# Prevent interactive prompts from apt / debconf / needrestart
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# =============================================
# Args
# =============================================

REINSTALL=false

if [[ "$1" == "--reinstall" || "$1" == "-r" ]]; then
    REINSTALL=true
    echo -e "\033[1;33m⚠️  Reinstall mode enabled\033[0m"
fi

# =============================================
# Colors
# =============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}   VPS Base Soft Install${NC}"
echo -e "${BLUE}=============================================${NC}"

# =============================================
# Language selection
# =============================================

if [[ -t 0 ]]; then
    echo
    echo "Select language / Выберите язык:"
    echo "1) Russian / Русский"
    echo "2) English"
    read -r LANG_CHOICE
else
    LANG_CHOICE=1
fi

if [[ "$LANG_CHOICE" == "2" ]]; then
    MSG_UPDATE="[1/6] Updating package lists..."
    MSG_INSTALL="[2/6] Installing packages..."
    MSG_EZA="Installing eza..."
    MSG_OMZ="[3/6] Installing Oh My Zsh..."
    MSG_P10K="[4/6] Installing Powerlevel10k and plugins..."
    MSG_CONFIG="[5/6] Applying configurations..."
    MSG_THEME="[6/6] Installing MC theme..."
    MSG_DONE="Installation completed successfully!"
    MSG_RECONNECT="Reconnect SSH to apply changes."
else
    MSG_UPDATE="[1/6] Обновление списка пакетов..."
    MSG_INSTALL="[2/6] Установка пакетов..."
    MSG_EZA="Установка eza..."
    MSG_OMZ="[3/6] Установка Oh My Zsh..."
    MSG_P10K="[4/6] Установка Powerlevel10k и плагинов..."
    MSG_CONFIG="[5/6] Применение настроек..."
    MSG_THEME="[6/6] Установка темы MC..."
    MSG_DONE="Установка успешно завершена!"
    MSG_RECONNECT="Переподключитесь по SSH для применения изменений."
fi

# =============================================
# User detection & Environment
# =============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(eval echo "~$TARGET_USER")

# =============================================
# Cleanup (Reinstall mode)
# =============================================

if [[ "$REINSTALL" == true ]]; then
    echo -e "\n${YELLOW}Cleaning old configuration...${NC}"

    rm -rf \
        "$TARGET_HOME/.oh-my-zsh" \
        "$TARGET_HOME/.p10k.zsh" \
        "$TARGET_HOME/.zshrc" \
        "$TARGET_HOME/.nanorc" \
        "$TARGET_HOME/.config/mc" \
        "$TARGET_HOME/.local/share/mc" \
        /tmp/mashdark \
        /etc/apt/keyrings/gierens.gpg \
        /etc/apt/sources.list.d/gierens.list

    echo -e "${GREEN}Old configs removed${NC}"
fi

# =============================================
# 1. Update system
# =============================================

echo -e "\n${YELLOW}${MSG_UPDATE}${NC}"
apt-get update -qq

# =============================================
# 2. Packages
# =============================================

echo -e "\n${YELLOW}${MSG_INSTALL}${NC}"

PACKAGES=(
    zsh curl git wget unzip nano mc
    btop htop duf fzf
    tcpdump nmap iperf3 traceroute whois speedtest-cli
    bat gnupg
)

# If eza is available in OS repository (e.g. Ubuntu 24.04), install it via apt
if apt-cache show eza >/dev/null 2>&1; then
    PACKAGES+=(eza)
fi

apt-get install -y -qq \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    "${PACKAGES[@]}"

# Setup eza fallback if not in apt (e.g. Debian 12)
if ! command -v eza &>/dev/null; then
    echo -e "${YELLOW}${MSG_EZA}${NC}"
    ARCH=$(dpkg --print-architecture 2>/dev/null || echo "amd64")
    case "$ARCH" in
        amd64) EZA_ARCH="x86_64-unknown-linux-musl" ;;
        arm64) EZA_ARCH="aarch64-unknown-linux-gnu" ;;
        *) EZA_ARCH="" ;;
    esac
    if [[ -n "$EZA_ARCH" ]]; then
        curl -fsSL --connect-timeout 10 --max-time 30 \
            "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}.tar.gz" \
            | tar -xz -C /usr/local/bin
        chmod +x /usr/local/bin/eza
    fi
fi

# Debian/Ubuntu installs bat as batcat; create symlink bat -> batcat
if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
    ln -sf "$(which batcat)" /usr/local/bin/bat
fi

# Clean up broken gierens repo from previous runs if present
if [[ -f /etc/apt/sources.list.d/gierens.list ]]; then
    rm -f /etc/apt/sources.list.d/gierens.list /etc/apt/keyrings/gierens.gpg
fi

# =============================================
# 3. Oh My Zsh
# =============================================

if [[ ! -d "$TARGET_HOME/.oh-my-zsh" ]] || [[ "$REINSTALL" == true ]]; then
    echo -e "\n${YELLOW}${MSG_OMZ}${NC}"
    rm -rf "$TARGET_HOME/.oh-my-zsh"

    OMZ_INSTALLER=$(curl -fsSL --connect-timeout 10 --max-time 60 https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
    env CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$OMZ_INSTALLER" "" --unattended < /dev/null
fi

# =============================================
# 4. Powerlevel10k & Plugins
# =============================================

echo -e "\n${YELLOW}${MSG_P10K}${NC}"

# Powerlevel10k
if [[ ! -d "$TARGET_HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]] || [[ "$REINSTALL" == true ]]; then
    rm -rf "$TARGET_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$TARGET_HOME/.oh-my-zsh/custom/themes/powerlevel10k" < /dev/null
fi

# Plugins
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
    PLUGIN_DIR="$TARGET_HOME/.oh-my-zsh/custom/plugins/$plugin"
    if [[ ! -d "$PLUGIN_DIR" ]] || [[ "$REINSTALL" == true ]]; then
        rm -rf "$PLUGIN_DIR"
        git clone --depth=1 \
            "https://github.com/zsh-users/$plugin" \
            "$PLUGIN_DIR" < /dev/null 2>/dev/null || true
    fi
done

# Ensure target user owns oh-my-zsh files
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.oh-my-zsh"

# =============================================
# 5. Configurations (.p10k.zsh, .zshrc, .nanorc)
# =============================================

echo -e "\n${YELLOW}${MSG_CONFIG}${NC}"

# p10k.zsh
if [[ -f "$SCRIPT_DIR/p10k.zsh" ]]; then
    cp -f "$SCRIPT_DIR/p10k.zsh" "$TARGET_HOME/.p10k.zsh"
else
    curl -fsSL --connect-timeout 10 --max-time 30 \
        https://raw.githubusercontent.com/TViN-X/base-vps-soft-install/main/p10k.zsh \
        -o "$TARGET_HOME/.p10k.zsh"
fi
chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.p10k.zsh"

# .zshrc
cat > "$TARGET_HOME/.zshrc" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Cursor fix (thin bar)
echo -ne '\e[5 q'
fix_cursor() { echo -ne '\e[5 q'; }
precmd_functions+=(fix_cursor)

# Aliases
if command -v eza &>/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -lh --icons --group-directories-first"
  alias la="eza -lah --icons --group-directories-first"
  alias l="eza -lh --icons --group-directories-first"
fi

if command -v bat &>/dev/null; then
  alias cat="bat"
elif command -v batcat &>/dev/null; then
  alias cat="batcat"
fi

alias ff="fzf"

[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.zshrc"

# .nanorc
cat > "$TARGET_HOME/.nanorc" << 'EOF'
set linenumbers
set mouse
set autoindent
set tabsize 4
set softwrap
set constantshow
set minibar
include "/usr/share/nano/*.nanorc"
EOF

chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.nanorc"

# =============================================
# 6. Midnight Commander + MashDark
# =============================================

echo -e "\n${YELLOW}${MSG_THEME}${NC}"

rm -rf /tmp/mashdark
git clone --depth=1 https://github.com/notnout/mashdark.git /tmp/mashdark < /dev/null 2>/dev/null || true

if [[ -d /tmp/mashdark ]]; then
    mkdir -p "$TARGET_HOME/.local/share/mc/skins"
    mkdir -p "$TARGET_HOME/.config/mc"

    cp -f /tmp/mashdark/mashdark.ini \
       "$TARGET_HOME/.local/share/mc/skins/mashdark.ini" 2>/dev/null || true

    cp -f /tmp/mashdark/filehighlight.ini \
       "$TARGET_HOME/.config/mc/filehighlight.ini" 2>/dev/null || true

    cat > "$TARGET_HOME/.config/mc/ini" << 'EOF'
[Midnight-Commander]
skin=mashdark
EOF

    chown -R "$TARGET_USER:$TARGET_USER" \
        "$TARGET_HOME/.local/share/mc" \
        "$TARGET_HOME/.config/mc"

    rm -rf /tmp/mashdark
fi

# =============================================
# Shell Change
# =============================================

TARGET_SHELL=$(which zsh 2>/dev/null || echo "/bin/zsh")
CURRENT_SHELL=$(getent passwd "$TARGET_USER" | cut -d: -f7)

if [[ "$CURRENT_SHELL" != "$TARGET_SHELL" ]]; then
    if command -v chsh &>/dev/null; then
        chsh -s "$TARGET_SHELL" "$TARGET_USER" 2>/dev/null || true
    elif command -v usermod &>/dev/null; then
        usermod -s "$TARGET_SHELL" "$TARGET_USER" 2>/dev/null || true
    fi
fi

# =============================================
# Done
# =============================================

echo
echo -e "${GREEN}${MSG_DONE}${NC}"
echo
echo "${MSG_RECONNECT}"
echo "Tools installed: zsh, oh-my-zsh, powerlevel10k, mc, eza, bat, fzf, btop, network tools"

if [[ "$REINSTALL" == true ]]; then
    echo -e "\n${GREEN}Reinstall completed successfully!${NC}"
fi
