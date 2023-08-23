DESCRIPTION = "Package group for SunPlus bnoos"
SUMMARY = "Firmware started by U-boot on secondary a926 CPU"

inherit packagegroup

RDEPENDS:${PN}  = "bnoos"
# RDEPENDS:${PN} += "xboot-emmc"
