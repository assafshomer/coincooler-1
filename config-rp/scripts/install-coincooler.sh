
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
sudo apt install -y nodejs libsqlite3-dev secure-delete

# fix issue with openssl support a-la https://github.com/oleganza/btcruby/issues/29
sudo ln -nfs /usr/lib/arm-linux-gnueabihf/libssl.so.1.0.2 /usr/lib/arm-linux-gnueabihf/libssl.so

# install and configure bundler
gem install bundler
bundle config path .bundle
bundle config bin ".bundle/binstubs"
bundle config github.https true
bundle config disable_shared_gems true

# clone the coincooler repo and bundle
git clone https://github.com/assafshomer/rpcc.git coincooler
cd coincooler
bundle

# migrate sqlite3 db
bundle exec rake db:migrate
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=production

# precompile assets
bundle exec rake assets:precompile

# run tests
bundle exec rspec spec

# copy over config files
sudo cp ~/coincooler/config-rp/launchers/.aliases ~/.aliases
sudo cp ~/coincooler/config-rp/launchers/CoinCooler ~/Desktop
sudo cp ~/coincooler/config-rp/launchers/coincooler.desktop /usr/share/raspi-ui-overrides/applications
sudo mv /usr/share/rpd-wallpaper/road.jpg /usr/share/rpd-wallpaper/road.jpg.old
sudo cp ~/coincooler/app/assets/images/Bitcoin_in_ice_transparent_bgd.png /usr/share/rpd-wallpaper/road.jpg

# quicklaunch hack
read -d '' String <<"EOF"
# coincooler
source .aliases
read -p "  Launch CoinCooler? (y/n) " ans
if [[ $ans != "y" ]]; then
  exit
fi
echo
EOF

# Save to ~/.bashrc
echo -e "\n${String}" >> ~/.bashrc

#add purge script to crontab
crontab -l > mycron
echo "@reboot /home/pi/coincooler/config-rp/scripts/purger.sh" >> mycron
sudo crontab mycron
rm mycron

# disable wifi
echo "dtoverlay=pi3-disable-wifi" >> /boot/config.txt

# Print the time elapsed into a log file
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n" >> ~/Documents/coincooler-installation.log

# reboot
sudo reboot
