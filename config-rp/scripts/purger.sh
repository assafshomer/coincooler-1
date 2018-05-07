#! /bin/bash
find /home/pi/coincooler/files -iname "*.*" -exec srm {} \;
find /home/pi/coincooler/tmp/pids -iname "*.*" -exec rm {} \;
find /home/pi/coincooler/log -iname "*.*" -exec srm {} \;
find /home/pi/coincooler/files/uploads/ -type f -exec srm {} \;
find /home/pi/coincooler/files/uploads/ -mindepth 1 -depth -type d -exec rmdir {} \;
echo "" > ~/.local/share/recently-used.xbel \;
