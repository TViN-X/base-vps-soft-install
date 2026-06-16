#!/bin/bash
# =============================================
# Base VPS Soft Install Script
# Для Ubuntu 24.04 / Debian 12
# =============================================

set -e

# Обработка аргументов
REINSTALL=false
if [[ "$1" == "--reinstall" || "$1" == "-r" ]]; then
    REINSTALL=true
    echo -e "\033[1;33m⚠️  Режим полной переустановки включён\033[0m"
fi

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}   Установка терминала и утилит для VPS${NC}"
echo -e "${BLUE}=============================================${NC}"

# Выбор языка
echo -e "\nВыберите язык интерфейса / Choose language:"
echo "1) Русский"
echo "2) English"
read -r LANG_CHOICE

if [[ "$LANG_CHOICE" == "2" ]]; then
    MSG_UPDATE="Updating package lists..."
    MSG_INSTALL="Installing packages..."
    MSG_DONE="Installation completed successfully!"
    MSG_REINSTALL="Full reinstall mode"
else
    MSG_UPDATE="Обновление списка пакетов..."
    MSG_INSTALL="Установка пакетов..."
    MSG_DONE="Установка успешно завершена!"
    MSG_REINSTALL="Полная переустановка"
fi

# Если режим переустановки — очищаем старые конфиги
if [[ "$REINSTALL" == true ]]; then
    echo -e "\n${YELLOW}Выполняется очистка перед переустановкой...${NC}"
    rm -rf ~/.oh-my-zsh ~/.p10k.zsh ~/.zshrc ~/.nanorc 2>/dev/null || true
    echo -e "${GREEN}Старые конфигурации удалены${NC}"
fi

# Обновление системы
echo -e "\n${YELLOW}$MSG_UPDATE${NC}"
apt update -qq

# Добавление репозитория eza
if ! grep -q "deb.gierens.de" /etc/apt/sources.list.d/gierens.list 2>/dev/null || [[ "$REINSTALL" == true ]]; then
    echo -e "\n${YELLOW}Добавление/обновление репозитория eza...${NC}"
    apt install -y wget gnupg
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
fi
apt update -qq

# Установка пакетов
echo -e "\n${YELLOW}$MSG_INSTALL${NC}"
apt install -y \
    zsh curl git wget unzip \
    eza btop htop duf fzf mc nano \
    tcpdump nmap iperf3 traceroute whois \
    speedtest-cli

# Установка Oh My Zsh + Powerlevel10k
if [[ ! -d ~/.oh-my-zsh ]] || [[ "$REINSTALL" == true ]]; then
    echo -e "\n${YELLOW}Установка Oh My Zsh и Powerlevel10k...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]] || [[ "$REINSTALL" == true ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

# Плагины (устанавливаем только если нет)
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
    if [[ ! -d ~/.oh-my-zsh/custom/plugins/$plugin ]] || [[ "$REINSTALL" == true ]]; then
        git clone --depth=1 https://github.com/zsh-users/$plugin ~/.oh-my-zsh/custom/plugins/$plugin 2>/dev/null || true
    fi
done

# Создание .zshrc
cat > ~/.zshrc << 'EOL'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# ====================== Курсор ======================
# Постоянный тонкий мигающий курсор
echo -ne '\e[5 q'

function fix_cursor() {
  echo -ne '\e[5 q'
}
precmd_functions+=(fix_cursor)

# Алиасы
alias ls="eza --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -lah --icons --group-directories-first"
alias l="eza -lh --icons --group-directories-first"
alias cat="batcat 2>/dev/null || cat"
alias find="fzf"

# Powerlevel10k
[[ ! -r ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

# Настройка nano
cat > ~/.nanorc << 'NANO'
set linenumbers
set mouse
set historylog
set autoindent
set tabsize 4
set minibar
set stateflags
set indicator
set constantshow
set softwrap
set atblanks
set backup
set locking
set guidestripe 80
include "/usr/share/nano/*.nanorc"
NANO

# Смена оболочки по умолчанию
if [[ "$SHELL" != */zsh ]]; then
    chsh -s $(which zsh) "$SUDO_USER" 2>/dev/null || chsh -s $(which zsh)
fi

echo -e "\n${GREEN}$MSG_DONE${NC}"
echo -e "\n${YELLOW}Для применения изменений выполните:${NC}"
echo -e "   exit"
echo -e "и подключитесь заново по SSH.\n"

echo -e "${BLUE}Доступные команды:${NC}"
echo -e "  btop, mc, nano, eza (ls), fzf, duf и другие"

if [[ "$REINSTALL" == true ]]; then
    echo -e "\n${GREEN}Переустановка завершена успешно!${NC}"
fi
