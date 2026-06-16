#!/bin/bash
# =============================================
# Base VPS Soft Install Script
# Ubuntu 24.04 / Debian 12
# =============================================

set -e

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
# Language selection (FIX: no freeze in curl | bash)
# =============================================

if [[ -t 0 ]]; then
    echo
    echo "Select language:"
    echo "1) Russian"
    echo "2) English"
    read -r LANG_CHOICE
else
    LANG_CHOICE=1
fi

if [[ "$LANG_CHOICE" == "2" ]]; then
    MSG_UPDATE="Updating package lists..."
    MSG_INSTALL="Installing packages..."
    MSG_DONE="Installation completed successfully!"
    MSG_THEME="Installing MC theme..."
else
    MSG_UPDATE="Обновление списка пакетов..."
    MSG_INSTALL="Установка пакетов..."
    MSG_DONE="Установка успешно завершена!"
    MSG_THEME="Установка темы MC..."
fi

# =============================================
# User detection
# =============================================

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(eval echo "~$TARGET_USER")

# =============================================
# Cleanup
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
        /tmp/mashdark

    echo -e "${GREEN}Old configs removed${NC}"
fi

# =============================================
# Update system
# =============================================

echo -e "\n${YELLOW}${MSG_UPDATE}${NC}"
apt update -qq

# =============================================
# Packages
# =============================================

echo -e "\n${YELLOW}${MSG_INSTALL}${NC}"

apt install -y \
    zsh curl git wget unzip nano mc \
    eza btop htop duf fzf \
    tcpdump nmap iperf3 traceroute whois speedtest-cli \
    bat gnupg

# =============================================
# Keyrings
# =============================================

mkdir -p /etc/apt/keyrings

# =============================================
# EZA repo
# =============================================

if ! grep -q "deb.gierens.de" /etc/apt/sources.list.d/gierens.list 2>/dev/null || [[ "$REINSTALL" == true ]]; then

    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg

    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        > /etc/apt/sources.list.d/gierens.list
fi

apt update -qq

# =============================================
# Oh My Zsh
# =============================================

if [[ ! -d "$TARGET_HOME/.oh-my-zsh" ]] || [[ "$REINSTALL" == true ]]; then
    sudo -u "$TARGET_USER" sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

# =============================================
# Powerlevel10k
# =============================================

if [[ ! -d "$TARGET_HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]] || [[ "$REINSTALL" == true ]]; then
    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$TARGET_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi

# =============================================
# Plugins
# =============================================

for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
    if [[ ! -d "$TARGET_HOME/.oh-my-zsh/custom/plugins/$plugin" ]] || [[ "$REINSTALL" == true ]]; then
        git clone --depth=1 \
            "https://github.com/zsh-users/$plugin" \
            "$TARGET_HOME/.oh-my-zsh/custom/plugins/$plugin" \
            2>/dev/null || true
    fi
done

# =============================================
# p10k config (FIXED: always download from repo)
# =============================================

echo -e "\n${YELLOW}Downloading p10k.zsh...${NC}"

curl -fsSL \
https://raw.githubusercontent.com/TViN-X/base-vps-soft-install/main/p10k.zsh \
-o "$TARGET_HOME/.p10k.zsh"

chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.p10k.zsh"

# =============================================
# .zshrc
# =============================================

cat > "$TARGET_HOME/.zshrc" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# Cursor fix
echo -ne '\e[5 q'
function fix_cursor() { echo -ne '\e[5 q' }
precmd_functions+=(fix_cursor)

# Aliases
alias ls="eza --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -lah --icons --group-directories-first"
alias l="eza -lh --icons --group-directories-first"

alias cat="bat 2>/dev/null || batcat"
alias ff="fzf"

[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.zshrc"

# =============================================
# nano
# =============================================

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
# Midnight Commander + MashDark
# =============================================

echo -e "\n${YELLOW}${MSG_THEME}${NC}"

rm -rf /tmp/mashdark
git clone https://github.com/notnout/mashdark.git /tmp/mashdark

mkdir -p "$TARGET_HOME/.local/share/mc/skins"
mkdir -p "$TARGET_HOME/.config/mc"

cp /tmp/mashdark/MashDark.ini \
   "$TARGET_HOME/.local/share/mc/skins/"

cat > "$TARGET_HOME/.config/mc/ini" << 'EOF'
[Midnight-Commander]
skin=MashDark
EOF

chown -R "$TARGET_USER:$TARGET_USER" \
    "$TARGET_HOME/.local/share/mc" \
    "$TARGET_HOME/.config/mc"

# =============================================
# Shell
# =============================================

TARGET_SHELL=$(which zsh)

if [[ "$(getent passwd "$TARGET_USER" | cut -d: -f7)" != "$TARGET_SHELL" ]]; then
    chsh -s "$TARGET_SHELL" "$TARGET_USER"
fi

# =============================================
# Done
# =============================================

echo
echo -e "${GREEN}${MSG_DONE}${NC}"

echo
echo "Reconnect SSH to apply changes."
echo "Tools installed: zsh, oh-my-zsh, powerlevel10k, mc, eza, bat, fzf, network tools"

if [[ "$REINSTALL" == true ]]; then
    echo -e "\n${GREEN}Reinstall completed successfully!${NC}"
fi
