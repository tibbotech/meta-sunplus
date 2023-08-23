
#PREFERRED_PROVIDER_virtual/bootloader = "u-boot-sp"
#PREFERRED_PROVIDER_u-boot = "u-boot-sp"
#PREFERRED_PROVIDER_u-boot-mkimage-native="u-boot-sp-tools-native"
#PREFERRED_PROVIDER_u-boot-mkenvimage-native="u-boot-sp-tools-native"
#PREFERRED_PROVIDER_u-boot-tools = "u-boot-sp-tools"
#PREFERRED_PROVIDER_u-boot-tools-native = "u-boot-sp-tools-native"

uboot_v = "sp"
PREFERRED_VERSION_u-boot-fw-utils = "${uboot_v}"
PREFERRED_VERSION_u-boot-tools = "${uboot_v}"
PREFERRED_VERSION_u-boot-tools-native = "${uboot_v}"
PREFERRED_VERSION_u-boot = "${uboot_v}"

PREFERRED_PROVIDER_virtual/kernel = "linux-sp"
