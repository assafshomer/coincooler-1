#!/bin/bash

# --------------------------------------------------------------------------------------------
# Installs Ruby 2.5 using rbenv/ruby-build on the Raspberry Pi (Raspbian)
# --------------------------------------------------------------------------------------------

# Time the install process
START_TIME=$SECONDS

# update distro
sudo apt -y update
sudo apt -y upgrade

# Install git + dependencies
sudo apt install -y git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev ruby-full

# Don't install docs for gems (saves lots of time)
echo "gem: --no-document" > ~/.gemrc

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "\nRuby Installation Completed in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n" >> ~/Documents/ruby-installation.log

read -p "  Reboot RaspberryPi (y/n) " ans
if [[ $ans = "y" ]]; then
  sudo reboot
fi
