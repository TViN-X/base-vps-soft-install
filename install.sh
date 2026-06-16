#!/bin/bash
# =============================================
# Base VPS Soft Install Script
# Для Ubuntu 24.04 / Debian 12
# =============================================

set -e

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}   Установка терминала и утилит для Ubuntu/Debian${NC}"
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
else
    MSG_UPDATE="Обновление списка пакетов..."
    MSG_INSTALL="Установка пакетов..."
    MSG_DONE="Установка успешно завершена!"
fi

# Обновление системы
echo -e "\n${YELLOW}$MSG_UPDATE${NC}"
apt update -qq

# Добавление репозитория eza
echo -e "\n${YELLOW}Добавление репозитория eza...${NC}"
apt install -y wget gnupg
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
apt update -qq

# Установка всех пакетов
echo -e "\n${YELLOW}$MSG_INSTALL${NC}"
apt install -y \
    zsh curl git wget unzip \
    eza btop htop duf fzf mc nano \
    tcpdump nmap iperf3 traceroute whois \
    speedtest-cli

# Установка Oh My Zsh + Powerlevel10k
echo -e "\n${YELLOW}Установка Oh My Zsh и Powerlevel10k...${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Плагины
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# Создание .zshrc
cat > ~/.zshrc << 'EOL'
# Oh My Zsh
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
# Постоянный тонкий мигающий курсор (I-beam)
echo -ne '\e[5 q'

function fix_cursor() {
  echo -ne '\e[5 q'
}

# Применяем при каждом новом промпте
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
echo -e "\n${YELLOW}Настройка редактора nano...${NC}"
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

# Делаем zsh оболочкой по умолчанию
chsh -s $(which zsh) "$SUDO_USER" 2>/dev/null || chsh -s $(which zsh)

echo -e "\n${GREEN}$MSG_DONE${NC}"
echo -e "\n${YELLOW}Для применения изменений выполните:${NC}"
echo -e "   exit"
echo -e "и подключитесь заново по SSH.\n"

echo -e "${BLUE}Доступные команды после установки:${NC}"
echo -e "  ${GREEN}btop${NC}          — красивый мониторинг системы"
echo -e "  ${GREEN}mc${NC}            — файловый менеджер Midnight Commander"
echo -e "  ${GREEN}nano${NC}          — улучшенный текстовый редактор"
echo -e "  ${GREEN}eza${NC}           — современный ls с иконками"
echo -e "  ${GREEN}fzf${NC}           — нечёткий поиск (alias find)"
echo -e "  ${GREEN}duf${NC}           — удобный просмотр дисков"

echo -e "\n${YELLOW}Курсор:${NC} Тонкий мигающий (постоянно)"
