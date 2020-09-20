
#!/bin/bash

# --------------------------------------------------------------------------------------------
# Installs CoinCooler on RP3
# --------------------------------------------------------------------------------------------
# Time the install process
START_TIME=$SECONDS

# rname the machine
sudo sed -i 's/raspberrypi/coincooler/g' /etc/hostname
sudo sed -i 's/raspberrypi/coincooler/g' /etc/hosts

# install nodejs js runtime, sqlite and srm
sudo apt install -y nodejs libsqlite3-dev secure-delete xdotool

# fix issue with openssl support a-la https://github.com/oleganza/btcruby/issues/29
sudo ln -nfs /usr/lib/arm-linux-gnueabihf/libssl.so.1.0.2 /usr/lib/arm-linux-gnueabihf/libssl.so

# install and configure bundler at version 1.16.1
sudo gem install bundler -v 1.16.1
bundle _1.16.1_ config path .bundle
bundle _1.16.1_ config bin ".bundle/binstubs"
bundle _1.16.1_ config github.https true
bundle _1.16.1_ config disable_shared_gems true

# clone the coincooler repo and bundle
git clone https://github.com/assafshomer/rpcc.git coincooler
cd coincooler
bundle _1.16.1_

# migrate sqlite3 db
bundle _1.16.1_ exec rake db:migrate
bundle _1.16.1_ exec rake db:migrate RAILS_ENV=test
bundle _1.16.1_ exec rake db:migrate RAILS_ENV=production

# precompile assets
bundle _1.16.1_ exec rake assets:precompile

# run tests
bundle _1.16.1_ exec rspec spec

# copy over config files
sudo cp ~/coincooler/config-rp/launchers/.aliases ~/.aliases
sudo cp ~/coincooler/config-rp/launchers/CoinCooler ~/Desktop
sudo cp ~/coincooler/config-rp/launchers/coincooler.desktop /usr/share/raspi-ui-overrides/applications
sudo mv /usr/share/rpd-wallpaper/road.jpg /usr/share/rpd-wallpaper/road.jpg.old
sudo cp ~/coincooler/app/assets/images/Bitcoin_in_ice_transparent_bgd.png /usr/share/rpd-wallpaper/road.jpg

echo "source .aliases" >> ~/.bashrc

#add purge script to crontab
crontab -l > mycron
echo "@reboot /home/pi/coincooler/config-rp/scripts/purger.sh" >> mycron
sudo crontab mycron
rm mycron

# disable wifi and bluetooth
sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"
sudo sh -c "echo 'dtoverlay=pi3-disable-bt' >> /boot/config.txt"

# let hardware rng contribute to kernel's randomness pool
echo bcm2835_rng | sudo tee /etc/modules-load.d/rng-tools.conf
sudo modprobe bcm2835_rng
sudo apt install rng-tools
echo 'HRNGDEVICE=/dev/hwrng' | sudo tee --append /etc/default/rng-tools
sudo systemctl enable rng-tools
sudo systemctl start rng-tools

# Print the time elapsed into a log file
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n" >> ~/Documents/coincooler-installation.log

read -p "  Reboot RaspberryPi (y/n) " ans
if [[ $ans != "y" ]]; then
  sudo reboot
fi
