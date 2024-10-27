DESCRIPTION = "Image assembly helper makefile for SP7021 SoCs"
SUMMARY = "Image scripts"
HOMEPAGE = "https://tibbo.com/"
SECTION = "devel"
LICENSE = "GPL-3.0-or-later"

SRCREV="${AUTOREV}"

SRC_URI  = "git://github.com/tibbotech/spmake.git;protocol=https;branch=main"

S="${WORKDIR}/git"

inherit deploy

do_deploy() {
 echo "DV3:${DEPLOYDIR}"
 install -p -m0644 ${S}/sp_make*.mk ${DEPLOYDIR}/
}

addtask do_deploy after do_compile before do_build

BBCLASSEXTEND = "native"

RDEPENDS:${PN}:class-native += "vim-native"
RDEPENDS:${PN}:class-native += "u-boot-tools-native"
RDEPENDS:${PN}:class-native += "xboot-tools-native"

LIC_FILES_CHKSUM = "file://${FILESDIR_sunplus}/common-licenses/GPL-3.0-or-later;md5=1c76c4cc354acaac30ed4d5eefea7245"
