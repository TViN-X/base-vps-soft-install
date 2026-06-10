#!/bin/bash

# =============================================
# Универсальный скрипт установки терминала + сетевых утилит
# Для Ubuntu / Debian VPS
# =============================================

set -e

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}   Установка терминала и утилит${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Выбор языка
echo "Выберите язык интерфейса / Choose language:"
echo "1) Русский"
echo "2) English"
read -p "Введите номер (1/2): " lang_choice

if [[ "$lang_choice" == "2" ]]; then
    LANG="en"
    MSG_WELCOME="Starting installation..."
    MSG_UPDATE="Updating package lists..."
    MSG_INSTALL="Installing packages..."
    MSG_ZSH="Setting up Zsh with Powerlevel10k..."
    MSG_ALIASES="Adding aliases..."
    MSG_FINISH="Installation completed successfully!"
else
    LANG="ru"
    MSG_WELCOME="Запуск установки..."
    MSG_UPDATE="Обновление списка пакетов..."
    MSG_INSTALL="Установка пакетов..."
    MSG_ZSH="Настройка Zsh с Powerlevel10k..."
    MSG_ALIASES="Добавление алиасов..."
    MSG_FINISH="Установка успешно завершена!"
fi

echo -e "${GREEN}$MSG_WELCOME${NC}"

# Обновление
echo -e "${YELLOW}$MSG_UPDATE${NC}"
sudo apt update -qq

# Установка пакетов
echo -e "${YELLOW}$MSG_INSTALL${NC}"

sudo apt install -y \
    zsh curl git fonts-powerline \
    eza btop htop tcpdump nmap iperf3 \
    curl wget traceroute whois duf fzf \
    bat ripgrep

# speedtest-cli (Ookla)
if ! command -v speedtest &> /dev/null; then
    echo "Установка speedtest-cli..."
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt install -y speedtest
fi

echo -e "${GREEN}Основные пакеты установлены.${NC}"

# === Настройка Zsh ===
echo -e "${YELLOW}$MSG_ZSH${NC}"

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Плагины
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" 2>/dev/null || true
git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" 2>/dev/null || true

# Создание .zshrc
cat > ~/.zshrc << 'EOF'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ls="eza --icons --group-directories-first"
alias ll="eza -lh --icons --group-directories-first"
alias la="eza -lah --icons --group-directories-first"
alias l="eza -lh --icons --group-directories-first"
alias cat="bat"
alias find="fzf"

# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
EOF

# Сделать zsh оболочкой по умолчанию
sudo chsh -s $(which zsh) $USER

echo -e "${GREEN}Zsh настроен. После перелогина запустится мастер настройки Powerlevel10k.${NC}"
echo -e "${YELLOW}Пройдите интерактивный wizard для выбора стиля (рекомендуется Lean + Unicode + Icons).${NC}"

# Сообщение о финале
echo ""
echo -e "${BLUE}=============================================${NC}"
echo -e "${GREEN}$MSG_FINISH${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

echo "Доступные команды после установки:"
echo "────────────────────────────────────"
echo "zsh          - Современная оболочка с Powerlevel10k"
echo "eza / ls     - Красивый ls с иконками"
echo "btop         - Красивый мониторинг системы (рекомендуется)"
echo "htop         - Классический мониторинг процессов"
echo "tcpdump      - Захват трафика"
echo "nmap         - Сканирование сети"
echo "iperf3       - Тестирование пропускной способности"
echo "speedtest    - Тест скорости интернета"
echo "duf          - Красивый df"
echo "fzf          - Fuzzy finder"
echo "traceroute   - Трассировка маршрута"
echo "whois        - Информация о домене"
echo ""
echo -e "${YELLOW}Перелогиньтесь или выполните 'exec zsh' для применения изменений.${NC}"
echo -e "${YELLOW}После первого запуска zsh пройдите настройку Powerlevel10k.${NC}"

# Показ текущих процессов в конце
echo ""
echo -e "${BLUE}Текущие процессы:${NC}"
ps aux --sort=-%cpu | head -15
