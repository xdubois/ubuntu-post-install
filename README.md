# Linux Post-Install Setup

This repository contains scripts and configuration files to quickly set up a new Ubuntu/Debian system with your preferred applications and configurations.

## What's Included

### 1. **Application Installation**
- **Snap packages**: Chromium, VS Code, Discord, Firefox, Spotify, Steam, and more
- **Flatpak applications**: Cameractrls, Warehouse, Newelle
- **Vicinae**: quick launcher installed from the official install script, toggled with Ctrl+Space
- **Proton apps (optional)**: Proton Mail Bridge and Proton VPN, installed only if you say yes at the prompt
- **APT packages**: Git, Docker, Python, development tools, multimedia applications

### 2. **Development Environment**
- Docker with Docker Compose
- Node.js (LTS)
- uv (Python package and project manager)
- Composer (PHP) and k9s (Kubernetes TUI)
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
- **Extensions**: Bing Wallpaper, Vitals, Blur my Shell, Hide Top Bar, Tiling Assistant, and more
- **Keyboard shortcuts**: Super+E file manager, Ctrl+Space Vicinae, Shift+Ctrl+S screenshot UI
- **Desktop look**: Yaru purple dark theme, dark mode, fonts, hot corners off
- **Terminal profile**: Ptyxis profile with the Nord palette

### 6. **Shell Configuration**
- Enhanced bash profile with useful aliases and functions
- System utilities (extract function, mkcd, weather, etc.)
- Custom functions and improved history settings
- Environment variables for development
- Vim configuration (`.vimrc`: line numbers, cursor line, 4-space indentation)

## Files

- `post-install.sh` - Main installation script
- `bash_profile` - Custom bash configuration (aliases, functions, environment)
- `.vimrc` - Vim configuration
- `gnome-keybindings.conf` - Custom shortcuts (media-keys: Super+E, Ctrl+Space)
- `gnome-shell-keybindings.conf` - Shell shortcuts (Shift+Ctrl+S screenshot UI)
- `gnome-mutter-keybindings.conf` - Mutter shortcuts (tiling keys cleared for Tiling Assistant)
- `gnome-interface.conf` - Desktop look (theme, accent, dark mode, fonts)
- `terminal-profiles.conf` - Ptyxis terminal profile
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
   The script asks whether to install Proton Mail Bridge and Proton VPN. Set `INSTALL_PROTON=yes` or `INSTALL_PROTON=no` in the environment to skip the prompt.

4. **Follow the post-installation steps** displayed at the end

## Manual Steps Required

Some configurations require manual intervention:

1. **GNOME Extensions**: 
   - **Method 1 (Recommended)**: Open "Extension Manager" from applications menu
   - **Method 2**: Visit [extensions.gnome.org](https://extensions.gnome.org/) and install browser connector
   - Install user extensions:
     - Bing Wallpaper
     - Vitals
     - Blur my Shell
     - Hide Top Bar

2. **Git Configuration**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Docker Group**: Log out and back in to apply Docker group membership

## Current System Apps

### Snap Packages
- [btop](https://snapcraft.io/btop) - Resource monitor
- [Chromium](https://snapcraft.io/chromium) - Open-source web browser
- [VS Code](https://snapcraft.io/code) (classic) - Microsoft's code editor
- [DBeaver CE](https://snapcraft.io/dbeaver-ce) - Universal database tool
- [Discord](https://snapcraft.io/discord) - Voice and text chat for gaming
- [Firefox](https://snapcraft.io/firefox) - Mozilla web browser
- [glab](https://snapcraft.io/glab) - Official GitLab CLI
- [Papirus icon theme](https://snapcraft.io/icon-theme-papirus) - Papirus icons for snap apps
- [KeePassXC](https://snapcraft.io/keepassxc) - Password manager
- [kubectl](https://snapcraft.io/kubectl) (classic) - Kubernetes command-line tool
- [ONLYOFFICE Desktop Editors](https://snapcraft.io/onlyoffice-desktopeditors) - Office suite
- [OpenStack clients](https://snapcraft.io/openstackclients) (yoga channel) - OpenStack command-line clients
- [Pinta](https://snapcraft.io/pinta) - Simple image editor
- [Postman](https://snapcraft.io/postman) - API development and testing
- [Spotify](https://snapcraft.io/spotify) - Music streaming service
- [Steam](https://snapcraft.io/steam) - Gaming platform
- [Terraform](https://snapcraft.io/terraform) (classic) - Infrastructure as code
- [Thunderbird](https://snapcraft.io/thunderbird) - Email client

### Flatpak Applications
- [Cameractrls](https://github.com/soyersoyer/cameractrls) (hu.irl.cameractrls) - Webcam controls
- [Warehouse](https://github.com/flattool/warehouse) (io.github.flattool.Warehouse) - Flatpak manager (replaces GNOME Software)
- [Newelle](https://github.com/qwersyk/Newelle) (io.github.qwersyk.Newelle) - AI assistant application

### Vicinae Launcher
- [Vicinae](https://vicinae.com) - Raycast-like quick launcher. Installed under `/usr/local` by the official script (`https://vicinae.com/install`), runs as the `vicinae` user systemd service and is toggled with `Ctrl + Space`

### Proton Apps (optional)
- [Proton Mail Bridge](https://proton.me/mail/bridge) - Latest `.deb` from Proton's version manifest, signature-checked with Proton's Bridge key before install ([official guide](https://proton.me/support/installing-bridge-linux-deb-file))
- [Proton VPN](https://protonvpn.com) - `proton-vpn-gnome-desktop` from Proton's apt repository, repository package checksum-verified ([official guide](https://protonvpn.com/support/official-linux-vpn-ubuntu/))

### APT Packages (Non-default)
- flatpak - Universal app packaging format
- gnome-shell-extension-manager - [Extension Manager](https://github.com/mjakeman/extension-manager) by Matthew Jakeman (not GNOME's own "Extensions" app)
- Removed by the script: gnome-software (replaced by Warehouse) and gnome-shell-extension-prefs (GNOME's own "Extensions" app, replaced by Extension Manager)
- gnome-tweaks - Advanced GNOME configuration tool
- papirus-icon-theme, arc-theme - Icon and window themes
- Software packaging tools (software-properties-common, etc.)
- unzip, zip - Archive tools
- vim - Editor
- composer - PHP dependency manager
- flameshot - Screenshot tool

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
- [Bing Wallpaper](https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/) - Daily Bing wallpapers
- [Vitals](https://extensions.gnome.org/extension/1460/vitals/) - System monitor in top panel
- [Blur my Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/) - Blur effect on shell components
- [Hide Top Bar](https://extensions.gnome.org/extension/545/hide-top-bar/) - Auto-hide the top bar

## Terminal Profile

Ubuntu 26.04 ships [Ptyxis](https://gitlab.gnome.org/chergert/ptyxis) as the default terminal, replacing GNOME Terminal.
`terminal-profiles.conf` is a dump of the `/org/gnome/Ptyxis/` dconf tree and restores:
- The default profile with the Nord palette
- The saved window size

To refresh it after changing Ptyxis settings: `dconf dump /org/gnome/Ptyxis/ > terminal-profiles.conf`

## Keyboard Shortcuts

- `Super + E`: Open file manager
- `Ctrl + Space`: Toggle the Vicinae launcher
- `Shift + Ctrl + S`: Open the screenshot UI
- Mutter tiling shortcuts are cleared so Tiling Assistant handles tiling

## Desktop Look

`gnome-interface.conf` restores the Yaru purple dark theme and accent color, dark mode, hot corners off, weekday in the clock, Ubuntu Sans 11 as UI font and FiraCode Nerd Font Mono 13 as monospace font. Refresh it with `dconf dump /org/gnome/desktop/interface/ > gnome-interface.conf`.

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

- Ubuntu 26.04 LTS (Resolute) or compatible Debian-based distribution
- Internet connection for package downloads
- Sudo privileges
