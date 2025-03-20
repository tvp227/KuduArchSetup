#!/bin/bash

# KUDU SETUP SCRIPT - STREAMLINED VERSION
# ======================================
# CORE GNOME SETUP WITH DRACULA THEME AND ESSENTIAL TOOLS

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

# DISPLAY LOGO AT START
display_logo

# SETUP LOGGING
LOG_FILE="/var/log/kudu-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# GET USERNAME
USERNAME=$(logname || whoami)
if [ "$USERNAME" = "root" ]; then
  USERNAME=$(find /home -mindepth 1 -maxdepth 1 -type d | head -n 1 | awk -F'/' '{print $NF}')
fi

show_progress "STARTING KUDU SETUP WITH VANILLA GNOME CONFIGURATION"

# UPDATE SYSTEM AND INSTALL BASIC PACKAGES
show_progress "UPDATING SYSTEM AND INSTALLING BASE PACKAGES"
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel git sudo wget curl

# INSTALL GNOME DESKTOP ENVIRONMENT
show_progress "INSTALLING GNOME DESKTOP ENVIRONMENT"
pacman -S --noconfirm gnome gnome-extra gdm networkmanager gnome-boxes

# ENABLE GDM AND NETWORKMANAGER
systemctl enable gdm.service
systemctl enable NetworkManager.service

# INSTALL UTILITIES AND USER APPLICATIONS
show_progress "INSTALLING UTILITIES AND APPLICATIONS"
pacman -S --noconfirm python python-pip zsh zsh-completions flatpak chromium
pacman -S --noconfirm libreoffice-fresh discord gnome-boxes 

# INSTALL MULTIMEDIA APPLICATIONS
show_progress "INSTALLING MULTIMEDIA APPLICATIONS"
pacman -S --noconfirm cheese vlc obs-studio handbrake ffmpeg shotwell

# SETUP FLATPAK
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# INSTALL OH MY ZSH
sudo -u $USERNAME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# INSTALL POWERLEVEL10K THEME
sudo -u $USERNAME git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USERNAME/.oh-my-zsh/custom/themes/powerlevel10k

# CONFIGURE ZSH
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

# USEFUL ALIASES
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias search="pacman -Ss"
alias remove="sudo pacman -Rs"

# P10K CONFIGURATION
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
chsh -s /bin/zsh $USERNAME

# SETUP GNOME EXTENSIONS
show_progress "SETTING UP GNOME EXTENSIONS"
pacman -S --noconfirm gnome-shell-extensions gnome-tweaks

# INSTALL YAY AUR HELPER
show_progress "INSTALLING YAY AUR HELPER"
cd /tmp
sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $USERNAME makepkg -si --noconfirm

# INSTALL GNOME EXTENSION TOOLS
sudo -u $USERNAME yay -S --noconfirm gnome-browser-connector gnome-shell-extension-installer

# INSTALL EXTENSIONS
sudo -u $USERNAME gnome-shell-extension-installer 307 --yes # DASH TO DOCK
sudo -u $USERNAME gnome-shell-extension-installer 3193 --yes # BLUR MY SHELL
sudo -u $USERNAME gnome-shell-extension-installer 1460 --yes # VITALS
sudo -u $USERNAME gnome-shell-extension-installer 517 --yes # CAFFEINE
sudo -u $USERNAME gnome-shell-extension-installer 277 --yes # IMPATIENCE
sudo -u $USERNAME gnome-shell-extension-installer 615 --yes # APPINDICATOR SUPPORT

# ENABLE THE EXTENSIONS
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell enabled-extensions "['dash-to-dock@micxgx.gmail.com', 'blur-my-shell@aunetx', 'Vitals@CoreCoding.com', 'caffeine@patapon.info', 'impatience@gfxmonk.net', 'appindicatorsupport@rgcjonas.gmail.com']"

# INSTALL DRACULA THEME
show_progress "INSTALLING DRACULA THEME"

# CREATE THEMES DIRECTORY
sudo -u $USERNAME mkdir -p /home/$USERNAME/.themes
sudo -u $USERNAME mkdir -p /home/$USERNAME/.icons

# INSTALL DRACULA GTK THEME
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/gtk.git dracula-theme
sudo -u $USERNAME cp -r dracula-theme /home/$USERNAME/.themes/Dracula

# INSTALL TELA ICON THEME
cd /tmp
sudo -u $USERNAME git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
sudo -u $USERNAME ./install.sh -a -d

# APPLY THEMES
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Tela-purple'

# SET GNOME TERMINAL TO USE DRACULA COLORS
profile=$(sudo -u $USERNAME dbus-launch gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#282A36'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#F8F8F2'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['#262626', '#E356A7', '#42E66C', '#E4F34A', '#9B6BDF', '#E64747', '#75D7EC', '#EFA554', '#7A7A7A', '#FF79C6', '#50FA7B', '#F1FA8C', '#BD93F9', '#FF5555', '#8BE9FD', '#FFB86C']"

# INSTALL AUR PACKAGES
show_progress "INSTALLING AUR PACKAGES"
pacman -S --noconfirm gconf
sudo -u $USERNAME yay -S --noconfirm teams visual-studio-code-bin postman-bin spotify

# OPTIMIZE PACMAN
show_progress "OPTIMIZING PACMAN"
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# FINAL REPORT
show_progress "SETUP COMPLETED SUCCESSFULLY!"

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
echo -e "${CYAN}YOUR KUDU ARCH LINUX SYSTEM HAS BEEN CONFIGURED WITH:${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}VANILLA GNOME DESKTOP ENVIRONMENT${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}DRACULA THEME APPLIED SYSTEM-WIDE${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}FLATPAK SUPPORT${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}CHROMIUM BROWSER${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ZSH WITH POWERLEVEL10K THEME${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}GNOME EXTENSIONS: DASH TO DOCK, BLUR MY SHELL, VITALS, CAFFEINE, IMPATIENCE, APPINDICATOR${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}MICROSOFT TEAMS${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}VISUAL STUDIO CODE${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}POSTMAN${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}SPOTIFY${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}DISCORD${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}LIBREOFFICE${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}GNOME BOXES${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}MULTIMEDIA APPS: CHEESE, VLC, OBS STUDIO, HANDBRAKE, SHOTWELL${RESET}"
echo ""
echo -e "${YELLOW}🚀 PLEASE REBOOT YOUR SYSTEM TO COMPLETE THE SETUP:${RESET}"
echo -e "${YELLOW}   $ sudo reboot${RESET}"
echo ""
echo -e "${BLUE}SETUP LOG HAS BEEN SAVED TO: $LOG_FILE${RESET}"
