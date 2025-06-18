#!/bin/bash

# Get public IP using ipconfig.me
PUBLIC_IP=$(curl -s ipconfig.me)

# Replace [VM-Public-IP] with actual public IP in Caddyfile
sed -i "s/\[VM-Public-IP\]/$PUBLIC_IP/g" Caddyfile

echo "Updated Caddyfile with Public IP: $PUBLIC_IP"