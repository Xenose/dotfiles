#!/bin/sh

sed -i 's/^#*\s*PasswordAuthentication\s\+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
grep -q '^PasswordAuthentication' "$CONFIG_FILE" || echo 'PasswordAuthentication yes' >> "$CONFIG_FILE"
systemctl restart sshd
notify-send "[ SSH ] password login on"

# 3 minute window
sleep 180

sed -i 's/^#*\s*PasswordAuthentication\s\+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
notify-send "[ SSH ] password login off"
