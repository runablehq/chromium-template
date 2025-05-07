#!/bin/bash

# Remove power manager panel plugin
xfconf-query -c xfce4-panel -p /plugins/plugin-9 -r -R || true
killall xfce4-power-manager || true

# Disable power manager autostart
mkdir -p ~/.config/autostart/
echo "[Desktop Entry]
Hidden=true" > ~/.config/autostart/xfce4-power-manager.desktop

# Create or update the session startup file to disable the power manager
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml/
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-power-manager" version="1.0">
  <property name="xfce4-power-manager" type="empty">
    <property name="show-tray-icon" type="bool" value="false"/>
    <property name="general-notification" type="bool" value="false"/>
    <property name="dpms-enabled" type="bool" value="false"/>
  </property>
</channel>
EOF

# Kill any running power manager processes
pkill -f xfce4-power-manager || true