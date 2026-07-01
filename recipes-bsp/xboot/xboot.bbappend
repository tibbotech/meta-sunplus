
SRC_URI += "file://q628_Rev2_EMMC_defconfig.nonor.patch"
SRC_URI += "${@bb.utils.contains("MACHINE_FEATURES", "spsign", "", "file://q628_emmc_no_otp.patch",d)}"
SRC_URI += "${@bb.utils.contains("MACHINE_FEATURES", "spsign", "", "file://q628_nand_no_otp.patch",d)}"
SRC_URI += "${@bb.utils.contains("MACHINE_FEATURES", "spsign", "", "file://q628_emmc_no_key.patch",d)}"

#DESCRIPTION:append = " +MD press -> SD"
#
#do_configure:append() {
# echo "CONFIG_CUSTOM_BOOT_BTN=3" >> ${S}/.config
# echo "CONFIG_CUSTOM_BTN_DEV=SDCARD_ISP" >> ${S}/.config
#}

#DESCRIPTION:append = " +MD press -> USB"
#
#do_configure:append() {
# echo "CONFIG_CUSTOM_BOOT_BTN=3" >> ${S}/.config
# echo "CONFIG_CUSTOM_BTN_DEV=USB_ISP" >> ${S}/.config
#}
