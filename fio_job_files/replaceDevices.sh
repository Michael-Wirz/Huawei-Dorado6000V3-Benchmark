#!/bin/bash
######################################################
# dbi services michael.wirz@dbi-services.com
# Vesion: 1.0
#
# usage: ./replaceDevices.sh
#
# todo before use: modify newname01-newname10 with 
#                  the name of your devices
#
#
######################################################


sed -i -e 's_/dev/mapper/device01_/dev/mapper/newname01_g' *.fio
sed -i -e 's_/dev/mapper/device02_/dev/mapper/newname02_g' *.fio
sed -i -e 's_/dev/mapper/device03_/dev/mapper/newname03_g' *.fio
sed -i -e 's_/dev/mapper/device04_/dev/mapper/newname04_g' *.fio
sed -i -e 's_/dev/mapper/device05_/dev/mapper/newname05_g' *.fio
sed -i -e 's_/dev/mapper/device06_/dev/mapper/newname06_g' *.fio
sed -i -e 's_/dev/mapper/device07_/dev/mapper/newname07_g' *.fio
sed -i -e 's_/dev/mapper/device08_/dev/mapper/newname08_g' *.fio
sed -i -e 's_/dev/mapper/device09_/dev/mapper/newname09_g' *.fio
sed -i -e 's_/dev/mapper/device10_/dev/mapper/newname10_g' *.fio
