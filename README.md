# BatteryMQTT

BatteryMQTT is a lightweight MQTT battery monitoring service for Linux systems.

It allows you to monitor a device battery status in **Home Assistant** using MQTT Discovery, without manually creating sensors.

Designed for:

* Proxmox servers running on laptops
* Debian / Ubuntu systems
* Linux devices with ACPI battery support

## Features

✅ Automatic MQTT Discovery
✅ Home Assistant device creation
✅ Battery percentage monitoring
✅ Battery charging status
✅ AC adapter status
✅ Automatic battery detection
✅ Runs as a systemd service
✅ Works without a battery installed (wait mode)

## Home Assistant Integration

After installation, BatteryMQTT automatically creates a device:

```
Device:
  Proxmox_Cano

Entities:
  🔋 Battery
  ⚡ Battery Status
  🔌 AC Adapter
```

No manual `configuration.yaml` changes are required.

## Requirements

* Linux system with ACPI battery support
* MQTT broker (Mosquitto recommended)
* Home Assistant with MQTT integration enabled

Install dependencies:

```bash
apt update
apt install mosquitto-clients -y
```

## Installation

Clone the repository:

```bash
git clone https://github.com/ADVic20/BatteryMQTT.git
```

Enter the directory:

```bash
cd BatteryMQTT
```

Run the installer:

```bash
./install.sh
```

The installer will ask for:

```
Device name
MQTT broker IP
MQTT username
MQTT password
```

Example:

```
Device name: Proxmox_Cano
MQTT Broker IP: 192.168.0.166
MQTT Username: mqtt_user
MQTT Password: ********
```

## Service Commands

Check status:

```bash
systemctl status batterymqtt
```

Restart service:

```bash
systemctl restart batterymqtt
```

Stop service:

```bash
systemctl stop batterymqtt
```

View logs:

```bash
journalctl -u batterymqtt -f
```

## MQTT Topics

Battery percentage:

```
BatteryMQTT/<device>/battery
```

Battery status:

```
BatteryMQTT/<device>/status
```

AC adapter:

```
BatteryMQTT/<device>/ac
```

Example:

```
BatteryMQTT/Proxmox_cano/battery 85
BatteryMQTT/Proxmox_cano/status Charging
BatteryMQTT/Proxmox_cano/ac Connected
```

## Battery Support

BatteryMQTT reads information from:

```
/sys/class/power_supply/
```

Supported information depends on the hardware battery controller.

Available information may include:

* Battery capacity
* Charging status
* AC connection
* Battery health information (if supported)

## Uninstall

Stop the service:

```bash
systemctl stop batterymqtt
```

Disable startup:

```bash
systemctl disable batterymqtt
```

Remove files:

```bash
rm -rf /etc/batterymqtt
rm /usr/local/bin/batterymqtt
rm /etc/systemd/system/batterymqtt.service
```

Reload systemd:

```bash
systemctl daemon-reload
```

## Version

Current version:

```
1.0.0
```

## License

This project is licensed under the MIT License.

## Author

ADVic20

