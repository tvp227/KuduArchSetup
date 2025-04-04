#!/bin/bash

# KUDU SETUP SCRIPT 
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
    echo -e "${CYAN}║                          ${WHITE}KUDU ARCH SETUP${CYAN}                           ║${RESET}"
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

show_progress "STARTING KUDU SETUP WITH VANILLA GNOME CONFIGURATION"

# UPDATE SYSTEM
show_progress "UPDATING SYSTEM"
pacman -Syu --noconfirm

# INSTALL MINIMAL BASE PACKAGES
show_progress "INSTALLING MINIMAL BASE PACKAGES"
pacman -S --noconfirm base-devel git sudo wget curl

# SETUP TOTAL STEPS FOR PROGRESS BAR
TOTAL_STEPS=25
CURRENT_STEP=0

# INSTALL MINIMAL GNOME
show_progress "INSTALLING MINIMAL GNOME DESKTOP"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing minimal GNOME..."
pacman -S --noconfirm gnome-shell gdm gnome-terminal gnome-control-center gnome-tweaks gnome-keyring nautilus networkmanager xdg-user-dirs

# ENABLE GDM AND NETWORKMANAGER
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Enabling services..."
systemctl enable gdm.service
systemctl enable NetworkManager.service

# INSTALL CORE UTILITIES
show_progress "INSTALLING CORE UTILITIES"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing core utilities..."
pacman -S --noconfirm zsh zsh-completions flatpak

# INSTALL SELECTED APPLICATIONS
show_progress "INSTALLING SELECTED APPLICATIONS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing applications..."
pacman -S --noconfirm chromium discord gnome-boxes

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
# Changed teams to teams-for-linux
sudo -u $USERNAME yay -S --noconfirm visual-studio-code-bin postman-bin teams-for-linux spotify

# INSTALL EXTENSION MANAGER
show_progress "INSTALLING EXTENSION MANAGER FROM AUR"
cd /tmp
sudo -u $USERNAME git clone https://aur.archlinux.org/extension-manager.git
cd extension-manager
sudo -u $USERNAME makepkg -si --noconfirm

# INSTALL VS CODE EXTENSIONS
show_progress "INSTALLING VS CODE EXTENSIONS"
sudo -u $USERNAME code --install-extension ms-python.python --force
sudo -u $USERNAME code --install-extension golang.go --force
sudo -u $USERNAME code --install-extension eamodio.gitlens --force
sudo -u $USERNAME code --install-extension ms-azuretools.vscode-azurefunctions --force

# INSTALL OH MY ZSH
show_progress "SETTING UP ZSH WITH POWERLEVEL10K THEME"
sudo -u $USERNAME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# INSTALL POWERLEVEL10K THEME
sudo -u $USERNAME git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USERNAME/.oh-my-zsh/custom/themes/powerlevel10k

# CONFIGURE ZSH WITH ALIASES
cat > /home/$USERNAME/.zshrc << 'EOL'
# ENABLE POWERLEVEL10K INSTANT PROMPT
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH TO YOUR OH-MY-ZSH INSTALLATION
export ZSH="$HOME/.oh-my-zsh"

# SET THEME
ZSH_THEME="powerlevel10k/powerlevel10k"

# PLUGINS
plugins=(git sudo history)

source $ZSH/oh-my-zsh.sh

# PACMAN ALIASES
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -Rs"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias cleanup="sudo pacman -Rns $(pacman -Qtdq)"
alias mirror="sudo reflector --country 'United Kingdom' --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"

# P10K CONFIGURATION
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
chsh -s /bin/zsh $USERNAME

# INSTALL GNOME EXTENSION MANAGER AND EXTENSIONS
show_progress "INSTALLING GNOME BROWSER CONNECTOR AND EXTENSIONS"
pacman -S --noconfirm gnome-browser-connector

# Install GNOME Extensions
show_progress "INSTALLING GNOME SHELL EXTENSIONS"
# Create extensions directory
sudo -u $USERNAME mkdir -p /home/$USERNAME/.local/share/gnome-shell/extensions

# Install Blur My Shell
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Blur My Shell extension..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/aunetx/blur-my-shell.git
cd blur-my-shell
sudo -u $USERNAME make install

# Install Impatience (faster animations)
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Impatience extension..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/timbertson/gnome-shell-impatience.git
cd gnome-shell-impatience
sudo -u $USERNAME cp -r gnome-shell-impatience@gfxmonk.net /home/$USERNAME/.local/share/gnome-shell/extensions/

# Install Caffeine
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Caffeine extension..."
cd /tmp
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-caffeine

# Install Dash to Dock
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Dash to Dock extension..."
cd /tmp
# Try AUR package first as it's more reliable
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-dash-to-dock
# As fallback, also try from source to ensure it's available
sudo -u $USERNAME git clone https://github.com/micheleg/dash-to-dock.git
cd dash-to-dock
# Install build dependencies
pacman -S --needed --noconfirm gettext sassc meson
sudo -u $USERNAME meson -Dprefix=/home/$USERNAME/.local build
sudo -u $USERNAME ninja -C build install

# Install App Indicator Support
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing App Indicator extension..."
cd /tmp
sudo -u $USERNAME yay -S --noconfirm gnome-shell-extension-appindicator

# Install Vitals
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Vitals extension..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/corecoding/Vitals.git
sudo -u $USERNAME cp -r Vitals/Vitals@CoreCoding.com /home/$USERNAME/.local/share/gnome-shell/extensions/

# Install Compiz Effect
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Compiz magic lamp effect..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/hermes83/compiz-alike-magic-lamp-effect.git
sudo -u $USERNAME cp -r compiz-alike-magic-lamp-effect/compiz-alike-magic-lamp-effect@hermes83.github.com /home/$USERNAME/.local/share/gnome-shell/extensions/

# Enable extensions
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Enabling extensions..."
sudo -u $USERNAME dbus-launch gnome-extensions enable blur-my-shell@aunetx
sudo -u $USERNAME dbus-launch gnome-extensions enable gnome-shell-impatience@gfxmonk.net
sudo -u $USERNAME dbus-launch gnome-extensions enable caffeine@patapon.info
sudo -u $USERNAME dbus-launch gnome-extensions enable dash-to-dock@micxgx.gmail.com
sudo -u $USERNAME dbus-launch gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
sudo -u $USERNAME dbus-launch gnome-extensions enable Vitals@CoreCoding.com
sudo -u $USERNAME dbus-launch gnome-extensions enable compiz-alike-magic-lamp-effect@hermes83.github.com

# INSTALL PAPIRUS ICON THEME (WORKS WELL WITH DRACULA)
show_progress "INSTALLING PAPIRUS ICON THEME WITH DRACULA COLORS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Papirus icon theme..."
pacman -S --noconfirm papirus-icon-theme

# INSTALL DRACULA THEME
show_progress "INSTALLING DRACULA THEME"

# CREATE THEMES DIRECTORY
sudo -u $USERNAME mkdir -p /home/$USERNAME/.themes
sudo -u $USERNAME mkdir -p /home/$USERNAME/.icons

# INSTALL DRACULA GTK THEME
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Dracula GTK theme..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/gtk.git dracula-theme
sudo -u $USERNAME cp -r dracula-theme /home/$USERNAME/.themes/Dracula

# INSTALL DRACULA PAPIRUS FOLDER COLORS
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Installing Dracula folder colors..."
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/papirus-folders.git
cd papirus-folders
sudo -u $USERNAME ./install.sh

# APPLY THEMES AND SET DARK MODE
show_progress "APPLYING THEMES AND SETTING DARK MODE"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Applying themes and dark mode..."
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
# Enable dark mode
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# SET CHROMIUM AS DEFAULT BROWSER
show_progress "SETTING CHROMIUM AS DEFAULT BROWSER"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting Chromium as default browser..."
sudo -u $USERNAME xdg-settings set default-web-browser chromium.desktop
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.default-applications.browser exec 'chromium'

# CONFIGURE GNOME TWEAKS - RESTORE MINIMIZE/MAXIMIZE BUTTONS
show_progress "CONFIGURING GNOME TWEAKS"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Configuring window buttons..."
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# DOWNLOAD AND SET WALLPAPER
show_progress "SETTING WALLPAPER"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Setting wallpaper..."
wget -q "https://cdn.wallpapersafari.com/64/65/QhkeST.jpg" -O /home/$USERNAME/wallpaper.jpg
chown $USERNAME:$USERNAME /home/$USERNAME/wallpaper.jpg
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.background picture-uri "file:///home/$USERNAME/wallpaper.jpg"
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USERNAME/wallpaper.jpg"

# SET GNOME TERMINAL TO USE DRACULA COLORS
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Configuring terminal colors..."
profile=$(sudo -u $USERNAME dbus-launch gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#282A36'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#F8F8F2'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['#262626', '#E356A7', '#42E66C', '#E4F34A', '#9B6BDF', '#E64747', '#75D7EC', '#EFA554', '#7A7A7A', '#FF79C6', '#50FA7B', '#F1FA8C', '#BD93F9', '#FF5555', '#8BE9FD', '#FFB86C']"

# OPTIMIZE PACMAN
show_progress "OPTIMIZING PACMAN"
progress_bar $((++CURRENT_STEP)) $TOTAL_STEPS "Optimizing Pacman..."
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# Display Pacman Aliases Info
show_progress "PACMAN ALIASES CONFIGURED"
echo -e "${CYAN}The following Pacman aliases have been configured:${RESET}"
echo -e "${WHITE}• ${GREEN}update${RESET} - Update system packages"
echo -e "${WHITE}• ${GREEN}install${RESET} - Install packages"
echo -e "${WHITE}• ${GREEN}search${RESET} - Search for packages"
echo -e "${WHITE}• ${GREEN}remove${RESET} - Remove packages"
echo -e "${WHITE}• ${GREEN}cleanup${RESET} - Remove orphaned packages"
echo -e "${WHITE}• ${GREEN}mirror${RESET} - Update mirror list"
echo ""

# FINAL REPORT
show_progress "SETUP COMPLETED SUCCESSFULLY!"
progress_bar $TOTAL_STEPS $TOTAL_STEPS "Setup complete!"

# REVERT SUDO CONFIGURATION
show_progress "REVERTING SUDO CONFIGURATION"
sed -i "/^$USERNAME ALL=(ALL) NOPASSWD: ALL$/d" /etc/sudoers

# DISPLAY LOGO AT END AND WAIT
display_logo
echo -e "${YELLOW}Preparing final report...${RESET}"
sleep 7

# NOW SHOW THE FINAL REPORT
echo ""
echo -e "${GREEN}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${RESET}"
echo -e "${GREEN}┃                     ${WHITE}KUDU ARCH LINUX SETUP COMPLETE${GREEN}                     ┃${RESET}"
echo -e "${GREEN}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${RESET}"
echo ""
echo -e "${CYAN}YOUR MINIMAL KUDU ARCH LINUX SYSTEM HAS BEEN CONFIGURED WITH:${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}MINIMAL GNOME DESKTOP ENVIRONMENT${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}DARK MODE ENABLED${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}DRACULA THEME WITH PAPIRUS ICONS${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}CUSTOM WALLPAPER${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}GNOME TWEAKS WITH RESTORED WINDOW BUTTONS${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}GNOME EXTENSIONS (BLUR MY SHELL, IMPATIENCE, CAFFEINE, DASH TO DOCK, VITALS, APP INDICATOR, COMPIZ EFFECT)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ZSH WITH POWERLEVEL10K THEME${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}PACMAN ALIASES FOR EASIER SYSTEM MANAGEMENT${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}CHROMIUM BROWSER (DEFAULT)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}TEAMS FOR LINUX${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}VISUAL STUDIO CODE WITH EXTENSIONS (PYTHON, GO, GITLENS, AZURE FUNCTIONS)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}POSTMAN${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}SPOTIFY${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}DISCORD${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}GNOME BOXES FOR VIRTUALIZATION${RESET}"
echo ""
echo -e "${YELLOW} PLEASE REBOOT YOUR SYSTEM TO COMPLETE THE SETUP:${RESET}"
echo -e "${YELLOW}   $ sudo reboot${RESET}"
echo ""
echo -e "${BLUE}SETUP LOG HAS BEEN SAVED TO: $LOG_FILE${RESET}"
