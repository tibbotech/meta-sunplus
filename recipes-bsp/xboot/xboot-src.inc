
HOMEPAGE = "https://www.sunplus.com/"
SECTION = "bootloaders"
LICENSE = "GPL-3.0-or-later"

SRCREV_FORMAT="draminit_xboot"

SRCREV_draminit = "f79fba1c057e702bce084cb29df5cd2064903dd9"
SRCREV_xboot = "512282fcc0f290018862939f2b07bdaee1d04e7e"

SRC_URI = "\
git://github.com/tibbotech/plus1_draminit.git;protocol=https;name=draminit;branch=master;destsuffix=draminit; \
git://github.com/tibbotech/plus1_xboot.git;protocol=https;name=xboot;branch=master;destsuffix=xboot; \
"
#SRC_URI = "\
#git://git@113.196.136.131:22/qac628/boot/draminit;protocol=ssh;name=draminit;branch=master;destsuffix=draminit; \
#git://git@113.196.136.131:22/qac628/boot/xboot;protocol=ssh;name=xboot;branch=master;destsuffix=xboot; \
#"


MIRRORS=""
PREMIRRORS=""
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_SYSROOT_STRIP="1"

LIC_FILES_CHKSUM = "file://${FILESDIR_sunplus}/common-licenses/GPL-3.0-or-later;md5=1c76c4cc354acaac30ed4d5eefea7245"
