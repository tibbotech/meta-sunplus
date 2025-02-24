FILESEXTRAPATHS:prepend := "${THISDIR}/linux-sp-5.10:"

SUMMARY = "Linux kernel (SunPlus,pub)"

COMPATIBLE_MACHINE = "(sp7021|sp7021-arm5)"

LINUX_VERSION = "5.10.59"
LINUX_VERSION_EXTENSION ?= "-sp-${LINUX_KERNEL_TYPE}"

# may be moved to /machine/ config
KMACHINE = "pentagram"

#KBRANCH:tppg2 = "kernel_5.10.59"
KBRANCH = "kernel_5.10.59"

#SRC_URI = "git://git@113.196.136.131:22/qac628/linux/kernel;protocol=ssh;name=machine;branch=${KBRANCH}"
SRC_URI = "git://github.com/tibbotech/plus1_kernel.git;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://kmeta;type=kmeta;name=kmeta;destsuffix=kmeta"
#SRC_URI += "file://kernel-meta.tar.gz;type=kmeta;name=meta;destsuffix=${KMETA}"
#SRC_URI += "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-4.19;destsuffix=${KMETA}"

# 5.10
#SRCREV_machine:tppg2 = "dd778e471d406adc47f3713b4e803d6e34948df1"
SRCREV_machine = "dd778e471d406adc47f3713b4e803d6e34948df1"

# temporary it is the copy
SRCREV = "dd778e471d406adc47f3713b4e803d6e34948df1"

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
SRC_URI += "file://uart_485/sunplus-uart.c.sleep1.patch"

# no TPM device by default for sp7021 BPI F2P (fails after 5 min if no device)
SRC_URI += "file://sp7021-bpi-f2p.dts.noTPM.patch"

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

KERNEL_FEATURES:append = "${@bb.utils.contains("MACHINE_FEATURES", "usbgadget", " bsp/pentagram/usb/usb_otg.scc features/usb/usb-gadgets.scc", "" ,d)}"
KERNEL_FEATURES:append = "${@bb.utils.contains('MACHINE_FEATURES', 'vfat', ' cfg/fs/vfat.scc', '', d)}"
KERNEL_FEATURES:append = "${@bb.utils.contains('MACHINE_FEATURES', 'alsa', ' bsp/pentagram/sound.scc', '', d)}"

DEPENDS += "isp-native"
