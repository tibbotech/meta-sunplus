
require u-boot-sp-src.inc

inherit deploy

# need to overwrite for Scarthgap case no capsule there
do_install () {
	install -d ${D}${bindir}

	# mkimage
	install -m 0755 tools/mkimage ${D}${bindir}/uboot-mkimage
	ln -sf uboot-mkimage ${D}${bindir}/mkimage

	# mkenvimage
	install -m 0755 tools/mkenvimage ${D}${bindir}/uboot-mkenvimage
	ln -sf uboot-mkenvimage ${D}${bindir}/mkenvimage

	# dumpimage
	install -m 0755 tools/dumpimage ${D}${bindir}/uboot-dumpimage
	ln -sf uboot-dumpimage ${D}${bindir}/dumpimage

	# fit_check_sign
	install -m 0755 tools/fit_check_sign ${D}${bindir}/uboot-fit_check_sign
	ln -sf uboot-fit_check_sign ${D}${bindir}/fit_check_sign

	# mkeficapsule
#	install -m 0755 tools/mkeficapsule ${D}${bindir}/uboot-mkeficapsule
#	ln -sf uboot-mkeficapsule ${D}${bindir}/mkeficapsule
}


do_deploy() {
 install -d ${DEPLOYDIR}/sp_tools/
 install -p -m0755 ${B}/tools/mkimage ${DEPLOYDIR}/sp_tools/
}

addtask do_deploy after do_compile before do_build
