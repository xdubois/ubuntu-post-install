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
    "gnome-software-plugin-flatpak"
    "extension-manager"
    "gnome-tweaks"
    "software-properties-common"
    "apt-transport-https"
    "ca-certificates"
    "gnupg"
    "lsb-release"
    "papirus-icon-theme"
    "arc-theme"
    "unzip"
    "htop"
    "net-tools"
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

section "4. Installing Flatpak and Applications"
log "Installing Flatpak support..."
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

log "Installing Flatpak applications..."
FLATPAK_APPS=(
    "io.github.qwersyk.Newelle"
    "net.nokyan.Resources"
)

# Optional Flatpak alternatives to Snap packages (comment/uncomment as needed)
FLATPAK_ALTERNATIVES=(
    "com.visualstudio.code"                # Alternative to VS Code snap
    "org.mozilla.firefox"                  # Alternative to Firefox snap
    "org.mozilla.Thunderbird"              # Alternative to Thunderbird snap
    "com.discordapp.Discord"               # Alternative to Discord snap
    "org.chromium.Chromium"                # Alternative to Chromium snap
    "com.spotify.Client"                   # Alternative to Spotify snap
    "org.keepassxc.KeePassXC"              # Alternative to KeePassXC snap
    "io.github.pinta_project.Pinta"       # Alternative to Pinta snap
    "org.remmina.Remmina"                  # Alternative to Remmina snap
    "com.getpostman.Postman"               # Alternative to Postman snap
    "com.valvesoftware.Steam"              # Alternative to Steam snap
)

# Prompt user for installation preference
read -p "Do you want to install Flatpak alternatives instead of Snap packages? (y/N): " use_flatpak_alternatives

for app in "${FLATPAK_APPS[@]}"; do
    log "Installing flatpak: $app"
    flatpak install -y flathub "$app" || warn "Failed to install flatpak: $app"
done

if [[ $use_flatpak_alternatives =~ ^[Yy]$ ]]; then
    log "Installing Flatpak alternatives to Snap packages..."
    for app in "${FLATPAK_ALTERNATIVES[@]}"; do
        log "Installing flatpak alternative: $app"
        flatpak install -y flathub "$app" || warn "Failed to install flatpak: $app"
    done
    
    # Skip snap installation if user chose Flatpak alternatives
    log "Skipping Snap package installation (using Flatpak alternatives)"
    SKIP_SNAPS=true
else
    log "Will install Snap packages in next section"
    SKIP_SNAPS=false
fi

section "5. Installing Snap Packages"
if [ "$SKIP_SNAPS" = "false" ]; then
    log "Installing snap packages..."

    SNAP_PACKAGES=(
        "android-studio --classic"
        "chromium"
        "code --classic"
        "dbeaver-ce"
        "discord"
        "firefox"
        "keepassxc"
        "kubectl --classic"
        "pinta"
        "postman"
        "remmina"
        "spotify"
        "steam"
        "thunderbird"
    )

    for package in "${SNAP_PACKAGES[@]}"; do
        log "Installing snap: $package"
        sudo snap install $package || warn "Failed to install snap: $package"
    done
else
    log "Skipping Snap packages (Flatpak alternatives chosen)"
fi

section "6. Installing kDrive AppImage"
log "Setting up kDrive AppImage..."

# Create apps directory if it doesn't exist
mkdir -p ~/apps

# Install dependencies for old AppImage format
log "Installing dependencies for AppImage support..."
sudo apt install -y fuse libfuse2

# Download kDrive AppImage (latest version)
log "Downloading kDrive AppImage..."
KDRIVE_URL="https://download.kdrive.infomaniak.com/desktop/latest/linux"
curl -L -o ~/apps/kDrive.AppImage "$KDRIVE_URL"

# Make it executable
chmod +x ~/apps/kDrive.AppImage

# Create desktop entry
log "Creating desktop entry for kDrive..."
cat > ~/.local/share/applications/kdrive.desktop << 'EOF'
[Desktop Entry]
Name=kDrive
Comment=Infomaniak kDrive cloud storage
Exec=~/apps/kDrive.AppImage
Icon=~/apps/kdrive-icon.png
Type=Application
Categories=Office;Network;
StartupWMClass=kDrive
EOF

# Download icon (fallback to a generic cloud icon if specific one not available)
curl -L -o ~/apps/kdrive-icon.png "https://www.kdrive.infomaniak.com/favicon-96x96.png" || warn "Failed to download kDrive icon"

log "kDrive AppImage installed successfully in ~/apps/"

section "7. Installing GNOME Extensions Support"
log "Installing GNOME Shell extensions support..."

# Install extension manager
sudo apt install -y extension-manager

log "Extension Manager installed successfully!"

# System extensions (pre-installed with Ubuntu)
SYSTEM_EXTENSIONS=(
    "tiling-assistant@ubuntu.com"
    "ubuntu-appindicators@ubuntu.com" 
    "ubuntu-dock@ubuntu.com"
    "ding@rastersoft.com"
)

# User extensions (need manual installation)
USER_EXTENSIONS=(
    "dash-to-panel@jderose9.github.com"
    "arcmenu@arcmenu.com"
    "BingWallpaper@ineffable-gmail.com"
    "Vitals@CoreCoding.com"
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

section "8. Installing ProtonVPN and Proton Mail Bridge"
log "Setting up Proton applications..."

# ProtonVPN via official repository
log "Adding ProtonVPN repository..."
wget -q -O - https://repo.protonvpn.com/debian/dists/stable/public_key.asc | sudo apt-key add -
echo "deb https://repo.protonvpn.com/debian stable main" | sudo tee /etc/apt/sources.list.d/protonvpn.list

# Update and install ProtonVPN
sudo apt update
sudo apt install -y protonvpn || warn "Failed to install ProtonVPN from repository"

# Proton Mail Bridge - try multiple installation methods
log "Installing Proton Mail Bridge..."

# Method 1: Try official .deb package
BRIDGE_DEB_URL="https://proton.me/download/bridge/protonmail-bridge_3.0.21-1_amd64.deb"
curl -L -o /tmp/protonmail-bridge.deb "$BRIDGE_DEB_URL"
sudo dpkg -i /tmp/protonmail-bridge.deb || {
    warn "Direct .deb installation failed, trying dependencies fix..."
    sudo apt-get install -f -y
    sudo dpkg -i /tmp/protonmail-bridge.deb || warn "Proton Mail Bridge installation failed"
}

# Clean up
rm -f /tmp/protonmail-bridge.deb

log "Proton applications setup completed!"

section "9. Restoring Keyboard Shortcuts"
log "Restoring GNOME keyboard shortcuts..."
if [ -f "gnome-keybindings.conf" ]; then
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.conf
    dconf load /org/gnome/desktop/wm/keybindings/ < gnome-keybindings.conf
    log "Keyboard shortcuts restored"
else
    warn "gnome-keybindings.conf not found. Creating template..."
    cat > gnome-keybindings.conf << 'EOF'
[/]
home=['<Super>e']
EOF
    warn "Edit gnome-keybindings.conf and re-run this section"
fi

section "10. Restoring Terminal Profile"
log "Restoring terminal profile..."
if [ -f "terminal-profiles.conf" ]; then
    dconf load /org/gnome/terminal/legacy/profiles:/ < terminal-profiles.conf
    log "Terminal profile restored"
else
    warn "terminal-profiles.conf not found. Run: dconf dump /org/gnome/terminal/legacy/profiles:/ > terminal-profiles.conf"
fi

section "11. Setting up Bash Profile"
log "Setting up bash profile..."

# Backup existing bashrc
cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)

# Check if bash_profile file exists
if [ -f ".bash_profile" ]; then
    log "Adding custom bash profile configuration..."
    echo "" >> ~/.bashrc
    echo "# Custom configuration from post-install script" >> ~/.bashrc
    echo "# Generated on $(date)" >> ~/.bashrc
    cat .bash_profile >> ~/.bashrc
    log "Bash profile configuration added to ~/.bashrc"
else
    warn ".bash_profile file not found. Skipping bash profile configuration."
fi
log "Bash profile updated. Source ~/.bashrc or restart terminal to apply changes."

section "12. Additional Development Tools"
log "Installing additional development tools..."

# Node.js via NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

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


section "13. Installing FiraCode Nerd Font"
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

section "14. Final Cleanup and System Configuration"
log "Performing final system cleanup..."

# Clean package cache
sudo apt autoremove -y
sudo apt autoclean

# Enable firewall
sudo ufw enable

log "Installing icon themes and additional customizations..."
sudo apt install -y papirus-icon-theme arc-theme

section "15. GNOME Configuration"
log "Configuring GNOME settings..."

# Remove rhythmbox from default applications
log "Removing rhythmbox from default applications..."
sudo apt remove --purge -y rhythmbox || warn "Rhythmbox removal failed or not installed"
sudo apt autoremove -y

# Enable window centering by default
log "Enabling window centering by default..."
gsettings set org.gnome.mutter center-new-windows true || warn "Failed to enable window centering"

log "GNOME configuration completed!"

section "Installation Complete!"
log "Post-installation script completed successfully!"
log ""
log "Please complete the following manual steps:"
log "1. Log out and back in to apply group changes (Docker)"
log "2. Install user GNOME extensions:"
log "   - Open 'Extension Manager' from applications menu"
log "   - Or use https://extensions.gnome.org/ with browser connector"
log "   - Install: Dash to Panel, ArcMenu, Bing Wallpaper, Vitals"
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
