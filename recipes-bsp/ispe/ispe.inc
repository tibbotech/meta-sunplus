DESCRIPTION = "ISP (ISPBOOOT.BIN) Image Editor"
SUMMARY = "ISPEditor"
HOMEPAGE = "https://www.tibbo.com/"
SECTION = "devel"
LICENSE = "GPLv3+"

inherit deploy autotools autotools-brokensep

S="${WORKDIR}/git"

do_install() {
# oe_runmake 'DESTDIR=${D}/${base_prefix}' install
 oe_runmake 'DESTDIR=${D}/${bindir}' install
}

#addtask do_deploy after do_compile before do_build

#do_configure[noexec] = "1"

BBCLASSEXTEND = "native"

#SYSROOT_DIRS_NATIVE += "${base_prefix}/sp_tools"

DEPENDS += "openssl"
RDEPENDS:${PN} += "bash"
RDEPENDS:${PN} += "u-boot-tools"

LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
