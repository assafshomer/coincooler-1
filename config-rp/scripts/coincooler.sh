#!/bin/bash
# minimize launched terminal window
xdotool getactivewindow set_window --name coincooler
xdotool search --name coincooler windowminimize

pkill -9 chromium-browser
pkill -9 ruby
/home/pi/coincooler/config-rp/scripts/purger.sh
clear
sleep 1
cd /home/pi/coincooler/
bundle exec rails s -e production &
clear
sleep 15
chromium-browser --app=http://localhost:3000 --start-fullscreen &
