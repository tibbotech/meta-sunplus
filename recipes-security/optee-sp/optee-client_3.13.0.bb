DESCRIPTION = "SunPlus OP-TEE OS Client libs"
SUMMARY = "SunPlus OP-TEE OS Client libs"
HOMEPAGE = "https://www.sunplus.com/"
SECTION = "devel"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=69663ab153298557a59c67a60a743e5b"

SRCREV = "a85b42444e8f91d1cd655edfd035872092970ccc"

#SRC_URI  = "git://git@113.196.136.131:22/qac628/optee;protocol=ssh;branch=master;"
SRC_URI  = "git://github.com/tibbotech/plus1_optee.git;protocol=https;branch=master;"
SRC_URI += "file://tee-supplicant.service"

inherit python3native systemd

REQUIRED_MACHINE_FEATURES = "optee"

S = "${WORKDIR}/git/optee_client"
B = "${WORKDIR}/build"

EXTRA_OEMAKE = "ARCH=${OPTEE_ARCH} O=${B}"

do_install () {
	oe_runmake -C ${S} install

	install -d ${D}${libdir}/
	install -p -m0644 ${B}/export${libdir}/libteec.so.1.0.0 ${D}${libdir}/
	ln -sf libteec.so.1.0.0 ${D}${libdir}/libteec.so.1.0
	ln -sf libteec.so.1.0.0 ${D}${libdir}/libteec.so.1
	ln -sf libteec.so.1 ${D}${libdir}/libteec.so

	install -D -p -m0644 ${B}/export/usr/lib/libckteec.so.0.1.0 ${D}${libdir}/libckteec.so.0.1.0
	ln -sf libckteec.so.0.1.0 ${D}${libdir}/libckteec.so.0.1
	ln -sf libckteec.so.0.1.0 ${D}${libdir}/libckteec.so.0
	ln -sf libckteec.so.0.1.0 ${D}${libdir}/libckteec.so

	install -D -p -m0755 ${B}/export/usr/sbin/tee-supplicant ${D}${bindir}/tee-supplicant

	cp -a ${B}/export/usr/include ${D}${includedir}

	install -d ${D}${systemd_system_unitdir}/
	install -m0644 ${WORKDIR}/tee-supplicant.service ${D}${systemd_system_unitdir}/
	sed -i -e s:/etc:${sysconfdir}:g -e s:/usr/bin:${bindir}:g ${D}${systemd_system_unitdir}/tee-supplicant.service
}

SYSTEMD_SERVICE:${PN} = "tee-supplicant.service"

FILES:${PN} += "${libdir}/* ${includedir}/*"

INSANE_SKIP:${PN} = "ldflags dev-elf"
INSANE_SKIP:${PN}-dev = "ldflags dev-elf"
