# CoinCooler
## Digital Bitcoin Cold Storage on a Raspberry Pi
## visit [*coincooler.com*](http://coincooler.com/)

# Testing
Insert a USB stick
- formatted to MS-DOS (FAT) (mac disk utility, Linux gparted or an equivalent windows tool)
- without spaces in the name. (E.g. "/media/CC-TEST", but not "Volumes/CC TEST")

# Installation on a Raspberry PI
- Get a Raspberry Pi
- Install Raspbian (if not already installed)
  - If you have no familiarity with the Raspberry Pi, visit [this link](https://www.raspberrypi.org/downloads/noobs/) where you can learn how to purchase a kit with a pre-installed NOOBS SD card which you can then plug into any Raspberry Pi and select to install the Raspbian operating system.
  - If you have some tech background you can also follow the follwoing instructions (given for mac but should be straightforwardly translatable to other environments as well):
    - `cd Downloads`
    - `wget --content-disposition https://downloads.raspberrypi.org/raspbian_latest`
    - Visit [this link](https://www.raspberrypi.org/downloads/raspbian/) to find the SHA-256 hash and verify that you downloaded the correct package by running
    - `echo "the-expected-hash yyyy-mm-dd-raspbian-stretch.zip" | shasum -a 256 -c -`
    - For example, if you downloaded the file "2018-04-18-raspbian-stretch.zip" and the expected sha-256 hash, as it appears on raspberrypi.org website, is "0e2922e551a895b136f2ea83d1bc0ca71e016e6d50244ba3da52bd764df5d1b6" then you should be running
    ```
      echo "0e2922e551a895b136f2ea83d1bc0ca71e016e6d50244ba3da52bd764df5d1b6  2018-04-18-raspbian-stretch.zip" | shasum -a 256 -c -
    ```
    - If all is well you should see that this is the correct hash.
    - Now, unzip the file
    - `unzip yyyy-mm-dd-raspbian-stretch.zip`
    - You should be left with a `unzip yyyy-mm-dd-raspbian-stretch.img` file in the same location
    - Now stick a 16gb sd card into your laptop (usually using a dedicated connector)
    - We need to find out the name of the sd card, so run
    - `sudo diskutil list | grep external`
    - The response should be something like `dev/disk2 (external, physical):`, which tells us that the name of our SD card is `dev/disk2`.
    - Now we copy the `unzip yyyy-mm-dd-raspbian-stretch.img` file onto the SD card
    - First unmount the SD card
    - `diskutil unmountDisk /dev/disk2`
    - Now copy
    - `sudo dd if=yyyy-mm-dd-raspbian-stretch.img | pv -s 5G | sudo dd of=/dev/disk2 bs=1m`
    - You may need to adjust the above to match the name of your specific image file, the size of the image file (so the above 5G is so that the process-bar matches the size of the actual file, this is a nice to have but not necessary), and the name of the sd card that was derived in the previous step. This step will take some time.
    - Finally, we need to enable wifi connection on the raspberrypi so to do that type
    - `nano /Volumes/boot/wpa_supplicant.conf`
    - Paste the following into the file (and ammend it appropriately by replacing your two letter country code, wifi network name and password)
    ```
      country=YOUR-TWO-LETTER-COUNTRY-CODE
      ctrl_interface=/var/run/wpa_supplicant GROUP=netdev
      update_config=1
      network={
         ssid="NAME_OF_YOUR_WIFI_NETWORK"
         psk="YOUR_WIFI_PASSWORD"
      }
    ```
  - hit CTRL+X to save the file
  - Unmount the SD card `diskutil unmountDisk /dev/disk2`
- Insert the SD card into your PI and power it on
- Connect the pi to the internet (if you followed the detailed instructions above it should be connected)
- Insert a formatted USB stick (formatted to "MS DOS (FAT)"). Required for the tests after installation
- Visit https://gist.github.com/assafshomer/32fe98096e52c176e5dfbbf1dd92d2bf and follow instructions, or:
  - Launch a terminal window and run the following command (takes about 15 minutes to run and should reboot when done)
  - `bash <(curl -s https://raw.githubusercontent.com/assafshomer/rpcc/master/config-rp/scripts/install-ruby.sh)`
  - After the reboot launch a new terminal window and run the following command (again, should take some time and end with a reboot)
  - `bash <(curl -s https://raw.githubusercontent.com/assafshomer/rpcc/master/config-rp/scripts/install-coincooler.sh)`
  - After this second reboot you should be done. Click on the CoinCooler desktop icon and wait for about 20 seconds for the application to start

# FAQ and Tutorials
- Visit [coincooler FAQ](http://www.coincooler.com/faq) and [coincooler Help](http://www.coincooler.com/help) pages
- Visit CoinCooler dedicated [YouTube channel](https://www.youtube.com/channel/UCfHCo_-YDaKQmc9qT8BVxGQ)
