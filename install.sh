#!/bin/bash

echo "====================="
echo "     BatteryMQTT"
echo "====================="

read -p "Nombre del dispositivo: " DEVICE_NAME
read -p "IP del broker MQTT: " MQTT_HOST
read -p "Usuario MQTT: " MQTT_USER
read -s -p "Password MQTT: " MQTT_PASS

echo ""

# Crear carpetas
mkdir -p /etc/batterymqtt
mkdir -p /usr/local/bin

# Guardar configuración
cat <<EOF > /etc/batterymqtt/config.conf
DEVICE_NAME="$DEVICE_NAME"
MQTT_HOST="$MQTT_HOST"
MQTT_USER="$MQTT_USER"
MQTT_PASS="$MQTT_PASS"
MQTT_PORT="1883"
EOF

# Copiar programa
cp batterymqtt.sh /usr/local/bin/batterymqtt.sh
chmod +x /usr/local/bin/batterymqtt.sh

# Crear servicio
cat <<EOF > /etc/systemd/system/batterymqtt.service
[Unit]
Description=BatteryMQTT Service
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/batterymqtt.sh
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

# Activar servicio
systemctl daemon-reload
systemctl enable batterymqtt
systemctl start batterymqtt

echo ""
echo "====================="
echo " BatteryMQTT instalado"
echo "====================="
