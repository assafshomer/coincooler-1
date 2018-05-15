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
    - visit [this link](https://www.raspberrypi.org/downloads/raspbian/) to find the SHA-256 hash and verify that you downloaded the correct package by running
    - `echo "the-expected-hash yyyy-mm-dd-raspbian-stretch.zip" | shasum -a 256 -c -`
    - For example, if you downloaded the file "2018-04-18-raspbian-stretch.zip" and the expected sha-256 hash, as it appears on raspberrypi.org website, is "0e2922e551a895b136f2ea83d1bc0ca71e016e6d50244ba3da52bd764df5d1b6" then you should be running `echo "0e2922e551a895b136f2ea83d1bc0ca71e016e6d50244ba3da52bd764df5d1b6  2018-04-18-raspbian-stretch.zip" | shasum -a 256 -c -`
    - If all is well you should see that this is the correct hash.
    - Now, unzip the file
    - `unzip yyyy-mm-dd-raspbian-stretch.zip`
    - Now stick a 16gb sd card into your laptop (usually using a dedicated connector)
    - We need to find out the name of the sd card, so run
    - `sudo diskutil list | grep external`
    - 

- Power your Pi on and open a terminal window
- Make sure it is connected to the internet
- Insert a formatted USB stick (formatted to "MS DOS (FAT)"). Required for the tests after installation
- visit https://gist.github.com/assafshomer/32fe98096e52c176e5dfbbf1dd92d2bf and follow instructions
