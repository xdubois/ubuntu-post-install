#!/bin/bash
# Linux Post-Install Script for Ubuntu/Debian
# Generated on $(date)
# This script installs applications, GNOME extensions, and restores configurations

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

section() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
   exit 1
fi

section "1. Updating System Packages"
sudo apt update && sudo apt upgrade -y

section "2. Installing Main APT Packages"
log "Installing essential development and application packages..."

# Main applications and development tools (excluding default packages)
APT_PACKAGES=(
    "flatpak"
    "gnome-shell-extension-manager"  # Extension Manager by Matthew Jakeman (com.mattjakeman.ExtensionManager)
    "gnome-tweaks"
    "software-properties-common"
    "apt-transport-https"
    "ca-certificates"
    "gnupg"
    "lsb-release"
    "papirus-icon-theme"
    "arc-theme"
    "unzip"
    "zip"
    "jq"    # required by the Vicinae install script
    "vim"
    "composer"
    "flameshot"
)

for package in "${APT_PACKAGES[@]}"; do
    log "Installing $package..."
    sudo apt install -y "$package" || warn "Failed to install $package"
done

section "3. Installing Docker (Official Repository)"
log "Setting up Docker official repository..."
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER
log "Added $USER to docker group. Please log out and back in for changes to take effect."

section "4. Installing Snap Packages"
log "Installing snap packages..."

SNAP_PACKAGES=(
    "btop"
    "chromium"
    "code --classic"
    "dbeaver-ce"
    "discord"
    "firefox"
    "glab"
    "icon-theme-papirus"
    "keepassxc"
    "kubectl --classic"
    "onlyoffice-desktopeditors"
    "openstackclients --channel=yoga"
    "pinta"
    "postman"
    "spotify"
    "steam"
    "terraform --classic"
    "thunderbird"
)

for package in "${SNAP_PACKAGES[@]}"; do
    log "Installing snap: $package"
    sudo snap install $package || warn "Failed to install snap: $package"
done

section "5. Installing Flatpak and Applications"
log "Installing Flatpak support..."
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# GNOME Software (and its flatpak plugin) is replaced by Warehouse, installed below as a flatpak.
log "Removing GNOME Software if present..."
sudo apt purge -y gnome-software gnome-software-plugin-flatpak gnome-software-plugin-snap || warn "Failed to remove GNOME Software"

log "Installing Flatpak applications..."
FLATPAK_APPS=(
    "hu.irl.cameractrls"            # Cameractrls - webcam controls
    "io.github.flattool.Warehouse"  # Warehouse - flatpak manager (replaces GNOME Software)
    "io.github.qwersyk.Newelle"     # Newelle - AI assistant
)

for app in "${FLATPAK_APPS[@]}"; do
    log "Installing flatpak: $app"
    flatpak install -y flathub "$app" || warn "Failed to install flatpak: $app"
done

section "6. Installing GNOME Extensions Support"
log "Installing GNOME Shell extensions support..."

# Install Extension Manager by Matthew Jakeman (https://github.com/mjakeman/extension-manager).
# Ubuntu packages it as gnome-shell-extension-manager. This is NOT GNOME's own "Extensions" app
# (gnome-shell-extension-prefs), which we do not want.
sudo apt install -y gnome-shell-extension-manager

log "Extension Manager installed successfully!"

# Remove GNOME's own "Extensions" app so only Extension Manager remains.
log "Removing GNOME's Extensions app if present..."
sudo apt purge -y gnome-shell-extension-prefs || warn "Failed to remove gnome-shell-extension-prefs"

# System extensions (pre-installed with Ubuntu)
SYSTEM_EXTENSIONS=(
    "tiling-assistant@ubuntu.com"
    "ubuntu-appindicators@ubuntu.com" 
    "ubuntu-dock@ubuntu.com"
    "ding@rastersoft.com"
)

# User extensions (need manual installation)
USER_EXTENSIONS=(
    "BingWallpaper@ineffable-gmail.com"  # Bing Wallpaper
    "Vitals@CoreCoding.com"              # Vitals
    "blur-my-shell@aunetx"               # Blur my Shell
    "hidetopbar@mathieu.bidon.ca"        # Hide Top Bar
)

log "System extensions (should already be available):"
for ext in "${SYSTEM_EXTENSIONS[@]}"; do
    log "   ✓ $ext"
done

warn "User extensions need to be installed manually:"
warn "1. Open 'Extension Manager' from applications menu"
warn "2. Or visit https://extensions.gnome.org/ in Firefox"
warn "3. Install the browser connector if using web method"
warn "4. Install the following user extensions:"
for ext in "${USER_EXTENSIONS[@]}"; do
    warn "   - $ext"
done

section "7. Installing Vicinae Launcher"
# Vicinae (https://vicinae.com) is our quick launcher, toggled with Ctrl+Space (see section 9).
# The official installer needs curl + jq, installs under /usr/local and ships a systemd user
# service. It is run through sudo directly: as a normal user it stops to ask for sudo on the tty.
log "Installing Vicinae launcher..."
if curl -fsSL https://vicinae.com/install | sudo -E bash; then
    # The extracted AppImage tree can end up unreadable for regular users; make sure it is not.
    sudo chmod -R a+rX /usr/local/lib/vicinae
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now vicinae || warn "Could not enable the vicinae user service. Run: systemctl --user enable --now vicinae"
    log "Vicinae installed and its user service enabled"
else
    warn "Vicinae installation failed. See https://docs.vicinae.com/install/script"
fi

section "8. Installing Proton Apps (optional)"
# Proton Mail Bridge + Proton VPN. Skipped unless you answer yes at the prompt,
# or run the script with INSTALL_PROTON=yes (INSTALL_PROTON=no skips the prompt).
# Official instructions:
#   https://proton.me/support/installing-bridge-linux-deb-file
#   https://protonvpn.com/support/official-linux-vpn-ubuntu/
if [ -z "${INSTALL_PROTON:-}" ]; then
    read -r -p "Install Proton Mail Bridge and Proton VPN? [y/N] " INSTALL_PROTON || INSTALL_PROTON="no"
fi
case "${INSTALL_PROTON,,}" in
    y|yes)
        log "Installing Proton Mail Bridge..."
        # Proton publishes the current .deb URL in a version manifest. The package comes with a
        # detached signature made by Proton's Bridge key, which is checked before installing.
        BRIDGE_DEB_URL=$(curl -fsSL https://proton.me/download/current_version_linux.json | jq -r '.DebFile')
        BRIDGE_DEB="/tmp/$(basename "$BRIDGE_DEB_URL")"
        BRIDGE_GPG_HOME=$(mktemp -d)
        if curl -fsSL -o "$BRIDGE_DEB" "$BRIDGE_DEB_URL" \
            && curl -fsSL -o "$BRIDGE_DEB.sig" "$BRIDGE_DEB_URL.sig" \
            && curl -fsSL https://proton.me/download/bridge/bridge_pubkey.gpg | gpg --homedir "$BRIDGE_GPG_HOME" --import 2>/dev/null \
            && gpg --homedir "$BRIDGE_GPG_HOME" --verify "$BRIDGE_DEB.sig" "$BRIDGE_DEB" 2>/dev/null; then
            sudo apt install -y "$BRIDGE_DEB" || warn "Failed to install Proton Mail Bridge"
        else
            warn "Proton Mail Bridge download or signature check failed. Skipping."
        fi
        rm -rf "$BRIDGE_GPG_HOME" "$BRIDGE_DEB" "$BRIDGE_DEB.sig"

        log "Installing Proton VPN..."
        # Repository package and its checksum as published on the official page.
        PROTONVPN_RELEASE_DEB="protonvpn-stable-release_1.0.8_all.deb"
        PROTONVPN_RELEASE_SHA256="0b14e71586b22e498eb20926c48c7b434b751149b1f2af9902ef1cfe6b03e180"
        if curl -fsSL -o "/tmp/$PROTONVPN_RELEASE_DEB" "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/$PROTONVPN_RELEASE_DEB" \
            && echo "$PROTONVPN_RELEASE_SHA256 /tmp/$PROTONVPN_RELEASE_DEB" | sha256sum --check --quiet -; then
            if sudo dpkg -i "/tmp/$PROTONVPN_RELEASE_DEB" && sudo apt update; then
                # Installs the GNOME app and the CLI. The tray icon uses Ubuntu's built-in AppIndicator extension.
                sudo apt install -y proton-vpn-gnome-desktop || warn "Failed to install Proton VPN"
            else
                warn "Failed to set up the Proton VPN repository"
            fi
        else
            warn "Proton VPN repository package download or checksum check failed. Skipping."
        fi
        rm -f "/tmp/$PROTONVPN_RELEASE_DEB"
        ;;
    *)
        log "Skipping Proton Mail Bridge and Proton VPN"
        ;;
esac

section "9. Restoring Keyboard Shortcuts"
log "Restoring GNOME keyboard shortcuts..."
# gnome-keybindings.conf        dump of /org/gnome/settings-daemon/plugins/media-keys/
#                               (Super+E file manager, Ctrl+Space Vicinae launcher)
# gnome-shell-keybindings.conf  dump of /org/gnome/shell/keybindings/ (Shift+Ctrl+S screenshot UI)
# gnome-mutter-keybindings.conf dump of /org/gnome/mutter/keybindings/ (tiling keys cleared for Tiling Assistant)
restore_dconf() {
    local file="$1" path="$2"
    if [ -f "$file" ]; then
        dconf load "$path" < "$file"
        log "Restored $path from $file"
    else
        warn "$file not found. Run: dconf dump $path > $file"
    fi
}
restore_dconf gnome-keybindings.conf        /org/gnome/settings-daemon/plugins/media-keys/
restore_dconf gnome-shell-keybindings.conf  /org/gnome/shell/keybindings/
restore_dconf gnome-mutter-keybindings.conf /org/gnome/mutter/keybindings/

section "10. Restoring Desktop Look"
# gnome-interface.conf is a dump of /org/gnome/desktop/interface/: Yaru purple dark theme and
# accent, dark mode, hot corners off, clock options, Ubuntu Sans UI font and FiraCode Nerd Font
# Mono as monospace font (installed later in the script; the setting applies once it is there).
restore_dconf gnome-interface.conf /org/gnome/desktop/interface/

section "11. Restoring Terminal Profile"
# Ubuntu 26.04 ships Ptyxis as the default terminal (GNOME Terminal is no longer installed).
# terminal-profiles.conf is a dump of /org/gnome/Ptyxis/ (profiles, default profile, palette).
log "Restoring Ptyxis terminal profile..."
if [ -f "terminal-profiles.conf" ]; then
    dconf load /org/gnome/Ptyxis/ < terminal-profiles.conf
    log "Ptyxis terminal profile restored"
else
    warn "terminal-profiles.conf not found. Run: dconf dump /org/gnome/Ptyxis/ > terminal-profiles.conf"
fi

section "12. Setting up Bash Profile and Vim"
log "Setting up bash profile..."

# Backup existing bashrc
cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)

# Check if .bash_profile file exists
if [ -f ".bash_profile" ]; then
    log "Adding custom bash profile configuration..."
    echo "" >> ~/.bashrc
    echo "# Custom configuration from post-install script" >> ~/.bashrc
    echo "# Generated on $(date)" >> ~/.bashrc
    cat .bash_profile >> ~/.bashrc
    log "Bash profile configuration added to ~/.bashrc"
    log "Bash profile updated. Source ~/.bashrc or restart terminal to apply changes."
else
    warn ".bash_profile not found. Skipping bash profile setup."
fi

# Vim configuration
if [ -f ".vimrc" ]; then
    if [ -f ~/.vimrc ]; then
        cp ~/.vimrc ~/.vimrc.backup.$(date +%Y%m%d_%H%M%S)
    fi
    cp .vimrc ~/.vimrc
    log ".vimrc installed to ~/.vimrc"
else
    warn ".vimrc not found. Skipping vim setup."
fi

section "13. Additional Development Tools"
log "Installing additional development tools..."

# Node.js via NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Rust and Cargo
log "Installing Rust and Cargo..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
log "Rust and Cargo installed successfully"

# Rust packages
log "Installing Rust packages..."
~/.cargo/bin/cargo install dysk
~/.cargo/bin/cargo install eza
log "Rust packages (dysk, eza) installed successfully"

# uv (Python package and project manager) via Astral's official installer, into ~/.local/bin
log "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh || warn "Failed to install uv"

# k9s (Kubernetes TUI) from the latest GitHub release .deb
log "Installing k9s..."
if curl -fsSL -o /tmp/k9s_linux_amd64.deb https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb; then
    sudo apt install -y /tmp/k9s_linux_amd64.deb || warn "Failed to install k9s"
else
    warn "Failed to download k9s"
fi
rm -f /tmp/k9s_linux_amd64.deb


section "14. Installing FiraCode Nerd Font"
log "Downloading and installing FiraCode Nerd Font..."

# Create fonts directory if it doesn't exist
mkdir -p ~/.fonts

# Download FiraCode Nerd Font
log "Downloading FiraCode.zip from GitHub releases..."
curl -L -o /tmp/FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"

# Extract to fonts directory
log "Extracting FiraCode.zip to ~/.fonts..."
unzip -o /tmp/FiraCode.zip -d ~/.fonts/

# Update font cache
log "Updating font cache..."
fc-cache -fv

# Clean up
rm /tmp/FiraCode.zip

log "FiraCode Nerd Font installed successfully!"

section "15. Final Cleanup and System Configuration"
log "Performing final system cleanup..."

# Clean package cache
sudo apt autoremove -y
sudo apt autoclean

# Enable firewall
sudo ufw enable

log "Installing icon themes and additional customizations..."
sudo apt install -y papirus-icon-theme arc-theme

section "Installation Complete!"
log "Post-installation script completed successfully!"
log ""
log "Please complete the following manual steps:"
log "1. Log out and back in to apply group changes (Docker)"
log "2. Install user GNOME extensions:"
log "   - Open 'Extension Manager' from applications menu"
log "   - Or use https://extensions.gnome.org/ with browser connector"
log "   - Install: Bing Wallpaper, Vitals, Blur my Shell, Hide Top Bar"
log "3. Configure Git with your credentials:"
log "   git config --global user.name 'Your Name'"
log "   git config --global user.email 'your.email@example.com'"
log "4. Import terminal profile if not automatically applied"
log "5. Restart your system to ensure all changes take effect"
log ""
log "System extensions (Tiling Assistant, Ubuntu AppIndicators, Ubuntu Dock, DING)"
log "should already be available and can be managed via Extension Manager."
log ""
log "Enjoy your newly configured system! 🎉"
