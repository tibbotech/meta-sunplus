FILESEXTRAPATHS:prepend := "${THISDIR}/linux-sp-5.10:"

SUMMARY = "Linux kernel (SunPlus,pub)"

COMPATIBLE_MACHINE = "(sp7021|sp7021-arm5)"

LINUX_VERSION = "5.10.59"
LINUX_VERSION_EXTENSION ?= "-sp-${LINUX_KERNEL_TYPE}"

# may be moved to /machine/ config
KMACHINE = "pentagram"

#KBRANCH:tppg2 = "kernel_5.10"
KBRANCH = "kernel_5.10"

#SRC_URI = "git://git@113.196.136.131:22/qac628/linux/kernel;protocol=ssh;name=machine;branch=${KBRANCH}"
SRC_URI = "git://github.com/tibbotech/plus1_kernel.git;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://kmeta;type=kmeta;name=kmeta;destsuffix=kmeta"
#SRC_URI += "file://kernel-meta.tar.gz;type=kmeta;name=meta;destsuffix=${KMETA}"
#SRC_URI += "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-4.19;destsuffix=${KMETA}"

# 4.19
#SRCREV_machine:tppg2 = "e81c7196d43ee83e0c05a9ac666cfe7a5fbd2ce9"
SRCREV_machine = "e81c7196d43ee83e0c05a9ac666cfe7a5fbd2ce9"
# 5.10
#SRCREV_machine:tppg2 = "dce567f1625d423253d11560aa4b88da7a6bf15e"
SRCREV_machine = "dce567f1625d423253d11560aa4b88da7a6bf15e"

# temporary it is the copy
SRCREV = "dce567f1625d423253d11560aa4b88da7a6bf15e"

# if using meta from master
#SRCREV_meta ?= "cebe198870d781829bd997a188cc34d9f7a61023"

#LINUX_KERNEL_TYPE = "debug"

MIRRORS=""
PREMIRRORS=""

KMETA="kernel-meta"

#SRC_URI += "file://pinctrl_dbg/sppctl.c.err.patch"
#SRC_URI += "file://pinctrl_dbg/sp7021_gpio_ops.c.Fdbg.patch"
#SRC_URI += "file://pinctrl_dbg/sppctl_gpio_ops.c.idbg.patch"
#SRC_URI += "file://pinctrl_dbg/sppctl_gpio_ops.c.irq.patch"
#SRC_URI += "file://pinctrl_dbg/pins.newdbg.patch"

# SDIO debug
#SRC_URI += "file://sdio_dbg/spsdv2.c.err.patch"
#SRC_URI += "file://sdio_dbg/spsdv2.c.inf.patch"

# FB patch
#SRC_URI += "file://video/fb_sp7021_main.c.set.patch"

# 485 test
SRC_URI += "file://uart_485/sp_uart.c.sleep1.patch"

do_deploy:append() {
 dd="${DEPLOYDIR}"
 if [ -n "${KERNEL_DEPLOYSUBDIR}" ]; then
   dd="${DEPLOYDIR}/${KERNEL_DEPLOYSUBDIR}"
 fi;
 echo "dv kern deploy:${KERNEL_IMAGE_NAME} - ${KERNEL_IMAGE_LINK_NAME} i: ${INITRAMFS_NAME} - ${INITRAMFS_LINK_NAME}"
 for imgType in ${KERNEL_IMAGETYPES} ; do
    echo "dv img type: ${imgType}"
    fn="${imgType}-${KERNEL_IMAGE_NAME}"
    if [ -f "${dd}/${fn}.bin" ]; then
      echo "dv0 : ${dd}/${fn}.bin"
      install ${dd}/${fn}.bin ${dd}/${fn}.img
      ${STAGING_DIR_NATIVE}/sp_tools/secure_sign/gen_signature.sh ${dd} ${fn}.img 1
      ln -sf ${fn}.img ${dd}/${imgType}-${KERNEL_IMAGE_LINK_NAME}.img
    fi;
    fn="${imgType}-${INITRAMFS_NAME}"
    if [ -f "${dd}/${fn}.bin" ]; then
      echo "dv1 : ${dd}/${fn}.bin"
      install ${dd}/${fn}.bin ${dd}/${fn}.img
      ${STAGING_DIR_NATIVE}/sp_tools/secure_sign/gen_signature.sh ${dd} ${fn}.img 1
      ln -sf ${fn}.img ${dd}/${imgType}-${INITRAMFS_LINK_NAME}.img
    fi;
 done;
}

#KBUILD_DEFCONFIG="pentagram_sc7021_achip_emu_defconfig"
#KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} pentagram_sc7021_achip_emu_defconfig"
#KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} defconfig"

DEPENDS += "isp-native"
