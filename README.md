# KuduArchSetup
My personal Arch deployment script 

![image](https://github.com/user-attachments/assets/d1e19881-5d51-44a4-958a-858dac5a3350)


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

## Useful Pacman Aliases

- **update** - Update system
- **install** - Install packages
- **search** - Search for packages
- **remove** - Remove packages
- **cleanup** - Remove orphaned packages
- **mirror** - Update mirror list


---
# Screenshots 
1.![image](https://github.com/user-attachments/assets/52baf4f1-b8b8-478a-bb3a-1c6a9cf199c3)
2.![image](https://github.com/user-attachments/assets/01bc02ca-1df9-4dc3-9ff5-c486b1b82599)
3.![image](https://github.com/user-attachments/assets/85b0e8c0-f040-43ea-a459-37680ea0fdef)
4.![image](https://github.com/user-attachments/assets/3733f86f-aa71-4575-9063-eb5895c8ecec)
5.![image](https://github.com/user-attachments/assets/b8490a48-b4f5-4193-aa07-f58ec6e35b18)
6.![image](https://github.com/user-attachments/assets/0fd8c4ec-3941-429d-abb3-44f1ab83bed5)




