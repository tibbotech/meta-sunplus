DESCRIPTION = "Package group for SunPlus xBoot"
SUMMARY = "Pre-U-Boot bootloader xBoot is started by the ROM code on secondary a926 CPU"

inherit packagegroup

RDEPENDS:${PN}  = "xboot-nand"
RDEPENDS:${PN} += "xboot-emmc"
RDEPENDS:${PN} += "xboot-emmc-us"
RDEPENDS:${PN} += "xboot-emmc-sd"
