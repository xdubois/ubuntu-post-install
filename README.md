# Linux Post-Install Setup

This repository contains scripts and configuration files to quickly set up a new Ubuntu/Debian system with your preferred applications and configurations.

## What's Included

### 1. **Application Installation**
- **Snap packages**: Android Studio, Chromium, VS Code, Discord, Firefox, Spotify, Steam, and more
- **Flatpak applications**: Newelle, Resources
- **APT packages**: Git, Docker, Python, development tools, multimedia applications

### 2. **Development Environment**
- Docker with Docker Compose
- Node.js (LTS) and Yarn
- Rust and Cargo
- Python 3 with pip
- Git configuration
- VS Code

### 3. **Rust Packages**
- **dysk**: Disk usage utility with a modern interface
- **eza**: Modern replacement for `ls` with colors and icons

### 4. **Font Installation**
- **FiraCode Nerd Font**: Programming font with ligatures and icons

### 5. **GNOME Configuration**
- **Extensions**: Dash to Panel, ArcMenu, Bing Wallpaper, Vitals, Tiling Assistant, and more
- **Keyboard shortcuts**: Custom keybindings (Super+E for file manager)
- **Terminal profile**: Custom Solarized Dark theme with transparency

### 6. **Shell Configuration**
- Enhanced bash profile with useful aliases and functions
- System utilities (extract function, mkcd, weather, etc.)
- Custom functions and improved history settings
- Environment variables for development

## Files

- `post-install.sh` - Main installation script
- `bash_profile` - Custom bash configuration (aliases, functions, environment)
- `gnome-keybindings.conf` - GNOME keyboard shortcuts configuration
- `terminal-profiles.conf` - Terminal profile settings
- `install-gnome-extensions.sh` - GNOME extensions installation guide
- `README.md` - This file

## Usage

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd linux-post-install
   ```

2. **Make the script executable**
   ```bash
   chmod +x post-install.sh
   ```

3. **Run the installation script**
   ```bash
   ./post-install.sh
   ```

4. **Follow the post-installation steps** displayed at the end

## Manual Steps Required

Some configurations require manual intervention:

1. **GNOME Extensions**: 
   - **Method 1 (Recommended)**: Open "Extension Manager" from applications menu
   - **Method 2**: Visit [extensions.gnome.org](https://extensions.gnome.org/) and install browser connector
   - Install user extensions:
     - Dash to Panel
     - ArcMenu  
     - Bing Wallpaper
     - Vitals

2. **Git Configuration**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Docker Group**: Log out and back in to apply Docker group membership

## Current System Apps

### Snap Packages
- [Android Studio](https://snapcraft.io/android-studio) (classic) - Official Android development IDE
- [Chromium](https://snapcraft.io/chromium) - Open-source web browser  
- [VS Code](https://snapcraft.io/code) (classic) - Microsoft's code editor
- [DBeaver CE](https://snapcraft.io/dbeaver-ce) - Universal database tool
- [Discord](https://snapcraft.io/discord) - Voice and text chat for gaming
- [Firefox](https://snapcraft.io/firefox) - Mozilla web browser
- [KeePassXC](https://snapcraft.io/keepassxc) - Password manager
- [kubectl](https://snapcraft.io/kubectl) (classic) - Kubernetes command-line tool
- [Pinta](https://snapcraft.io/pinta) - Simple image editor
- [Postman](https://snapcraft.io/postman) - API development and testing
- [Remmina](https://snapcraft.io/remmina) - Remote desktop client
- [Spotify](https://snapcraft.io/spotify) - Music streaming service
- [Steam](https://snapcraft.io/steam) - Gaming platform
- [Thunderbird](https://snapcraft.io/thunderbird) - Email client

### Flatpak Applications
- [Newelle](https://github.com/qwersyk/Newelle) (io.github.qwersyk.Newelle) - AI assistant application
- [Resources](https://github.com/nokyan/resources) (net.nokyan.Resources) - System monitor

### APT Packages (Non-default)
- flatpak - Universal app packaging format
- extension-manager - GNOME Shell extensions manager
- gnome-tweaks - Advanced GNOME configuration tool
- papirus-icon-theme, arc-theme - Icon and window themes
- Software packaging tools (software-properties-common, etc.)
- unzip - Archive extraction utility

### Rust Packages (Crates)
- [dysk](https://crates.io/crates/dysk) - A disk usage utility with a modern interface
- [eza](https://crates.io/crates/eza) - A modern, maintained replacement for `ls` with colors and icons

### Font Installation
- [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) - Programming font with ligatures and Nerd Font icons

### GNOME Extensions

#### System Extensions (Pre-installed with Ubuntu)
- [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/) - Advanced window tiling
- [Ubuntu AppIndicators](https://extensions.gnome.org/extension/615/appindicator-support/) - System tray support
- [Ubuntu Dock](https://extensions.gnome.org/extension/1117/dash-to-dock/) - Enhanced dock functionality
- [Desktop Icons NG (DING)](https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/) - Desktop icons support

#### User Extensions (Manual Installation Required)
- [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/) - Combines top panel and dock
- [ArcMenu](https://extensions.gnome.org/extension/3628/arcmenu/) - Application menu for GNOME
- [Bing Wallpaper](https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/) - Daily Bing wallpapers
- [Vitals](https://extensions.gnome.org/extension/1460/vitals/) - System monitor in top panel

## Terminal Profile

The included terminal profile features:
- Solarized Dark color scheme
- Transparent background (3%)
- Custom size (132x32)
- Optimized for development work

## Keyboard Shortcuts

- `Super + E`: Open file manager

## Customization

Feel free to modify the files according to your needs:
- Edit `post-install.sh` to add/remove packages
- Modify `bash_profile` to customize shell aliases and functions
- Adjust `gnome-keybindings.conf` for different shortcuts
- Update `terminal-profiles.conf` for your preferred terminal appearance

### Bash Profile Features

The `bash_profile` includes:
- **Aliases**: Shortcuts for common commands (ll, la, cls, etc.)
- **Environment setup**: PATH modifications, editor settings, colored output

## Requirements

- Ubuntu 24.04 LTS (Noble) or compatible Debian-based distribution
- Internet connection for package downloads
- Sudo privileges
