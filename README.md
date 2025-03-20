# KuduArchSetup
My personal Arch deployment script 

![image](https://github.com/user-attachments/assets/47716adb-c2de-4be9-a3cc-455360f3af22)

# Kudu Arch Linux Setup Guide

## After Booting Into Fresh Arch Install

1. **Connect to the internet (if not already connected):**
    ```bash
    sudo systemctl start NetworkManager
    nmcli device wifi connect "YOUR_NETWORK_NAME" password "YOUR_PASSWORD"
    ```

2. **Install git:**
    ```bash
    sudo pacman -S git
    ```

3. **Clone the Kudu repository:**
    ```bash
    git clone https://github.com/tvp227/KuduArchSetup.git
    ```

4. **Navigate to the repository:**
    ```bash
    cd KuduArchSetup
    ```

5. **Make the script executable:**
    ```bash
    chmod +x kudu-setup.sh
    ```

6. **Run the script:**
    ```bash
    sudo ./kudu-setup.sh
    ```

7. **Reboot when complete:**
    ```bash
    sudo reboot
    ```

---

## What's Included

- Minimal GNOME with Dracula theme
- Papirus icon theme
- Chromium, VSCode, Teams, Postman, Discord, Spotify
- ZSH with custom aliases and Powerlevel10k
- Custom wallpaper and minimal GNOME tweaks

---

## Useful Aliases

- **update** - Update system
- **install** - Install packages
- **search** - Search for packages
- **remove** - Remove packages
- **cleanup** - Remove orphaned packages
- **mirror** - Update mirror list
