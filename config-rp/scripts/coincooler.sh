#!/bin/bash

pkill -9 chromium-browser
pkill -9 ruby
/home/pi/coincooler/config-rp/scripts/purger.sh
sleep 1
cd /home/pi/coincooler/
bundle exec rails s -e production &
sleep 15
chromium-browser --app=http://localhost:3000 --start-fullscreen &
