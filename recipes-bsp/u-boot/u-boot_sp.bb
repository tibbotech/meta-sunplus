# copy of meta/recipes-bsp/u-boot/u-boot_2021.07.bb with
# -src instead of -common

require u-boot-sp-src.inc
require u-boot.inc

PROVIDES += "u-boot"
DEPENDS += "bc-native dtc-native python3-setuptools-native"
