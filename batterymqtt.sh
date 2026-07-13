#!/bin/bash

CONFIG="/etc/batterymqtt/config.conf"

source "$CONFIG"

BATTERY=$(ls /sys/class/power_supply/ | grep BAT | head -n 1)

if [ -z "$BATTERY" ]; then
    echo "No se encontró batería"
    exit 1
fi

while true
do

CAPACITY=$(cat /sys/class/power_supply/$BATTERY/capacity)
STATUS=$(cat /sys/class/power_supply/$BATTERY/status)

mosquitto_pub \
-h "$MQTT_HOST" \
-p "$MQTT_PORT" \
-u "$MQTT_USER" \
-P "$MQTT_PASS" \
-t "BatteryMQTT/$DEVICE_NAME/battery" \
-m "$CAPACITY"

mosquitto_pub \
-h "$MQTT_HOST" \
-p "$MQTT_PORT" \
-u "$MQTT_USER" \
-P "$MQTT_PASS" \
-t "BatteryMQTT/$DEVICE_NAME/status" \
-m "$STATUS"

sleep 60

done
