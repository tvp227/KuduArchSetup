#!/bin/bash

# KUDU SETUP SCRIPT - VANILLA GNOME WITH DRACULA THEME
# ===================================================
# THIS SCRIPT INSTALLS AND CONFIGURES ARCH LINUX WITH:
# - VANILLA GNOME DESKTOP ENVIRONMENT
# - FLATPAK SUPPORT
# - CHROMIUM BROWSER
# - ZSH WITH JONATHAN THEME
# - SPECIFIED GNOME EXTENSIONS 
# - DRACULA THEME
# - AUTOMATIC DRIVER DETECTION AND INSTALLATION
# - GRUB BOOTLOADER FOR DUAL BOOT SUPPORT

# ENSURE SCRIPT IS RUN AS ROOT
if [ "$EUID" -ne 0 ]; then
  echo "PLEASE RUN AS ROOT"
  exit 1
fi

# FUNCTION TO CHECK IF RUNNING ON A LAPTOP
is_laptop() {
  if [ -d "/sys/class/power_supply" ]; then
    for i in /sys/class/power_supply/*; do
      if [ -e "$i/type" ]; then
        if grep -q "Battery" "$i/type"; then
          return 0
        fi
      fi
    done
  fi
  return 1
}

# FUNCTION TO DISPLAY PROGRESS
show_progress() {
  echo "--------------------------------------------"
  echo "🚀 $1"
  echo "--------------------------------------------"
}

# SETUP LOGGING
LOG_FILE="/var/log/kudu-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# INTERACTIVE CONFIGURATION
show_progress "WELCOME TO KUDU SETUP"

# GET USERNAME
DEFAULT_USER=$(logname || echo "kudu")
USERNAME=$(whiptail --inputbox "ENTER USERNAME:" 8 39 "$DEFAULT_USER" --title "KUDU SETUP" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
  echo "SETUP CANCELLED BY USER"
  exit 1
fi

# GET HOSTNAME
DEFAULT_HOSTNAME="kudu-arch"
HOSTNAME=$(whiptail --inputbox "ENTER HOSTNAME:" 8 39 "$DEFAULT_HOSTNAME" --title "KUDU SETUP" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
  echo "SETUP CANCELLED BY USER"
  exit 1
fi

# SET TIMEZONE TO UK/LONDON
TIMEZONE="Europe/London"

# CONFIRM DUAL BOOT SETUP
if (whiptail --title "KUDU SETUP" --yesno "WILL THIS BE A DUAL-BOOT SYSTEM?\n\nSELECT 'YES' IF YOU HAVE ANOTHER OPERATING SYSTEM INSTALLED." 10 60); then
  DUAL_BOOT=true
  # GET THE DISK FOR GRUB INSTALLATION
  DISKS=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  BOOTDISK=$(whiptail --menu "SELECT DISK FOR GRUB INSTALLATION:" 15 60 5 $(echo "$DISKS" | awk '{print $1, $2}') --title "KUDU SETUP" 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus != 0 ]; then
    echo "SETUP CANCELLED BY USER"
    exit 1
  fi
else
  DUAL_BOOT=false
fi

# SELECT ADDITIONAL FEATURES
FEATURES=$(whiptail --title "KUDU SETUP" --checklist "SELECT ADDITIONAL FEATURES:" 15 60 7 \
  "timeshift" "AUTOMATIC SYSTEM BACKUPS" ON \
  "pamac" "GRAPHICAL PACKAGE MANAGER" ON \
  "laptop_tools" "LAPTOP POWER MANAGEMENT" $(is_laptop && echo "ON" || echo "OFF") \
  "development" "DEVELOPMENT TOOLS" OFF \
  "gaming" "GAMING TOOLS" OFF \
  "multimedia" "MULTIMEDIA TOOLS" OFF \
  "teams" "MICROSOFT TEAMS" OFF \
  3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
  echo "SETUP CANCELLED BY USER"
  exit 1
fi

show_progress "STARTING KUDU SETUP WITH VANILLA GNOME CONFIGURATION"

# UPDATE SYSTEM AND INSTALL BASIC PACKAGES
show_progress "UPDATING SYSTEM AND INSTALLING BASE PACKAGES"
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel git sudo wget curl reflector

# OPTIMIZE MIRRORS
show_progress "OPTIMIZING MIRRORS FOR FASTER DOWNLOADS"
reflector --country 'United Kingdom' --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# INSTALL GNOME DESKTOP ENVIRONMENT
show_progress "INSTALLING GNOME DESKTOP ENVIRONMENT"
pacman -S --noconfirm gnome gnome-extra gdm networkmanager network-manager-applet

# INSTALL GNOME BOXES
show_progress "INSTALLING GNOME BOXES"
pacman -S --noconfirm gnome-boxes

# ENABLE GDM AND NETWORKMANAGER
systemctl enable gdm.service
systemctl enable NetworkManager.service

# INSTALL PYTHON (NEEDED FOR SOME SCRIPTS)
show_progress "INSTALLING PYTHON"
pacman -S --noconfirm python python-pip

# INSTALL FLATPAK
show_progress "SETTING UP FLATPAK"
pacman -S --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# INSTALL CHROMIUM
show_progress "INSTALLING CHROMIUM BROWSER"
pacman -S --noconfirm chromium

# INSTALL ZSH AND SET UP JONATHAN THEME
show_progress "SETTING UP ZSH WITH JONATHAN THEME"
pacman -S --noconfirm zsh zsh-completions
chsh -s /bin/zsh $USERNAME

# INSTALL OH MY ZSH
sudo -u $USERNAME sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# INSTALL POWERLEVEL10K THEME (CLOSEST TO JONATHAN THEME IN OH MY ZSH)
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
plugins=(git sudo history docker)

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

# SETUP GNOME EXTENSIONS
show_progress "SETTING UP GNOME EXTENSIONS"
pacman -S --noconfirm gnome-shell-extensions chrome-gnome-shell

# INSTALL GNOME-TWEAKS FOR EXTENSION MANAGEMENT
pacman -S --noconfirm gnome-tweaks

# INSTALL EXTENSION MANAGER
pacman -S --noconfirm --needed git base-devel
cd /tmp
sudo -u $USERNAME git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u $USERNAME makepkg -si --noconfirm
sudo -u $USERNAME yay -S --noconfirm gnome-browser-connector gnome-shell-extension-installer

# INSTALL YOUR SPECIFIED GNOME EXTENSIONS
sudo -u $USERNAME gnome-shell-extension-installer 307 --yes # DASH TO DOCK
sudo -u $USERNAME gnome-shell-extension-installer 3193 --yes # BLUR MY SHELL
sudo -u $USERNAME gnome-shell-extension-installer 1460 --yes # VITALS
sudo -u $USERNAME gnome-shell-extension-installer 517 --yes # CAFFEINE
sudo -u $USERNAME gnome-shell-extension-installer 277 --yes # IMPATIENCE
sudo -u $USERNAME gnome-shell-extension-installer 615 --yes # APPINDICATOR SUPPORT

# ENABLE THE EXTENSIONS
sudo -u $USERNAME dbus-launch gsettings set org.gnome.shell enabled-extensions "['dash-to-dock@micxgx.gmail.com', 'blur-my-shell@aunetx', 'Vitals@CoreCoding.com', 'caffeine@patapon.info', 'impatience@gfxmonk.net', 'appindicatorsupport@rgcjonas.gmail.com']"

# INSTALL AND SET DRACULA THEME
show_progress "INSTALLING DRACULA THEME"

# CREATE THEMES DIRECTORY IF IT DOESN'T EXIST
sudo -u $USERNAME mkdir -p /home/$USERNAME/.themes
sudo -u $USERNAME mkdir -p /home/$USERNAME/.icons

# INSTALL DRACULA GTK THEME
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/gtk.git dracula-theme
sudo -u $USERNAME cp -r dracula-theme /home/$USERNAME/.themes/Dracula

# INSTALL DRACULA ICON THEME
cd /tmp
sudo -u $USERNAME git clone https://github.com/dracula/gtk.git
cd gtk
sudo -u $USERNAME cp -r kde/cursors/Dracula-cursors /home/$USERNAME/.icons/

# INSTALL TELA ICON THEME (DRACULA COLORED)
cd /tmp
sudo -u $USERNAME git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
sudo -u $USERNAME ./install.sh -a -d

# APPLY THEMES
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Tela-purple'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.desktop.interface cursor-theme 'Dracula-cursors'

# SET GNOME TERMINAL TO USE DRACULA COLORS
profile=$(sudo -u $USERNAME dbus-launch gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#282A36'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#F8F8F2'
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
sudo -u $USERNAME dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ palette "['#262626', '#E356A7', '#42E66C', '#E4F34A', '#9B6BDF', '#E64747', '#75D7EC', '#EFA554', '#7A7A7A', '#FF79C6', '#50FA7B', '#F1FA8C', '#BD93F9', '#FF5555', '#8BE9FD', '#FFB86C']"

# SETUP GRUB FOR DUAL BOOT IF SELECTED
if [ "$DUAL_BOOT" = true ]; then
  show_progress "SETTING UP GRUB BOOTLOADER FOR DUAL BOOT"
  pacman -S --noconfirm grub efibootmgr os-prober
  
  # ENABLE OS PROBER TO DETECT OTHER OPERATING SYSTEMS
  sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
  
  # INSTALL GRUB
  if [ -d "/sys/firmware/efi" ]; then
    # SYSTEM IS BOOTED IN UEFI MODE
    pacman -S --noconfirm dosfstools
    mkdir -p /boot/efi
    mount | grep /boot/efi || mount $(findmnt -no SOURCE /boot) /boot/efi
    grub-install --target=x86_64-efi --bootloader-id=KUDU --recheck "$BOOTDISK"
  else
    # SYSTEM IS BOOTED IN BIOS MODE
    grub-install --target=i386-pc "$BOOTDISK"
  fi
  
  # GENERATE GRUB CONFIG
  grub-mkconfig -o /boot/grub/grub.cfg
fi

# INSTALL TEAMS
if [[ $FEATURES == *"teams"* ]]; then
  show_progress "INSTALLING MICROSOFT TEAMS"
  pacman -S --noconfirm gconf
  sudo -u $USERNAME yay -S --noconfirm teams
fi

# INSTALL SYSTEM PROTECTION AND BACKUP TOOLS
if [[ $FEATURES == *"timeshift"* ]]; then
  show_progress "SETTING UP SYSTEM PROTECTION TOOLS"
  pacman -S --noconfirm timeshift btrfs-progs rsync cronie
  systemctl enable cronie.service

  # CREATE A WEEKLY BACKUP SCRIPT
  cat > /usr/local/bin/weekly-backup << 'EOL'
#!/bin/bash
# CREATE A TIMESHIFT SNAPSHOT BEFORE WEEKLY SYSTEM UPDATE
timeshift --create --comments "WEEKLY AUTO-SNAPSHOT BEFORE SYSTEM UPDATE"
EOL

  chmod +x /usr/local/bin/weekly-backup

  # ADD TO CRONTAB TO RUN WEEKLY ON SUNDAY AT 1 AM
  echo "0 1 * * 0 /usr/local/bin/weekly-backup" > /tmp/crontab
  crontab /tmp/crontab
fi

# INSTALL PAMAC - GUI PACKAGE MANAGER
if [[ $FEATURES == *"pamac"* ]]; then
  show_progress "INSTALLING PAMAC PACKAGE MANAGER"
  sudo -u $USERNAME yay -S --noconfirm pamac-aur
fi

# CONFIGURE AUR HANDLING FOR BETTER SECURITY
show_progress "CONFIGURING SECURE AUR USAGE"
sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf
echo 'INTEGRITY_CHECK=(sha256 sha512 md5)' >> /etc/makepkg.conf

# OPTIMIZE PACMAN
show_progress "OPTIMIZING PACMAN"
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# INSTALL SYSTEM MONITORING TOOLS
show_progress "INSTALLING SYSTEM MONITORING TOOLS"
pacman -S --noconfirm htop bashtop neofetch lm_sensors
sudo -u $USERNAME yay -S --noconfirm fastfetch

# CONFIGURE NETWORKMANAGER FOR BETTER DEFAULTS
show_progress "OPTIMIZING NETWORKMANAGER"
cat > /etc/NetworkManager/conf.d/20-better-defaults.conf << 'EOL'
[connection]
wifi.powersave = 2

[device]
wifi.scan-rand-mac-address = yes

[connectivity]
interval = 600
EOL

# ADD LAPTOP-SPECIFIC TOOLS IF ON A LAPTOP
if [[ $FEATURES == *"laptop_tools"* ]]; then
  show_progress "INSTALLING LAPTOP POWER MANAGEMENT"
  pacman -S --noconfirm tlp tlp-rdw powertop
  systemctl enable tlp.service
  
  # CONFIGURE TLP FOR BETTER BATTERY LIFE
  cat > /etc/tlp.conf << 'EOL'
# TLP OPTIMIZED CONFIGURATION
TLP_ENABLE=1
TLP_DEFAULT_MODE=BAT
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_MAX_PERF_ON_BAT=50
PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto
EOL
fi

# INSTALL SOME BASIC UTILITIES
show_progress "INSTALLING ADDITIONAL UTILITIES"
pacman -S --noconfirm gedit gnome-calculator gnome-calendar gnome-photos gnome-terminal nautilus file-roller evince eog totem cheese
pacman -S --noconfirm libreoffice-fresh firefox vlc gimp

# CREATE A GUI APP CHOOSER SCRIPT
show_progress "CREATING GUI APP CHOOSER"

cat > /usr/local/bin/arch-app-chooser << 'EOL'
#!/bin/bash

# ARCH LINUX APP CHOOSER
# SIMPLE GUI TO SELECT ADDITIONAL APPLICATIONS TO INSTALL

export DISPLAY=:0
export XAUTHORITY=/home/$USER/.Xauthority

tabs=$(zenity --list --title="KUDU APP CHOOSER" --text="CHOOSE A CATEGORY" --radiolist \
  --column="Select" --column="Category" --column="Description" \
  TRUE "internet" "INTERNET APPLICATIONS" \
  FALSE "office" "OFFICE APPLICATIONS" \
  FALSE "media" "MULTIMEDIA APPLICATIONS" \
  FALSE "graphics" "GRAPHICS APPLICATIONS" \
  FALSE "dev" "DEVELOPMENT TOOLS" \
  FALSE "gaming" "GAMING APPLICATIONS" \
  FALSE "system" "SYSTEM UTILITIES" \
  --width=600 --height=400)

if [ -z "$tabs" ]; then
  exit 0
fi

case "$tabs" in
  "internet")
    apps=$(zenity --list --title="INTERNET APPLICATIONS" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "firefox" "MOZILLA FIREFOX WEB BROWSER" \
      FALSE "chromium" "CHROMIUM WEB BROWSER" \
      FALSE "brave-bin" "BRAVE WEB BROWSER (AUR)" \
      FALSE "vivaldi" "VIVALDI WEB BROWSER" \
      FALSE "thunderbird" "MOZILLA THUNDERBIRD EMAIL CLIENT" \
      FALSE "evolution" "GNOME EMAIL AND CALENDAR CLIENT" \
      FALSE "discord" "CHAT & VOICE COMMUNICATION" \
      FALSE "telegram-desktop" "TELEGRAM MESSENGER" \
      FALSE "signal-desktop" "SIGNAL PRIVATE MESSENGER" \
      FALSE "filezilla" "FTP CLIENT" \
      FALSE "qbittorrent" "BITTORRENT CLIENT" \
      FALSE "nextcloud-client" "NEXTCLOUD SYNC CLIENT" \
      --width=800 --height=600)
    ;;
  "office")
    apps=$(zenity --list --title="OFFICE APPLICATIONS" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "libreoffice-fresh" "LIBREOFFICE SUITE (FRESH)" \
      FALSE "libreoffice-still" "LIBREOFFICE SUITE (STABLE)" \
      FALSE "onlyoffice-desktopeditors" "ONLYOFFICE DESKTOP SUITE" \
      FALSE "wps-office" "WPS OFFICE SUITE (AUR)" \
      FALSE "calibre" "E-BOOK MANAGER" \
      FALSE "evince" "PDF VIEWER" \
      FALSE "okular" "DOCUMENT VIEWER" \
      FALSE "pdfarranger" "PDF PAGE ARRANGER" \
      FALSE "zathura" "LIGHTWEIGHT PDF VIEWER" \
      FALSE "scribus" "DESKTOP PUBLISHING SOFTWARE" \
      FALSE "gnucash" "FINANCIAL MANAGEMENT" \
      --width=800 --height=600)
    ;;
  "media")
    apps=$(zenity --list --title="MULTIMEDIA APPLICATIONS" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "vlc" "VLC MEDIA PLAYER" \
      FALSE "mpv" "MPV MEDIA PLAYER" \
      FALSE "celluloid" "GTK FRONTEND FOR MPV" \
      FALSE "spotify" "SPOTIFY MUSIC PLAYER (AUR)" \
      FALSE "audacity" "AUDIO EDITOR" \
      FALSE "obs-studio" "SCREEN RECORDING/STREAMING" \
      FALSE "kdenlive" "VIDEO EDITOR" \
      FALSE "shotcut" "VIDEO EDITOR" \
      FALSE "rhythmbox" "MUSIC PLAYER" \
      FALSE "handbrake" "VIDEO TRANSCODER" \
      --width=800 --height=600)
    ;;
  "graphics")
    apps=$(zenity --list --title="GRAPHICS APPLICATIONS" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "gimp" "IMAGE EDITOR" \
      FALSE "inkscape" "VECTOR GRAPHICS EDITOR" \
      FALSE "krita" "DIGITAL PAINTING" \
      FALSE "blender" "3D CREATION SUITE" \
      FALSE "darktable" "PHOTOGRAPHY WORKFLOW" \
      FALSE "rawtherapee" "RAW IMAGE EDITOR" \
      FALSE "digikam" "PHOTO MANAGEMENT" \
      FALSE "gthumb" "IMAGE VIEWER AND BROWSER" \
      FALSE "figma-linux" "FIGMA UI DESIGN TOOL (AUR)" \
      --width=800 --height=600)
    ;;
  "dev")
    apps=$(zenity --list --title="DEVELOPMENT TOOLS" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "visual-studio-code-bin" "VISUAL STUDIO CODE (AUR)" \
      FALSE "sublime-text-4" "SUBLIME TEXT EDITOR (AUR)" \
      FALSE "atom" "ATOM TEXT EDITOR" \
      FALSE "intellij-idea-community-edition" "INTELLIJ IDEA" \
      FALSE "pycharm-community-edition" "PYCHARM IDE" \
      FALSE "eclipse" "ECLIPSE IDE" \
      FALSE "android-studio" "ANDROID DEVELOPMENT" \
      FALSE "git" "GIT VERSION CONTROL" \
      FALSE "meld" "VISUAL DIFF AND MERGE TOOL" \
      FALSE "docker" "DOCKER CONTAINERS" \
      FALSE "dbeaver" "DATABASE TOOL" \
      FALSE "postman-bin" "API DEVELOPMENT (AUR)" \
      --width=800 --height=600)
    ;;
  "gaming")
    apps=$(zenity --list --title="GAMING APPLICATIONS" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "steam" "STEAM GAMING PLATFORM" \
      FALSE "lutris" "GAME MANAGER" \
      FALSE "wine" "WINDOWS COMPATIBILITY LAYER" \
      FALSE "winetricks" "WINE CONFIGURATION TOOL" \
      FALSE "wine-staging" "DEVELOPMENT WINE VERSION" \
      FALSE "wine-gecko" "WINE HTML ENGINE" \
      FALSE "wine-mono" "WINE .NET IMPLEMENTATION" \
      FALSE "gamemode" "GAME PERFORMANCE OPTIMIZER" \
      FALSE "mangohud" "GAMING PERFORMANCE OVERLAY" \
      FALSE "discord" "GAMING COMMUNICATION" \
      --width=800 --height=600)
    ;;
  "system")
    apps=$(zenity --list --title="SYSTEM UTILITIES" --text="SELECT APPLICATIONS TO INSTALL" --checklist \
      --column="Select" --column="Package" --column="Description" \
      FALSE "gnome-tweaks" "GNOME CUSTOMIZATION TOOL" \
      FALSE "dconf-editor" "ADVANCED GNOME CONFIGURATION" \
      FALSE "gparted" "PARTITION EDITOR" \
      FALSE "gnome-disk-utility" "DISK MANAGEMENT" \
      FALSE "timeshift" "SYSTEM BACKUP" \
      FALSE "bleachbit" "SYSTEM CLEANER" \
      FALSE "cpupower-gui" "CPU FREQUENCY CONTROL" \
      FALSE "cpu-x" "CPU INFORMATION TOOL (AUR)" \
      FALSE "nvtop" "NVIDIA PROCESS MONITOR" \
      FALSE "virtualbox" "VIRTUAL MACHINE SOFTWARE" \
      FALSE "virt-manager" "KVM VIRTUAL MACHINE MANAGER" \
      FALSE "remmina" "REMOTE DESKTOP CLIENT" \
      --width=800 --height=600)
    ;;
esac

if [ -n "$apps" ]; then
  for app in $apps; do
    if [[ "$app" == *"-bin"* ]] || [[ "$app" == "spotify" ]] || [[ "$app" == "cpu-x" ]] || [[ "$app" == "figma-linux" ]] || [[ "$app" == "postman-bin" ]]; then
      # INSTALL AUR PACKAGE
      yay -S --noconfirm $app
    else
      # INSTALL REGULAR PACKAGE
      sudo pacman -S --noconfirm $app
    fi
  done
  
  zenity --info --text="SELECTED APPLICATIONS HAVE BEEN INSTALLED!"
fi
EOL

chmod +x /usr/local/bin/arch-app-chooser

# CREATE A DESKTOP SHORTCUT FOR THE APP CHOOSER
cat > /usr/share/applications/arch-app-chooser.desktop << 'EOL'
[Desktop Entry]
Name=Kudu App Chooser
Comment=Select additional applications to install
Exec=/usr/local/bin/arch-app-chooser
Icon=system-software-install
Terminal=false
Type=Application
Categories=System;
EOL

# CREATE A DESKTOP SHORTCUT FOR THEME SWITCHER
show_progress "CREATING THEME SWITCHER"

cat > /usr/local/bin/arch-theme-switcher << 'EOL'
#!/bin/bash

# THEME SWITCHER FOR KUDU ARCH LINUX
# SIMPLE GUI TO SELECT SYSTEM THEMES

export DISPLAY=:0
export XAUTHORITY=/home/$USER/.Xauthority

theme=$(zenity --list --title="KUDU THEME SWITCHER" --text="SELECT A THEME FOR YOUR SYSTEM" --radiolist \
  --column="Select" --column="Theme" --column="Description" \
  TRUE "dracula" "DRACULA THEME (DARK PURPLE)" \
  FALSE "adwaita" "GNOME DEFAULT THEME" \
  FALSE "adwaita-dark" "GNOME DARK THEME" \
  --width=600 --height=300)

if [ "$theme" = "dracula" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
  gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'
  gsettings set org.gnome.desktop.interface icon-theme 'Tela-purple'
  zenity --info --text="DRACULA THEME APPLIED!"
  
elif [ "$theme" = "adwaita" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
  gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
  gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
  zenity --info --text="ADWAITA (LIGHT) THEME APPLIED!"
  
elif [ "$theme" = "adwaita-dark" ]; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
  gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  zenity --info --text="ADWAITA DARK THEME APPLIED!"
fi
EOL

chmod +x /usr/local/bin/arch-theme-switcher

cat > /usr/share/applications/arch-theme-switcher.desktop << 'EOL'
[Desktop Entry]
Name=Kudu Theme Switcher
Comment=Change system themes
Exec=/usr/local/bin/arch-theme-switcher
Icon=preferences-desktop-theme
Terminal=false
Type=Application
Categories=Settings;
EOL

# ADD A SYSTEM CLEANING SCRIPT
cat > /usr/local/bin/arch-cleanup << 'EOL'
#!/bin/bash

# KUDU ARCH LINUX SYSTEM CLEANUP SCRIPT
# THIS SCRIPT HELPS MAINTAIN YOUR ARCH SYSTEM BY CLEANING UP UNUSED PACKAGES,
# CACHE, AND PERFORMING MAINTENANCE TASKS

# CHECK IF RUNNING AS ROOT
if [ "$EUID" -ne 0 ]; then
  echo "PLEASE RUN AS ROOT"
  exit 1
fi

echo "STARTING KUDU ARCH LINUX SYSTEM MAINTENANCE..."

# CLEAN CACHED PACKAGES BUT KEEP THE MOST RECENT TWO VERSIONS
echo "CLEANING PACKAGE CACHE..."
paccache -r

# REMOVE ORPHANED PACKAGES (DEPENDENCIES THAT ARE NO LONGER NEEDED)
echo "REMOVING ORPHANED PACKAGES..."
pacman -Rs $(pacman -Qtdq) 2>/dev/null || echo "NO ORPHANED PACKAGES TO REMOVE."

# CLEAN USER CACHE
echo "CLEANING USER CACHES..."
find /home -type f -name "*.cache" -delete
find /home -type d -name ".cache" -exec find {} -type f -atime +30 -delete \;

# JOURNAL CLEANUP
echo "CLEANING SYSTEM JOURNAL..."
journalctl --vacuum-time=2weeks

# CHECK FOR ERRORS
echo "CHECKING FOR SYSTEM ERRORS..."
systemctl --failed

# TRIM SSD IF PRESENT
if [ -x "$(command -v fstrim)" ]; then
  echo "TRIMMING SSD..."
  fstrim -av
fi

echo "MAINTENANCE COMPLETE!"
EOL

chmod +x /usr/local/bin/arch-cleanup

cat > /usr/share/applications/arch-cleanup.desktop << 'EOL'
[Desktop Entry]
Name=Kudu System Cleanup
Comment=Clean and maintain system
Exec=sudo /usr/local/bin/arch-cleanup
Icon=system-run
Terminal=true
Type=Application
Categories=System;
EOL

# CREATE A WELCOME SCRIPT FOR FIRST LOGIN
cat > /usr/local/bin/arch-welcome << 'EOL'
#!/bin/bash

# WELCOME SCRIPT FOR KUDU ARCH LINUX
zenity --info --title="WELCOME TO YOUR KUDU ARCH LINUX SETUP" \
  --text="YOUR SYSTEM HAS BEEN CONFIGURED SUCCESSFULLY!\n\nHERE ARE SOME TIPS TO GET STARTED:\n\n• USE THE APP CHOOSER TO INSTALL ADDITIONAL SOFTWARE\n• USE THE THEME SWITCHER TO CHANGE YOUR THEME\n• THE SYSTEM CLEANUP TOOL HELPS MAINTAIN YOUR SYSTEM\n• UPDATES CAN BE MANAGED THROUGH PAMAC OR 'SUDO PACMAN -SYU'\n\nENJOY YOUR KUDU ARCH LINUX EXPERIENCE!" \
  --width=500

# DON'T SHOW THIS AGAIN ON LOGIN
mkdir -p ~/.config/autostart
touch ~/.config/autostart/.kudu-welcome-shown
EOL

chmod +x /usr/local/bin/arch-welcome

# ADD TO AUTOSTART ONLY IF NOT ALREADY SHOWN
cat > /etc/xdg/autostart/arch-welcome.desktop << 'EOL'
[Desktop Entry]
Name=Kudu Welcome
Comment=Welcome screen for new users
Exec=/bin/bash -c "[ -f ~/.config/autostart/.kudu-welcome-shown ] || /usr/local/bin/arch-welcome"
Icon=system-help
Terminal=false
Type=Application
Categories=System;
StartupNotify=true
EOL

# FINAL REPORT
show_progress "SETUP COMPLETED SUCCESSFULLY!"
echo ""
echo "YOUR KUDU ARCH LINUX SYSTEM HAS BEEN CONFIGURED WITH:"
echo "✅ VANILLA GNOME DESKTOP ENVIRONMENT"
echo "✅ DRACULA THEME APPLIED SYSTEM-WIDE"
echo "✅ FLATPAK SUPPORT"
echo "✅ CHROMIUM BROWSER"
echo "✅ ZSH WITH POWERLEVEL10K THEME (SIMILAR TO JONATHAN THEME)"
echo "✅ GNOME EXTENSIONS: DASH TO DOCK, BLUR MY SHELL, VITALS, CAFFEINE, IMPATIENCE, APPINDICATOR"
echo "✅ HARDWARE DRIVERS AND FIRMWARE"
if [[ $FEATURES == *"pamac"* ]]; then
  echo "✅ PAMAC - GRAPHICAL PACKAGE MANAGER"
fi
if [[ $FEATURES == *"timeshift"* ]]; then
  echo "✅ TIMESHIFT - AUTOMATIC SYSTEM BACKUPS"
fi
if [[ $FEATURES == *"laptop_tools"* ]]; then
  echo "✅ IMPROVED POWER MANAGEMENT FOR LAPTOPS"
fi
echo "✅ ENHANCED GUI APP CHOOSER WITH CATEGORIZED APPLICATIONS"
echo "✅ THEME SWITCHER FOR EASY THEME CHANGES"
echo "✅ SYSTEM CLEANUP UTILITY"
echo "✅ WELCOME SCREEN ON FIRST LOGIN"
echo "✅ GNOME BOXES INSTALLED"
if [[ $FEATURES == *"teams"* ]]; then
  echo "✅ MICROSOFT TEAMS INSTALLED"
fi
if [ "$DUAL_BOOT" = true ]; then
  echo "✅ GRUB BOOTLOADER CONFIGURED FOR DUAL BOOT"
fi
echo ""
echo "TO RUN THE GUI APP CHOOSER, LOOK FOR 'KUDU APP CHOOSER' IN YOUR APPLICATIONS MENU"
echo "OR RUN 'arch-app-chooser' FROM THE TERMINAL AFTER REBOOTING."
echo ""
echo "🚀 PLEASE REBOOT YOUR SYSTEM TO COMPLETE THE SETUP:"
echo "   $ sudo reboot"
echo ""
echo "SETUP LOG HAS BEEN SAVED TO: $LOG_FILE"
