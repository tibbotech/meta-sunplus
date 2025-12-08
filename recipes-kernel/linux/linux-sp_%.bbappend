
COMPATIBLE_MACHINE = "(sp7021|sp7021-arm5)"

LINUX_VERSION_EXTENSION ?= "-sp-${LINUX_KERNEL_TYPE}"

# may be moved to /machine/ config
KMACHINE = "pentagram"

KMETA="kernel-meta"

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

DEPENDS += "isp-native"

#KBUILD_DEFCONFIG="pentagram_sc7021_achip_emu_defconfig"
#KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} pentagram_sc7021_achip_emu_defconfig"
#KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} defconfig"

KERNEL_FEATURES:append = "${@bb.utils.contains("MACHINE_FEATURES", "usbgadget", " bsp/pentagram/usb/usb_otg.scc features/usb/usb-gadgets.scc", "" ,d)}"
KERNEL_FEATURES:append = "${@bb.utils.contains('MACHINE_FEATURES', 'vfat', ' cfg/fs/vfat.scc', '', d)}"
KERNEL_FEATURES:append = "${@bb.utils.contains('MACHINE_FEATURES', 'alsa', ' bsp/pentagram/sound.scc', '', d)}"
