#!/bin/bash

#############################################
# BatteryMQTT Installer
#############################################

set -e

CONFIG_DIR="/etc/batterymqtt"
CONFIG_FILE="$CONFIG_DIR/config.conf"
INSTALL_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/batterymqtt.service"

# Directory where install.sh is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

#############################################
# Root Check
#############################################

check_root() {

    if [ "$EUID" -ne 0 ]; then
        echo "======================================"
        echo "      BatteryMQTT Installer"
        echo "======================================"
        echo
        echo "This installer must be run as root."
        echo
        echo "Proxmox VE:"
        echo "  ./install.sh"
        echo
        echo "Debian / Ubuntu:"
        echo "  sudo ./install.sh"
        echo
        exit 1
    fi

}

#############################################
# Dependencies
#############################################

install_dependencies() {

    if command -v mosquitto_pub >/dev/null 2>&1; then
        echo "[1/6] Dependencies already installed."
        return
    fi

    echo "[1/6] Installing mosquitto-clients..."

    if command -v apt >/dev/null 2>&1; then
        apt update
        apt install -y mosquitto-clients
    else
        echo "Unsupported package manager."
        exit 1
    fi

}

#############################################
# Collect Configuration
#############################################

collect_configuration() {

    echo
    echo "BatteryMQTT Configuration"
    echo

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

    if [ ! -f "$SCRIPT_DIR/batterymqtt" ]; then
        echo "Error: batterymqtt not found."
        echo "Expected location:"
        echo "$SCRIPT_DIR/batterymqtt"
        exit 1
    fi

    cp "$SCRIPT_DIR/batterymqtt" "$INSTALL_DIR/batterymqtt"
    chmod +x "$INSTALL_DIR/batterymqtt"

}

#############################################
# Create systemd Service
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

    echo "[5/6] Enabling service..."

    systemctl daemon-reload
    systemctl enable batterymqtt
    systemctl restart batterymqtt

}

#############################################
# Finish
#############################################

finish() {

    echo
    echo "======================================"
    echo " BatteryMQTT installed successfully!"
    echo "======================================"
    echo
    echo "Useful commands:"
    echo
    echo "systemctl status batterymqtt"
    echo "systemctl restart batterymqtt"
    echo "systemctl stop batterymqtt"
    echo

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
