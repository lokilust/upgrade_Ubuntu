#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

# Get list of installed kernels. The `head -n -1` removes the
# last kernel in the list, which should be the latest kernel.
old_kernels=($(dpkg -l | grep linux-image | tr -s " " | \
    cut -f 2 -d ' ' | sort -V | uniq | head -n -1))

if [ "${#old_kernels[@]}" -eq 0 ]; then
    echo "No old kernels found"
fi

if ! apt-get remove -y --purge "${old_kernels[@]}"; then
    echo "Failed to remove old kernels"
fi

# Cleanup package database
apt -y autoremove 2>&1 | grep -Ev "^$"
apt -y --fix-broken install 2>&1 | grep -Ev "^$"
echo -e "$TEXT_YELLOW"
echo 'APT Cleanup package database finished...'
echo -e "$TEXT_RESET"


sudo apt-get update
echo -e "$TEXT_YELLOW"
echo 'APT update finished...'
echo -e "$TEXT_RESET"

sudo apt-get dist-upgrade
echo -e "$TEXT_YELLOW"
echo 'APT distributive upgrade finished...'
echo -e "$TEXT_RESET"

sudo apt-get upgrade
echo -e "$TEXT_YELLOW"
echo 'APT upgrade finished...'
echo -e "$TEXT_RESET"

sudo do-release-upgrade
echo -e "$TEXT_YELLOW"
echo 'do-release-upgrade finished...'
echo -e "$TEXT_RESET"

if [ -f /var/run/reboot-required ]; then
    echo -e "$TEXT_RED_B"
    echo 'Reboot required!'
    echo -e "$TEXT_RESET"
else
    echo -e "$TEXT_YELLOW"
    echo 'No reboot required'
    echo -e "$TEXT_RESET"
fi

exit 0
