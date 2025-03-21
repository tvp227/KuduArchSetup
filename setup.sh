#!/bin/bash

# KUDU SETUP SCRIPT - MINIMALIST VERSION

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

# INSTALL MINIMAL GNOME
show_progress "INSTALLING MINIMAL GNOME DESKTOP"
pacman -S --noconfirm gnome-shell gdm gnome-terminal gnome-control-center gnome-tweaks gnome-keyring nautilus eog networkmanager xdg-user-dirs

# ENABLE GDM AND NETWORKMANAGER
systemctl enable gdm.service
systemctl enable NetworkManager.service

# INSTALL CORE UTILITIES
show_progress "INSTALLING CORE UTILITIES"
pacman -S --noconfirm zsh zsh-completions flatpak

# INSTALL SELECTED APPLICATIONS
show_progress "INSTALLING SELECTED APPLICATIONS"
pacman -S --noconfirm chromium discord gnome-boxes

# SETUP FLATPAK
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# INSTALL YAY AUR HELPER
show_progress "INSTALLING YAY AUR HELPER"
cd /tmp
sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $USERNAME makepkg -si --noconfirm

# INSTALL AUR PACKAGES
show_progress "INSTALLING AUR PACKAGES"
# Changed teams to teams-for-linux
sudo -u $USERNAME yay -S --noconfirm visual-studio-code-bin postman-bin teams-for-linux spotify

# INSTALL CHROMIUM EXTENSIONS
show_progress "INSTALLING UBLOCK ORIGIN FOR CHROMIUM"
# Create the extension directory
sudo -u $USERNAME mkdir -p /home/$USERNAME/.config/chromium/Default/Extensions/cjpalhdlnbpafiamejdnhcphjbkeiagm

# Download and install uBlock Origin
cd /tmp
sudo -u $USERNAME wget -q https://github.com/gorhill/uBlock/releases/download/1.55.0/uBlock0_1.55.0.chromium.zip
sudo -u $USERNAME unzip -q uBlock0_1.55.0.chromium.zip -d /home/$USERNAME/.config/chromium/Default/Extensions/cjpalhdlnbpafiamejdnhcphjbkeiagm

# Create a preferences file to enable the extension
sudo -u $USERNAME mkdir -p /home/$USERNAME/.config/chromium/Default
cat > /home/$USERNAME/.config/chromium/Default/Preferences << EOF
{
  "extensions": {
    "settings": {
      "cjpalhdlnbpafiamejdnhcphjbkeiagm": {
        "location": 1,
        "manifest": {
          "name": "uBlock Origin",
          "version": "1.55.0"
        },
        "path": "cjpalhdlnbpafiamejdnhcphjbkeiagm",
        "state": 1,
        "granted_permissions": {
          "api": ["storage", "tabs"],
          "explicit_host": ["*://*/*"]
        }
      }
    }
  }
}
EOF
chown $USERNAME:$USERNAME /home/$USERNAME/.config/chromium/Default/Preferences

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
show_progress "INSTALLING GNOME BROWSER CONNECTOR"
pacman -S --noconfirm gnome-browser-connector 

# INSTALL PAPIRUS ICON THEME (WORKS WELL WITH DRACULA)
show_progress "INSTALLING PAPIRUS ICON THEME WITH DRACULA COLORS"
pacman -S --noconfirm papirus-icon-theme

# INSTALL DRACULA THEME
show_progress "INSTALLING DRACULA THEME"

# CREATE THEMES DIRECTORY
sudo -u $USERNAME mkdir -p /home/$USERNAME/.themes
sudo -u $USERNAME mkdir -p /home/$USERNAME/.icons

# INSTALL DRACULA GTK THEME
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/gtk.git dracula-theme
sudo -u $USERNAME cp -r dracula-theme /home/$USERNAME/.themes/Dracula

# INSTALL DRACULA PAPIRUS FOLDER COLORS
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/papirus-folders.git
cd papirus-folders
sudo -u $USERNAME ./install.sh

# APPLY THEMES AND SET DARK MODE
show_progress "APPLYING THEMES AND SETTING DARK MODE"
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
# Enable dark mode
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# SET CHROMIUM AS DEFAULT BROWSER
show_progress "SETTING CHROMIUM AS DEFAULT BROWSER"
sudo -u $USERNAME xdg-settings set default-web-browser chromium.desktop
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.default-applications.browser exec 'chromium'

# CONFIGURE GNOME TWEAKS - RESTORE MINIMIZE/MAXIMIZE BUTTONS
show_progress "CONFIGURING GNOME TWEAKS"
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# DOWNLOAD AND SET WALLPAPER
show_progress "SETTING WALLPAPER"
wget -q "https://cdn.wallpapersafari.com/64/65/QhkeST.jpg" -O /home/$USERNAME/wallpaper.jpg
chown $USERNAME:$USERNAME /home/$USERNAME/wallpaper.jpg
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.background picture-uri "file:///home/$USERNAME/wallpaper.jpg"
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USERNAME/wallpaper.jpg"

# SET GNOME TERMINAL TO USE DRACULA COLORS
profile=$(sudo -u $USERNAME dbus-launch gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#282A36'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#F8F8F2'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['#262626', '#E356A7', '#42E66C', '#E4F34A', '#9B6BDF', '#E64747', '#75D7EC', '#EFA554', '#7A7A7A', '#FF79C6', '#50FA7B', '#F1FA8C', '#BD93F9', '#FF5555', '#8BE9FD', '#FFB86C']"

# OPTIMIZE PACMAN
show_progress "OPTIMIZING PACMAN"
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# FINAL REPORT
show_progress "SETUP COMPLETED SUCCESSFULLY!"

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
echo -e "${WHITE}✅ ${MAGENTA}EXTENSION MANAGER FROM AUR${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}ZSH WITH POWERLEVEL10K THEME${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}PACMAN ALIASES FOR EASIER SYSTEM MANAGEMENT${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}CHROMIUM BROWSER (WITH UBLOCK ORIGIN)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}TEAMS FOR LINUX${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}VISUAL STUDIO CODE WITH EXTENSIONS (PYTHON, GO, GITLENS, AZURE FUNCTIONS)${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}POSTMAN${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}SPOTIFY${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}DISCORD${RESET}"
echo -e "${WHITE}✅ ${MAGENTA}GNOME BOXES FOR VIRTUALIZATION${RESET}"
echo ""
echo -e "${YELLOW}🚀 PLEASE REBOOT YOUR SYSTEM TO COMPLETE THE SETUP:${RESET}"
echo -e "${YELLOW}   $ sudo reboot${RESET}"
echo ""
echo -e "${BLUE}SETUP LOG HAS BEEN SAVED TO: $LOG_FILE${RESET}"
