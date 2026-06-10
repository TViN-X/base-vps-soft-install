# 🚀 base-vps-soft-install

**Простой и мощный скрипт** для быстрой настройки современного терминала и необходимых утилит на чистом **Ubuntu 24.04** или **Debian 12** VPS.

![Powerlevel10k](https://img.shields.io/badge/Zsh-Powerlevel10k-blue?style=flat-square&logo=zsh)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=flat-square&logo=ubuntu)
![Debian](https://img.shields.io/badge/Debian-12-000000?style=flat-square&logo=debian)

## ✨ Возможности

- **Zsh** + **Oh My Zsh** + **Powerlevel10k** 
- Плагины: autosuggestions, syntax-highlighting, completions
- Современные утилиты: `eza`, `btop`, `fzf`, `duf` и др.
- Полный набор сетевых инструментов (`nmap`, `tcpdump`, `iperf3`, `traceroute`, `whois` и т.д.)
- Автоматическая смена оболочки по умолчанию на Zsh
- Интерактивная настройка внешнего вида Powerlevel10k
- Поддержка русского и английского языка
- Красивый вывод статуса установки и список доступных команд

## 📥 Быстрая установка

```bash
# Одной командой (рекомендуется)
curl -fsSL https://raw.githubusercontent.com/TViN-X/base-vps-soft-install/main/install.sh | bash
```

Или классический способ:

```bash
git clone https://github.com/TViN-X/base-vps-soft-install.git
cd base-vps-soft-install
chmod +x install.sh
sudo ./install.sh
```

## 🛠 Что устанавливает скрипт

### Терминал и оболочка
- **Zsh** + **Oh My Zsh** + **Powerlevel10k**
- Плагины: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`

### Утилиты и инструменты

| Утилита         | Назначение                              |
|-----------------|-----------------------------------------|
| `eza`           | Современная замена `ls` с иконками     |
| `btop`          | Красивый мониторинг системы             |
| `htop`          | Классический мониторинг процессов       |
| `fzf`           | Нечёткий поиск (fuzzy finder)           |
| `duf`           | Красивый вывод использования дисков     |
| `nmap`          | Сканирование сети                       |
| `tcpdump`       | Захват и анализ трафика                 |
| `iperf3`        | Тестирование пропускной способности     |
| `speedtest-cli` | Тест скорости интернета                 |
| `curl`, `wget`, `traceroute`, `whois` | Базовые сетевые инструменты     |

## 📋 После установки

После завершения скрипта:
1. Закройте текущую сессию SSH и подключитесь заново.
2. При первом запуске Zsh запустится **мастер настройки Powerlevel10k** — пройдите его (рекомендуется стиль **Lean**).

### Полезные алиасы

- `ls`, `ll`, `la` — через `eza` с иконками
- `find` — через `fzf`

## 📌 Recommendations

- При использовании **Windows Terminal** + рекмоендую поставить **Nerd Font** https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip (MesloLGS NF, JetBrainsMono NF, etc.) для нормального отображения иконок в терминале.
---

## English Version / Английская версия

# 🚀 base-vps-soft-install

**Simple and powerful script** for quick setup of a modern terminal and essential utilities on a fresh **Ubuntu 24.04** or **Debian 12** VPS.

![Powerlevel10k](https://img.shields.io/badge/Zsh-Powerlevel10k-blue?style=flat-square&logo=zsh)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=flat-square&logo=ubuntu)
![Debian](https://img.shields.io/badge/Debian-12-000000?style=flat-square&logo=debian)

## ✨ Features

- **Zsh** + **Oh My Zsh** + **Powerlevel10k** 
- Plugins: autosuggestions, syntax-highlighting, completions
- Modern utilities: `eza`, `btop`, `fzf`, `duf`, etc.
- Full set of networking tools (`nmap`, `tcpdump`, `iperf3`, `traceroute`, `whois`, etc.)
- Automatic switch to Zsh as default shell
- Interactive Powerlevel10k appearance setup
- Support for Russian and English languages
- Beautiful installation status output and list of available commands

## 📥 Quick Installation

```bash
# One command (recommended)
curl -fsSL https://raw.githubusercontent.com/TViN-X/base-vps-soft-install/main/install.sh | bash
```

Or the classic way:

```bash
git clone https://github.com/TViN-X/base-vps-soft-install.git
cd base-vps-soft-install
chmod +x install.sh
sudo ./install.sh
```

## 🛠 What the Script Installs

### Terminal & Shell
- **Zsh** + **Oh My Zsh** + **Powerlevel10k**
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`

### Utilities & Tools

| Utility         | Purpose                                 |
|-----------------|-----------------------------------------|
| `eza`           | Modern `ls` replacement with icons      |
| `btop`          | Beautiful system monitoring             |
| `htop`          | Classic process monitoring              |
| `fzf`           | Fuzzy finder                            |
| `duf`           | Beautiful disk usage display            |
| `nmap`          | Network scanning                        |
| `tcpdump`       | Traffic capture and analysis            |
| `iperf3`        | Bandwidth testing                       |
| `speedtest-cli` | Internet speed test                     |
| `curl`, `wget`, `traceroute`, `whois` | Basic networking tools         |

## 📋 After Installation

After the script finishes:
1. Close your current SSH session and reconnect.
2. On first Zsh launch, the **Powerlevel10k configuration wizard** will start — go through it (recommended **Lean** style).

### Useful Aliases

- `ls`, `ll`, `la` — powered by `eza` with icons
- `find` — powered by `fzf`

## 🎨 Screenshots

(Добавьте сюда скриншоты после теста)

## 📌 Recommendations

- Use **Windows Terminal** + **Nerd Font** https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip (MesloLGS NF, JetBrainsMono NF, etc.) for best icon display.
