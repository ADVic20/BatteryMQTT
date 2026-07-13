```bash
#!/bin/bash

#############################################
# BatteryMQTT Installer
#############################################

set -e

CONFIG_DIR="/etc/batterymqtt"
CONFIG_FILE="$CONFIG_DIR/config.conf"
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/batterymqtt.service"

#############################################
# Root Check
#############################################

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "======================================"
        echo "      BatteryMQTT Installer"
        echo "======================================"
        echo ""
        echo "This installer must be run as root."
        echo ""
        echo "Proxmox VE:"
        echo "  ./install.sh"
        echo ""
        echo "Debian / Ubuntu:"
        echo "  sudo ./install.sh"
        echo ""
        exit 1
    fi
}

#############################################
# Dependencies
#############################################

install_dependencies() {

    if command -v mosquitto_pub >/dev/null 2>&1; then
        return
    fi

    echo "[1/6] Installing mosquitto-clients..."

    apt update
    apt install -y mosquitto-clients
}

#############################################
# Collect Configuration
#############################################

collect_configuration() {

    echo ""
    echo "BatteryMQTT Configuration"
    echo ""

    read -rp "Device name: " DEVICE_NAME
    read -rp "MQTT Broker IP: " MQTT_HOST
    read -rp "MQTT Username: " MQTT_USER
    read -rsp "MQTT Password: " MQTT_PASS
    echo

}

#############################################
# Save Configuration
#############################################

save_configuration() {

    echo "[2/6] Saving configuration..."

    mkdir -p "$CONFIG_DIR"

    cat > "$CONFIG_FILE" <<EOF
DEVICE_NAME="$DEVICE_NAME"
MQTT_HOST="$MQTT_HOST"
MQTT_USER="$MQTT_USER"
MQTT_PASS="$MQTT_PASS"
MQTT_PORT="1883"
EOF

}

#############################################
# Install Program
#############################################

install_program() {

    echo "[3/6] Installing BatteryMQTT..."

    if [ ! -f "batterymqtt.sh" ]; then
        echo "Error: batterymqtt.sh not found."
        exit 1
    fi

    cp batterymqtt.sh "$INSTALL_DIR/batterymqtt"
    chmod +x "$INSTALL_DIR/batterymqtt"

}

#############################################
# Create Service
#############################################

create_service() {

    echo "[4/6] Creating systemd service..."

    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=BatteryMQTT
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/batterymqtt
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

}

#############################################
# Enable Service
#############################################

enable_service() {

    echo "[5/6] Starting BatteryMQTT..."

    systemctl daemon-reload
    systemctl enable batterymqtt
    systemctl restart batterymqtt

}

#############################################
# Finish
#############################################

finish() {

    echo ""
    echo "======================================"
    echo " BatteryMQTT installed successfully!"
    echo "======================================"
    echo ""
    echo "Useful commands:"
    echo ""
    echo "systemctl status batterymqtt"
    echo "systemctl restart batterymqtt"
    echo "systemctl stop batterymqtt"
    echo ""

}

#############################################
# Main
#############################################

check_root
install_dependencies
collect_configuration
save_configuration
install_program
create_service
enable_service
finish
```
