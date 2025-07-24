#!/bin/bash
set -e

echo "⚙️ Installing Bettercap Setup..."

# 1. Create Bettercap caplet with SSID whitelist
echo "📶 Creating Bettercap caplet..."
cat << EOF > /home/pi/bettercap.cap
set wifi.whitelist.ssid YNJE,Fake,ASUS-VIVOBOOK
wifi.recon on
wifi.assoc on
EOF

# 2. Create startup script
echo "🚀 Creating Bettercap startup script..."
cat << 'EOF' > /usr/local/bin/start_bettercap.sh
#!/bin/bash

IFACE="wlan0"

if ip link show wlan1 &> /dev/null; then
  IFACE="wlan1"
fi

sudo ip link set $IFACE down
sudo iw $IFACE set type monitor
sudo ip link set $IFACE up

sudo bettercap -iface ${IFACE}mon -caplet /home/pi/bettercap.cap
EOF
chmod +x /usr/local/bin/start_bettercap.sh

# 3. Create systemd service
echo "🔧 Setting up systemd service..."
cat << EOF > /etc/systemd/system/bettercap.service
[Unit]
Description=Bettercap Dynamic Interface Launcher
After=network.target

[Service]
ExecStart=/usr/local/bin/start_bettercap.sh
Type=simple
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable bettercap.service

# 4. Udev rule to assign Alfa adapter as wlan1
echo "🔌 Adding udev rule for persistent naming..."
cat << EOF > /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=="net", ACTION=="add", ATTRS{idVendor}=="0cf3", ATTRS{idProduct}=="9271", NAME="wlan1"
EOF

udevadm control --reload-rules

# 5. Create hotplug script
echo "🔁 Creating hotplug switch script..."
cat << 'EOF' > /usr/local/bin/switch_wifi.sh
#!/bin/bash

# Pause Bettercap
sudo pkill -STOP bettercap

# Enable monitor mode on wlan1
sudo ip link set wlan1 down
sudo iw wlan1 set type monitor
sudo ip link set wlan1 up

# Resume Bettercap
sudo pkill -CONT bettercap
EOF
chmod +x /usr/local/bin/switch_wifi.sh

# 6. Hotplug detection rule
echo "📡 Adding hotplug udev rule..."
cat << EOF > /etc/udev/rules.d/99-hotplug-wifi.rules
SUBSYSTEM=="net", ACTION=="add", ATTRS{idVendor}=="0cf3", ATTRS{idProduct}=="9271", RUN+="/usr/local/bin/switch_wifi.sh"
EOF

udevadm control --reload-rules

echo "✅ Setup complete! Reboot to activate everything."
