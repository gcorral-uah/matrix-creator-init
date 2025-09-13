#!/bin/bash

# Build binaries
cmake . && make
cp -avr cpp/firmware_info cpp/fpga_info .

mkdir -p /usr/share/matrixlabs/matrixio-devices
# cp -avr blob cfg sam3-program.bash fpga-program.bash em358-program.bash creator-init.bash radio-init.bash firmware_info mcu_firmware.version matrixlabs_edit_settings.py matrixlabs_remove_console.py /usr/share/matrixlabs/matrixio-devices
cp -avr blob cfg sam3-program.bash voice.version fpga-program.bash em358-program.bash matrix-init.bash radio-init.bash firmware_info fpga_info mcu_firmware.version matrixlabs_edit_settings.py matrixlabs_remove_console.py  /usr/share/matrixlabs/matrixio-devices

mkdir -p /usr/share/matrixlabs/matrixio-devices/config
cp -avr boot_modifications.txt /usr/share/matrixlabs/matrixio-devices/config

# cp -avr matrix-creator-firmware.service /lib/systemd/system
cp -avr matrixio-devices-firmware.service /lib/systemd/system

# cp -avr matrix-creator-reset-jtag /usr/bin
cp -avr matrix-creator-reset-jtag voice_esptool voice_esp32_enable voice_esp32_reset /usr/local/bin
# cp -avr creator-mics.conf /etc/modules-load.d
cp -avr matrix-mics.conf /etc/modules-load.d
cp -avr raspicam.conf /etc/modules-load.d
# cp -avr asound.conf /etc/ # Not in folder
mkdir -p /etc/matrixio-devices
cp -avr matrix_voice.config /etc/matrixio-devices

cp -avr matrix_voice.config /etc/matrixio-devices
cp -avr matrix_devices.conf /etc/modprobe.d

echo "Enabling firmware loading at startup"
# systemctl enable matrix-creator-firmware
systemctl enable matrixio-devices-firmware

# This didn't work due to an unresolved shared library.
# Asking users to reboot after installation.
# echo "Loading firmware..."
# service matrix-creator-firmware start

echo "Enabling SPI"
cp /boot/config.txt /boot/config.txt.bk && /usr/share/matrixlabs/matrixio-devices/matrixlabs_edit_settings.py /boot/config.txt.bk /usr/share/matrixlabs/matrixio-devices/config/boot_modifications.txt > /boot/config.txt

echo "Disable UART console"
/usr/share/matrixlabs/matrixio-devices/matrixlabs_remove_console.py

pip install esptool

echo "Please restart your Raspberry Pi after installation"
