DESCRIPTION = "SunPlus OP-TEE OS"
SUMMARY = "SunPlus OP-TEE OS"
HOMEPAGE = "https://www.sunplus.com/"
SECTION = "devel"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"
COMPATIBLE_MACHINE = "(sp7021|sp7350|q645)"

SRCREV = "a85b42444e8f91d1cd655edfd035872092970ccc"

#SRC_URI  = "git://git@113.196.136.131:22/qac628/optee;protocol=ssh;branch=master;"
SRC_URI  = "git://github.com/tibbotech/plus1_optee.git;protocol=https;branch=master;"
SRC_URI += "file://conf.mk.patch"
SRC_URI += "file://platform_config.h.patch"

inherit deploy python3native autotools features_check

REQUIRED_MACHINE_FEATURES = "optee"

S = "${WORKDIR}/git/optee_os"
B = "${WORKDIR}/build.${PLATFORM_FLAVOR}"

# The platform flavor corresponds to the Yocto machine without the leading 'i'.
PLATFORM_FLAVOR                   = "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR:q645              = "q645"
PLATFORM_FLAVOR:sp7350            = "sp7350"
PLATFORM_FLAVOR:sp7021            = "sp7021"

OPTEE_ARCH:arm     = "arm32"
OPTEE_ARCH:aarch64 = "arm64"

OPTEE_CORE_LOG_LEVEL ?= "1"
OPTEE_TA_LOG_LEVEL ?= "0"

# Optee-os can be built for 32 bits and 64 bits at the same time
# as long as the compilers are correctly defined.
# For 64bits, CROSS_COMPILE64 must be set
# When defining CROSS_COMPILE and CROSS_COMPILE64, we assure that
# any 32 or 64 bits builds will pass
EXTRA_OEMAKE = " \
    PLATFORM=sp \
    PLATFORM_FLAVOR=${PLATFORM_FLAVOR} \
    CROSS_COMPILE=${HOST_PREFIX} \
    CROSS_COMPILE64=${HOST_PREFIX} \
    CFG_WERROR=y \
    CFG_TEE_TA_LOG_LEVEL=${OPTEE_TA_LOG_LEVEL} \
    CFG_TEE_CORE_LOG_LEVEL=${OPTEE_CORE_LOG_LEVEL} \
    OPENSSL_MODULES=${STAGING_LIBDIR_NATIVE}/ossl-modules \
    -C ${S} O=${B} \
"

do_compile() {
    unset LDFLAGS
    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"
    oe_runmake all
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/
    install -m 644 ${B}/core/*.bin ${D}${nonarch_base_libdir}/firmware/

    # Install the TA devkit
    install -d ${D}${includedir}/optee/export-user_ta/

    for f in ${B}/export-ta_${OPTEE_ARCH}/*; do
        cp -aR $f ${D}${includedir}/optee/export-user_ta/
    done

    install -d ${D}${includedir}/optee/export-user_ta_${OPTEE_ARCH}/
    cp -aR ${B}/export-ta_${OPTEE_ARCH}/* \
        ${D}${includedir}/optee/export-user_ta_${OPTEE_ARCH}/
}

do_deploy() {
    install -d ${DEPLOYDIR}/optee
    install -m 644 ${D}${nonarch_base_libdir}/firmware/* ${DEPLOYDIR}/optee/
}

addtask deploy before do_build after do_install

FILES:${PN} = "${nonarch_base_libdir}/firmware/ ${nonarch_base_libdir}/optee_armtz/"
FILES:${PN}-staticdev = "${includedir}/optee/"
RDEPENDS:${PN}-dev += "${PN}-staticdev"
DEPENDS = "python3-pycryptodome-native python3-pyelftools-native python3-pycryptodomex-native dtc-native"

PACKAGE_ARCH = "${MACHINE_ARCH}"
