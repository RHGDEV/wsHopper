#!/bin/bash

read -p "Banned IP to unban : " ip # Get banned ip from user
sudo fail2ban-client set sshd unbanip $ip # Unban ip
echo "IP ${ip} has been unbanned from the system!"
sleep 2