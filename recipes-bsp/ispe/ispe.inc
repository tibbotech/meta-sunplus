DESCRIPTION = "ISP (ISPBOOOT.BIN) Image Editor"
SUMMARY = "ISPEditor"
HOMEPAGE = "https://www.tibbo.com/"
MAINTAINER = "Dmitry Dvorkin <dvorkin@tibbo.com>"
SECTION = "devel"
LICENSE = "GPL-3.0-or-later"

inherit deploy autotools autotools-brokensep

SRC_URI = "git://github.com/tibbotech/ispe.git;protocol=https;branch=main"

S="${WORKDIR}/git"

do_install() {
 oe_runmake 'DESTDIR=${D}/${bindir}' install
}

do_deploy() {
 oe_runmake 'DESTDIR=${DEPLOYDIR}' install
}

addtask do_deploy after do_compile before do_build

do_configure[noexec] = "1"

BBCLASSEXTEND = "native"

DEPENDS += "openssl"
RDEPENDS:${PN} += "bash"
RDEPENDS:${PN} += "u-boot-tools"

LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
