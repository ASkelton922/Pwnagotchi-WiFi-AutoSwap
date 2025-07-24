# Pwnagotchi-WiFi-AutoSwap
An automated setup script for Bettercap on Raspberry Pi that dynamically switches between internal and external Wi-Fi adapters based on availability. Supports hotplugging of Alfa AWUS036NHA, auto-configures monitor mode, whitelists home SSIDs, and integrates with systemd for seamless boot-time activation. No overlay changes required.

# Bettercap-Hotplug-Wifi-Switcher

🎯 **Purpose**  
A dynamic Bettercap setup for Raspberry Pi with Pwnagotchi support that auto-detects available Wi-Fi adapters and switches seamlessly between internal (`wlan0`) and external Alfa AWUS036NHA (`wlan1`). It enables monitor mode, respects your home SSID whitelist, and hotplug triggers without any overlay modifications.

---

🚀 **Features**

- 🔌 Hotplug detection for Alfa AWUS036NHA (`wlan1`)
- 📶 Monitor mode setup and interface switching
- 🛡️ SSID whitelist support (no deauth on home networks)
- 🧠 Dynamic startup logic via systemd
- 🧰 Fully automated installer script

---

🛠️ **Install**

1. Clone the repo:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Bettercap-Hotplug-Wifi-Switcher.git
   cd Bettercap-Hotplug-Wifi-Switcher

2. Run the installer:
   ```bash
   chmod +x install_bettercap.sh
   sudo ./install_bettercap.sh

3. Reboot:
   ```bash
   sudo reboot

---

⚙️ Customization

Edit /home/pi/bettercap.cap to tweak SSID whitelist or add logging
Replace or modify /usr/local/bin/start_bettercap.sh if using a different adapter
Caplet customization: add new scan or association rules


📡 Requirements

Raspberry Pi with Pwnagotchi build (Jayofelony recommended)
Alfa AWUS036NHA (Atheros AR9271 chipset)
Bettercap installed and working

---

🤝 Contributions welcome! Feel free to fork and improve.
