DESCRIPTION = "First step bootloader for S+ SoCs"
SUMMARY = "XBoot Bootloader"
SECTION = "bootloaders"
PROVIDES = "virtual/bootloader"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_HOST = "(arm).*-linux"
COMPATIBLE_MACHINE = "(sp7021-arm5)"

SRC_URI += "file://Makefile.autoc.patch"

S = "${WORKDIR}/xboot"

inherit xboot autotools deploy

HOST_CC_ARCH=""

EXTRA_OEMAKE = " MKIMAGE=${WORKDIR}/recipe-sysroot-native/usr/bin/mkimage"

do_configure() {
 rm -rf ${S}/tools/auto_config_h
 rm -rf ${S}/tools/auto_config/auto_config_h
 unset i j
 for k in ${XBOOTX_MACHIN}; do
   i=$(expr $i + 1);
   for c in ${XBOOTX_CONFIG}; do
      j=$(expr $j + 1);
      if [ $i -ne $j ]; then  continue;  fi;
      echo "k:${k} c:${c} ${B}"
      install -d ${B}/${k}/
      install ${S}/configs/${c} ${B}/${k}/.config
   done;
   unset j;
 done;
}

do_compile() {
 unset i j
 for k in ${XBOOTX_MACHIN}; do
   i=$(expr $i + 1);
   for c in ${XBOOTX_CONFIG}; do
      j=$(expr $j + 1);
      if [ $i -ne $j ]; then  continue;  fi;
      echo "k:${k} c:${c} ${B}"
      oe_runmake -C ${S} O=${B}/${k}/
   done;
   unset j;
 done;
}

do_install() {
 unset i j
 for k in ${XBOOTX_MACHIN}; do
   i=$(expr $i + 1);
   for c in ${XBOOTX_CONFIG}; do
      j=$(expr $j + 1);
      if [ $i -ne $j ]; then  continue;  fi;
      echo "k:${k} c:${c} ${B}"
      install -m0644 ${B}/${k}/bin/xboot.bin ${B}/${k}/bin/xboot.sig
      ${WORKDIR}/recipe-sysroot-native/sp_tools/secure_sign/gen_signature.sh ${B}/${k}/bin/ xboot.sig 0
      ${S}/add_xhdr.sh ${B}/${k}/bin/xboot.sig ${B}/${k}/bin/xboot.img 1
      oe_runmake -C ${S} O=${B}/${k}/ size_check
      install -m0644 ${B}/${k}/bin/xboot.img ${D}/${PN}-${k}.img
   done;
   unset j;
 done;
}

do_deploy() {
 unset i j
 for k in ${XBOOTX_MACHIN}; do
   i=$(expr $i + 1);
   for c in ${XBOOTX_CONFIG}; do
      j=$(expr $j + 1);
      if [ $i -ne $j ]; then  continue;  fi;
      echo "k:${k} c:${c} ${B}"
      ls -l ${D}/${PN}-${k}.img
      install -m0644 ${D}/${PN}-${k}.img ${DEPLOY_DIR_IMAGE}/${PN}-${k}.img
   done;
   unset j;
 done;
}

FILES:${PN} += "*"

addtask deploy before do_build after do_install

DEPENDS += "xboot-helpers-native"
DEPENDS += "vim-native"
DEPENDS += "isp-native"
# this has to be u-boot-SP mkimage
DEPENDS += "u-boot-mkimage-native"
