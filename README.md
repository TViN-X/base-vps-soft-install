# 🚀 base-vps-soft-install

Простой и мощный скрипт для быстрой настройки современного, удобного и красивого терминала на чистом VPS с **Ubuntu 24.04** или **Debian 12**.

![Zsh](https://img.shields.io/badge/Zsh-Powerlevel10k-blue?style=flat-square&logo=zsh)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=flat-square&logo=ubuntu)
![Debian](https://img.shields.io/badge/Debian-12-A81D33?style=flat-square&logo=debian)
![License](https://img.shields.io/github/license/TViN-X/base-vps-soft-install?style=flat-square)

---

## ✨ Возможности

### 🖥 Современный терминал

- Zsh
- Oh My Zsh
- Powerlevel10k
- Автоматическая установка пользовательской конфигурации `p10k.zsh`
- Постоянный тонкий мигающий курсор

### 🔌 Полезные плагины

- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-completions

### 🛠 Современные утилиты

- `eza` — современная замена `ls`
- `btop` — красивый мониторинг системы
- `htop` — классический мониторинг процессов
- `mc` — Midnight Commander
- `nano` — настроенный текстовый редактор
- `fzf` — быстрый fuzzy-поиск
- `duf` — красивый просмотр использования дисков

### 🌐 Сетевые инструменты

- `nmap`
- `tcpdump`
- `iperf3`
- `speedtest-cli`
- и другие полезные сетевые утилиты

---

## 📥 Быстрая установка

### Рекомендуемый способ

```bash
curl -fsSL https://raw.githubusercontent.com/TViN-X/base-vps-soft-install/main/install.sh | bash
```

### Классический способ

```bash
git clone https://github.com/TViN-X/base-vps-soft-install.git

cd base-vps-soft-install

chmod +x install.sh

sudo ./install.sh
```

---

## 🔄 Полная переустановка

Если необходимо удалить старые конфигурации и установить всё заново:

```bash
sudo ./install.sh --reinstall
```

---

## 📦 Что устанавливает скрипт

### Терминал и оболочка

| Компонент | Назначение |
|-----------|------------|
| Zsh | Современная оболочка |
| Oh My Zsh | Менеджер конфигурации Zsh |
| Powerlevel10k | Быстрая и красивая тема |
| zsh-autosuggestions | Подсказки команд |
| zsh-syntax-highlighting | Подсветка синтаксиса |
| zsh-completions | Дополнительные автодополнения |

---

### Утилиты

| Утилита | Назначение |
|----------|------------|
| eza | Современная замена `ls` |
| btop | Мониторинг системы |
| htop | Просмотр процессов |
| mc | Файловый менеджер |
| nano | Текстовый редактор |
| fzf | Fuzzy-поиск |
| duf | Использование дисков |
| curl | Работа с HTTP-запросами |
| wget | Загрузка файлов |
| unzip | Работа с архивами |

---

### Сетевые инструменты

| Утилита | Назначение |
|----------|------------|
| nmap | Сканирование сети |
| tcpdump | Анализ сетевого трафика |
| iperf3 | Тестирование пропускной способности |
| speedtest-cli | Проверка скорости интернета |

---

## 📋 После установки

1. Закройте текущую SSH-сессию.
2. Подключитесь к серверу заново.
3. Новая оболочка Zsh будет активирована автоматически.
4. Powerlevel10k загрузится с готовой конфигурацией.

---

## ⚡ Полезные алиасы

После установки будут доступны удобные команды:

```bash
ls
ll
la
l
```

Все они используют `eza` вместо стандартного `ls`.

Также доступен быстрый поиск через `fzf`.

---

## 📌 Рекомендации

Для корректного отображения иконок рекомендуется использовать:

- Windows Terminal
- Nerd Fonts

### Рекомендуемый шрифт

**MesloLGS NF**

Скачать:

https://github.com/romkatv/powerlevel10k#manual-font-installation

---

## 🖼 Пример внешнего вида

![Powerlevel10k Preview](https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png)

---

## 🔒 Поддерживаемые системы

| ОС | Версия |
|-----|---------|
| Ubuntu | 24.04 |
| Debian | 12 |

---

## 📄 Лицензия

Проект распространяется под лицензией MIT.

Подробнее см. в файле:

```text
LICENSE
```

---

# 🇬🇧 English

## 🚀 base-vps-soft-install

Simple and powerful script for quickly setting up a modern, beautiful and productive terminal on a fresh VPS running **Ubuntu 24.04** or **Debian 12**.

### Features

- Zsh + Oh My Zsh + Powerlevel10k
- Autosuggestions, syntax highlighting and completions
- Thin blinking cursor
- Modern CLI utilities
- Network tools
- Russian and English language support
- Reinstall mode (`--reinstall`)
- Idempotent installation

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/TViN-X/base-vps-soft-install/main/install.sh | bash
```

### Reinstall

```bash
sudo ./install.sh --reinstall
```

### Recommended Terminal

- Windows Terminal
- MesloLGS NF Nerd Font

### Supported Systems

- Ubuntu 24.04
- Debian 12

---

Made with ❤️ for VPS users.
