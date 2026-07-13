# BatteryMQTT

BatteryMQTT is a lightweight Linux utility that publishes battery status and percentage to an MQTT broker, making it easy to integrate with Home Assistant.

It is designed for systems with a battery, such as laptops used as home servers running Proxmox VE, Debian, or Ubuntu.

## Features

* 🔋 Publishes battery percentage.
* ⚡ Publishes battery status (Charging, Discharging, Full, etc.).
* 📡 Sends data through MQTT.
* ⚙️ Interactive installation wizard.
* 🚀 Automatically starts on system boot.
* 🖥️ Compatible with Proxmox VE, Debian, and Ubuntu.

## Requirements

* Linux (Proxmox VE, Debian, or Ubuntu)
* A system with a detectable battery
* An MQTT broker (such as Mosquitto)
* Root or `sudo` privileges

## Installation

Clone the repository:

```bash
git clone https://github.com/ADVic20/BatteryMQTT.git
```

Enter the project directory:

```bash
cd BatteryMQTT
```

Run the installer:

```bash
sudo ./install.sh
```

During installation, you will be prompted for:

* Device name
* MQTT broker IP address
* MQTT username
* MQTT password

The installer will automatically configure BatteryMQTT and install it as a system service.

## How It Works

After installation, BatteryMQTT periodically reads your system's battery information and publishes it to your configured MQTT broker.

Home Assistant can then use these MQTT topics to display battery information or trigger automations.

## Compatibility

* ✅ Proxmox VE
* ✅ Debian
* ✅ Ubuntu

## Roadmap

Upcoming releases will include:

* MQTT Discovery for Home Assistant
* `uninstall.sh`
* `update.sh`
* Configurable publishing interval
* Additional battery information when available

## License

This project is licensed under the MIT License.

## Contributing

Contributions, bug reports, feature requests, and pull requests are welcome. Feel free to open an issue if you have ideas or encounter any problems.
