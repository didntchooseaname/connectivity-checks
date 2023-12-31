#!/bin/bash

# Replace here your interfaces names
ETHERNETINTERFACE=enp2s0f0
WIFIINTERFACE=wlp3s0
VPNINTERFACE=tun0
PIVOTINTERFACE=ligolo

# Host that is ping to check the access to the internal network with pivot
PIVOTHOST=172.16.1.13

# Get the active container name (beghin with exehol-)
containername=$(docker ps --filter "name=exegol-*" --format "{{.Names}}" | cut -d'-' -f2-)

# Grep the output of ip address show to find inet (ipv4 configuration)
if ip a show $ETHERNETINTERFACE | grep -q "inet " ; then
    status="($ETHERNETINTERFACE)"
elif ip a show $WIFIINTERFACE | grep -q "inet " ; then
    status="($WIFIINTERFACE)"
else
    status="❌No internet"
fi

if ip a show $VPNINTERFACE | grep -q "inet " ; then
    status_vpn="🔐$containername-vpn"
else
    status_vpn="🔓No VPN"
fi

if ping -c 1 $PIVOTHOST > /dev/null 2>&1; then
    status_pivot="🔀$containername-pivot"
else
    status_pivot="❌No Pivot"
fi

echo "🌎$status $status_vpn $status_pivot"
