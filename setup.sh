#!/bin/bash

# KUDU SETUP SCRIPT - ULTRA CLEAN & EFFICIENT EDITION
# DEFINE COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# DISPLAY ASCII ART
display_logo() {
    echo -e "${MAGENTA}"
    cat << "EOF"
                                          .@@@-                      -@@@.                                          
                                        -@@@:@+                      +@-@@@-                                        
                                       %@@@@@@-                      -@@@@@@#                                       
                                     :@@@*@@=                          +@@+@@@                                      
                                     @@@-@@:                            :@@:@@@                                     
                                    *@@+@@*                              +@@*@@+                                    
                                    @@@:@@:                              .@@.@@@                                    
                                    @@.-@@=            -@@@@-            :@@..@@                                    
                                    @@ :@@@        .@@@=+.:=#@@@         @@@  @@                                    
                                    @@+  @@@    *@@@@+@%%*##@##%@@@=    %@@: :@@                                    
                                    @@@@@@@@@@@@+@-@@@@#%@@=@@@%% @*@@%@@#@@@@@@                                    
                                    :@@@@@@#@@=%+@@@:   @%@%   =@@@*%=@@@@@@@@@-                                    
                                     +@ @@@@@#:#%       @#@#       @#=#@*@@@ @+                                     
                              @@@@@@*.*@%@@@@@@@@@=     %*#*     -@@@@@@@*@@@=:#@@@@@*                              
                              @@@@@@+@@@.@@@@@@@%+#@@@@@@@@@@@@@@+*@@@@@@@@.@@@=@@@@@@                              
                              @@@:@@@@@@@@%##++@@%@@@@@@@@@@@@@@@@#@@##@#@@@@@@@@@.@@*                              
                               @@@@@@@@@ @@@@@%@@@@@@:- -@@- :-@@@@@@@@@@@% @@@@@@@@@                               
                               +@@@@ #@@@:*@@.@%@@@%  :-+%%+:.  %@@@=@.@@*:@@@+ @@@@.                               
                               *@@@@@# @@@@@@@ @@@#     %#@#     %@@@ @@@@@@% @@@@@@.                               
                               @@@@@@@@@@@@@@@@@@@@@@#  *+*+  %@@@@@@%@@@@@@@@@@@@=@=                               
                               @@@@+@@@@@@@@@@@@@@@=@@@@=++-@@@@:@@@@@#@@@@@@@@@:@*@+                               
                               @@@@   --.   .@@@@+@@@@@@*++#@@@@@@*@@@@    :=-   @#@*                               
                               @@@@+-...:    @@@@@@@.@@@@++@@@@ @@@@@@@    : :.=*@%@%                               
                               @@@@ + :: .    @@#@@@@@@@@==@@@@@@@@#@@      -- * @@@%                               
                               @@@@+-  . .    @@@@@@*@@+==:+*@@-@@@%@@    . .  =*@@@@                               
                               @@@@ -@@@@#%#- @@@@@@@@@*---=@@#@@@@@@@ :*%%@@@%  @@@@                               
                               @@@@ =@:*-  := @@@@@ @@@@:--.@@@@:@@@@# =-  #*@@  @%@@                               
                               @@@@ :@@@@%%#=*@@@@@@@@@@ .. @@@@@@@@@@=-#@@@@@%  @%@%                               
                               @@@@      .   @@%%@@@@@@@    @@@@@@@@*@@          @%@%                               
                               @@@@ -=.. .  :@@@@@@@@*@@-  *@@@@@@@@@@@.  . .-+- @%@%                               
                               @@@@.:..=:.  @@@:@@@@@-@@@@@@@@.@@@@@:@@@  .:=- = @%@%                               
                               @@@@ -=:.=. +@@-: @@@@@@@@@@@@@@@@@@ --@@= .-.:+- @@@%                               
                               @@@@.--.=:.=@@@-#:+@+@@@%@@@@+@@@*@=:#-@@@-.:= ==.@%@#                               
                               @@+@@.::*-.@@@  #:+@@-@@@%@@+@@@:@@=-# :@@@.=+.-:@@.@=                               
                               -@@*@@@* .@@@.  -#--@@.@@@:-@@% @@=.#-  -@@%-.*@@++@@                                
                                -@@@+#@@@@@@@:  #:=@@=.@@@@@@.=@@:-+  -@@@#@@%#%@@@.                                
                                  .@@@# =+ @@@@%.%=*@@=      *@@*-# @@@@@:*+.%@@#                                   
                                     =@@@#:*#.@@@@-=@@@@-  -@@@@==@@@@ *= %@@@:                                     
                                        #@@@=*#=#@@@#%@@@@@@@@+@@@@-**=*@@@=                                        
                                          .@@@% *# @@@@*@@@@-@@@@:#+-@@@#                                           
                                             =@@@*=#*-@@@%@@@@ *= @@@@:                                             
                                                %@@@:++:*@@=-+-*@@@=                                                
                                                  :@@@% -::-.@@@#                                                   
                                                     +@@@@@@@@:                                                     
                                                        :*+.                                                        
EOF
    echo -e "${RESET}"
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║                  ${WHITE}KUDU ARCH SETUP - ULTRA CLEAN EDITION${CYAN}                ║${RESET}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# ENSURE SCRIPT IS RUN AS ROOT
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}PLEASE RUN AS ROOT${RESET}"
  exit 1
fi

# FUNCTION TO DISPLAY PROGRESS
show_progress() {
  echo ""
  echo -e "${YELLOW}╔════════════════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${YELLOW}║ 🚀 ${GREEN}$1${YELLOW} ${RESET}"
  echo -e "${YELLOW}╚════════════════════════════════════════════════════════════════════╝${RESET}"
  echo ""
}

# PROGRESS BAR FUNCTION
progress_bar() {
  local current=$1
  local total=$2
  local text=$3
  local width=50
  local percent=$((current * 100 / total))
  local completed=$((width * current / total))
  local remaining=$((width - completed))
  
  printf "\r[${GREEN}"
  for ((i=0; i<completed; i++)); do printf "█"; done
  printf "${RESET}"
  for ((i=0; i<remaining; i++)); do printf "░"; done
  printf "${RESET}] ${percent}%% - ${CYAN}${text}${RESET}"
  
  if [ $current -eq $total ]; then
    echo ""
  fi
}

# SETUP LOGGING
LOG_FILE="/var/log/kudu-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# DISPLAY LOGO AT START
display_logo

# GET USERNAME
USERNAME=$(logname || whoami)
if [ "$USERNAME" = "root" ]; then
  USERNAME=$(find /home -mindepth 1 -maxdepth 1 -type d | head -n 1 | awk -F'/' '{print $NF}')
fi

# CONFIGURE SUDO TO NOT REQUIRE PASSWORD FOR THIS USER DURING INSTALLATION
show_progress "CONFIGURING SUDO FOR PASSWORDLESS OPERATION DURING INSTALL"
if ! grep -q "$USERNAME ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

show_progress "STARTING KUDU SETUP WITH ULTRA CLEAN & EFFICIENT CONFIGURATION"

# PERFORMANCE OPTIMIZATIONS - EARLY SETUP
show_progress "APPLYING PERFORMANCE OPTIMIZATIONS"

# Enable multilib repository for better package availability
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# Optimize pacman for speed
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 15/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf

# Add ILoveCandy for better progress bars
sed -i '/^#VerbosePkgLists/a ILoveCandy' /etc/pacman.conf

# UPDATE SYSTEM WITH FASTEST MIRRORS
show_progress "UPDATING SYSTEM WITH OPTIMIZED MIRRORS"
pacman -Sy --noconfirm reflector
reflector --country 'United Kingdom' --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syu --noconfirm

# INSTALL BASE PACKAGES
show_progress "INSTALLING OPTIMIZED BASE PACKAGES"
pacman -S --noconfirm base-devel git sudo wget curl zram-generator preload

# SETUP TOTAL STEPS FOR PROGRESS BAR
TOTAL_STEPS=35
CURRENT_STEP=0

# SETUP ZRAM FOR BETTER MEMORY MANAGEMENT
show_progress "CONFIGURING ZRAM FOR OPTIMAL MEMORY USAGE"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting up ZRAM..."
cat > /etc/systemd/zram-generator.conf << 'EOL'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOL
systemctl daemon-reload
systemctl enable systemd-zram-setup@zram0.service

# SSD OPTIMIZATIONS
show_progress "APPLYING SSD OPTIMIZATIONS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Optimizing for SSD..."
echo 'noatime,discard' >> /etc/fstab
# Enable fstrim timer for SSD maintenance
systemctl enable fstrim.timer

# INSTALL MINIMAL GNOME WITH PERFORMANCE TWEAKS
show_progress "INSTALLING MINIMAL GNOME DESKTOP"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing minimal GNOME..."
pacman -S --noconfirm gnome-shell gdm gnome-terminal gnome-control-center \
gnome-tweaks gnome-keyring nautilus networkmanager xdg-user-dirs \
gnome-session gnome-settings-daemon

# ENABLE SERVICES
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Enabling services..."
systemctl enable gdm.service
systemctl enable NetworkManager.service
systemctl enable preload.service

# INSTALL CORE UTILITIES
show_progress "INSTALLING CORE UTILITIES"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing core utilities..."
pacman -S --noconfirm zsh zsh-completions flatpak firefox \
htop neofetch tree unzip zip p7zip

# INSTALL APPLICATIONS
show_progress "INSTALLING APPLICATIONS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing applications..."
pacman -S --noconfirm chromium discord gnome-boxes code

# SETUP FLATPAK
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting up Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# INSTALL YAY AUR HELPER
show_progress "INSTALLING YAY AUR HELPER"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing yay AUR helper..."
cd /tmp
sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $USERNAME makepkg -si --noconfirm

# INSTALL AUR PACKAGES
show_progress "INSTALLING AUR PACKAGES"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing AUR packages..."
sudo -u $USERNAME yay -S --noconfirm postman-bin teams-for-linux spotify \
extension-manager visual-studio-code-bin

# INSTALL VS CODE EXTENSIONS
show_progress "INSTALLING VS CODE EXTENSIONS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing VS Code extensions..."
sudo -u $USERNAME code --install-extension ms-python.python --force
sudo -u $USERNAME code --install-extension golang.go --force
sudo -u $USERNAME code --install-extension eamodio.gitlens --force
sudo -u $USERNAME code --install-extension ms-azuretools.vscode-azurefunctions --force

# INSTALL OH MY ZSH WITH PERFORMANCE OPTIMIZATIONS
show_progress "SETTING UP ZSH WITH POWERLEVEL10K THEME"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting up ZSH..."
sudo -u $USERNAME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# INSTALL POWERLEVEL10K THEME
sudo -u $USERNAME git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USERNAME/.oh-my-zsh/custom/themes/powerlevel10k

# CONFIGURE ZSH WITH PERFORMANCE OPTIMIZATIONS
cat > /home/$USERNAME/.zshrc << 'EOL'
# ENABLE POWERLEVEL10K INSTANT PROMPT
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH TO YOUR OH-MY-ZSH INSTALLATION
export ZSH="$HOME/.oh-my-zsh"

# SET THEME
ZSH_THEME="powerlevel10k/powerlevel10k"

# OPTIMIZED PLUGINS FOR PERFORMANCE
plugins=(git sudo history command-not-found)

# PERFORMANCE OPTIMIZATIONS
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

source $ZSH/oh-my-zsh.sh

# ENHANCED PACMAN ALIASES
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -Rs"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias cleanup="sudo pacman -Rns \$(pacman -Qtdq) 2>/dev/null || echo 'No orphans to remove'"
alias mirror="sudo reflector --country 'United Kingdom' --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
alias fastmirror="sudo reflector --fastest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"

# SYSTEM MONITORING ALIASES
alias temps="sensors"
alias processes="htop"
alias diskspace="df -h"
alias meminfo="free -h"
alias sysinfo="neofetch"

# P10K CONFIGURATION
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
chsh -s /bin/zsh $USERNAME

# INSTALL GNOME EXTENSIONS WITH PERFORMANCE FOCUS
show_progress "INSTALLING PERFORMANCE-FOCUSED GNOME EXTENSIONS"
pacman -S --noconfirm gnome-browser-connector

# Create extensions directory
sudo -u $USERNAME mkdir -p /home/$USERNAME/.local/share/gnome-shell/extensions

# Install essential extensions only for performance
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing essential extensions..."

# Dash to Dock (lightweight dock)
cd /tmp
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-dash-to-dock

# App Indicator Support
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-appindicator

# Caffeine (prevent sleep)
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-caffeine

# User Themes (for custom themes)
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-user-theme

# INSTALL ULTRA DARK THEME
show_progress "INSTALLING ULTRA DARK THEME SETUP"

# CREATE THEMES AND ICONS DIRECTORIES
sudo -u $USERNAME mkdir -p /home/$USERNAME/.themes
sudo -u $USERNAME mkdir -p /home/$USERNAME/.icons

# INSTALL DARKER PAPIRUS THEME
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing dark icon theme..."
pacman -S --noconfirm papirus-icon-theme
sudo -u $USERNAME git clone https://github.com/PapirusDevelopmentTeam/papirus-folders.git /tmp/papirus-folders
cd /tmp/papirus-folders
sudo -u $USERNAME ./install.sh --color black

# INSTALL ULTRA DARK GTK THEME
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing ultra dark GTK theme..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/EliverLara/Nordic.git
sudo -u $USERNAME cp -r Nordic /home/$USERNAME/.themes/

# INSTALL ULTRA DARK SHELL THEME
sudo -u $USERNAME git clone https://github.com/daniruiz/flat-remix-gnome.git
sudo -u $USERNAME cp -r flat-remix-gnome/Flat-Remix-Dark-fullPanel /home/$USERNAME/.themes/

# APPLY ULTRA DARK THEME
show_progress "APPLYING ULTRA DARK THEME"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Applying ultra dark theme..."
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Nordic'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell.extensions.user-theme name 'Flat-Remix-Dark-fullPanel'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

# DOWNLOAD AND SET THE NEW JELLYFISH WALLPAPER
show_progress "SETTING CUSTOM JELLYFISH WALLPAPER"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting jellyfish wallpaper..."
# Download your jellyfish image (replace URL with actual image location)
wget -q "https://raw.githubusercontent.com/yourusername/yourrepo/main/jellyfish-wallpaper.jpg" -O /home/$USERNAME/jellyfish-wallpaper.jpg || {
    # Fallback to a similar dark jellyfish wallpaper
    wget -q "https://wallpaperaccess.com/full/2637581.jpg" -O /home/$USERNAME/jellyfish-wallpaper.jpg
}
chown $USERNAME:$USERNAME /home/$USERNAME/jellyfish-wallpaper.jpg
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.background picture-uri "file:///home/$USERNAME/jellyfish-wallpaper.jpg"
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USERNAME/jellyfish-wallpaper.jpg"

# CONFIGURE ULTRA DARK TERMINAL
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Configuring ultra dark terminal..."
profile=$(sudo -u $USERNAME dbus-launch gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
# Ultra dark terminal colors
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#0C0C0C'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#F8F8F2'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-transparent-background true
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-transparency-percent 5

# ENABLE EXTENSIONS
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Enabling extensions..."
sudo -u $USERNAME dbus-launch gnome-extensions enable dash-to-dock@micxgx.gmail.com
sudo -u $USERNAME dbus-launch gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
sudo -u $USERNAME dbus-launch gnome-extensions enable caffeine@patapon.info
sudo -u $USERNAME dbus-launch gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# CONFIGURE GNOME SETTINGS FOR PERFORMANCE
show_progress "OPTIMIZING GNOME SETTINGS FOR PERFORMANCE"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Configuring GNOME settings..."
# Restore window buttons
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
# Disable animations for performance
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface enable-animations false
# Set performance governor
echo 'performance' | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# Optimize file manager
sudo -u $USERNAME dbus-launch gsettings set org.gnome.nautilus.preferences show-hidden-files false
sudo -u $USERNAME dbus-launch gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'

# CONFIGURE DASH TO DOCK
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Configuring Dash to Dock..."
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items false

# SET DEFAULT APPLICATIONS
show_progress "SETTING DEFAULT APPLICATIONS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting default applications..."
sudo -u $USERNAME xdg-settings set default-web-browser chromium.desktop

# SYSTEM PERFORMANCE TUNING
show_progress "APPLYING ADVANCED PERFORMANCE TUNING"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Applying performance tuning..."

# Create performance tuning script
cat > /etc/systemd/system/performance-tuning.service << 'EOL'
[Unit]
Description=Performance Tuning
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
ExecStart=/bin/bash -c 'echo 0 > /sys/kernel/mm/ksm/run'
ExecStart=/bin/bash -c 'echo 1 > /proc/sys/vm/oom_kill_allocating_task'
ExecStart=/bin/bash -c 'echo 1 > /proc/sys/kernel/sched_autogroup_enabled'

[Install]
WantedBy=multi-user.target
EOL

systemctl enable performance-tuning.service

# CREATE MAINTENANCE SCRIPT
show_progress "CREATING SYSTEM MAINTENANCE SCRIPT"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Creating maintenance script..."
cat > /usr/local/bin/kudu-maintenance << 'EOL'
#!/bin/bash
echo "Running Kudu system maintenance..."
sudo pacman -Sc --noconfirm
sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "No orphans to remove"
sudo updatedb
sudo mandb
echo "Maintenance complete!"
EOL
chmod +x /usr/local/bin/kudu-maintenance

# FINAL SYSTEM OPTIMIZATIONS
show_progress "APPLYING FINAL SYSTEM OPTIMIZATIONS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Final optimizations..."

# Disable unnecessary services
systemctl disable lvm2-monitor.service 2>/dev/null || true
systemctl disable ModemManager.service 2>/dev/null || true

# Set swappiness for better performance
echo 'vm.swappiness=10' >> /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf

# REVERT SUDO CONFIGURATION
show_progress "REVERTING SUDO CONFIGURATION"
sed -i "/^$USERNAME ALL=(ALL) NOPASSWD: ALL$/d" /etc/sudoers

# FINAL REPORT
progress_bar $TOTAL_STEPS $TOTAL_STEPS "Setup complete!"

display_logo
echo -e "${YELLOW}Preparing final report...${RESET}"
sleep 3

echo ""
echo -e "${GREEN}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${RESET}"
echo -e "${GREEN}┃              ${WHITE}KUDU ULTRA CLEAN ARCH LINUX SETUP COMPLETE${GREEN}              ┃${RESET}"
echo -e "${GREEN}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${RESET}"
echo ""
echo -e "${CYAN}YOUR ULTRA CLEAN & EFFICIENT ARCH SYSTEM INCLUDES:${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ULTRA DARK NORDIC + FLAT REMIX THEME${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}CUSTOM JELLYFISH WALLPAPER${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ZRAM MEMORY COMPRESSION${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}SSD OPTIMIZATIONS (FSTRIM, NOATIME)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}PERFORMANCE CPU GOVERNOR${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}PRELOAD FOR FASTER APP LOADING${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}OPTIMIZED PACMAN (15 PARALLEL DOWNLOADS)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}MINIMAL GNOME WITH ESSENTIAL EXTENSIONS${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ULTRA DARK TRANSPARENT TERMINAL${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ZSH WITH POWERLEVEL10K (PERFORMANCE MODE)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ENHANCED SYSTEM ALIASES${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}AUTOMATIC SYSTEM MAINTENANCE SCRIPT${RESET}"
echo ""
echo -e "${BLUE}PERFORMANCE FEATURES:${RESET}"
echo -e "${WHITE}• ${CYAN}Disabled animations for speed${RESET}"
echo -e "${WHITE}• ${CYAN}Optimized memory management${RESET}"
echo -e "${WHITE}• ${CYAN}Faster mirror selection${RESET}"
echo -e "${WHITE}• ${CYAN}SSD-optimized filesystem settings${RESET}"
echo -e "${WHITE}• ${CYAN}Performance-focused extensions only${RESET}"
echo ""
echo -e "${YELLOW}MAINTENANCE COMMANDS:${RESET}"
echo -e "${WHITE}• ${GREEN}kudu-maintenance${RESET} - Run system cleanup"
echo -e "${WHITE}• ${GREEN}fastmirror${RESET} - Update to fastest mirrors"
echo -e "${WHITE}• ${GREEN}sysinfo${RESET} - Show system information"
echo ""
echo -e "${YELLOW}PLEASE REBOOT TO COMPLETE SETUP:${RESET}"
echo -e "${YELLOW}   $ sudo reboot${RESET}"
echo ""
echo -e "${BLUE}SETUP LOG: $LOG_FILE${RESET}"
