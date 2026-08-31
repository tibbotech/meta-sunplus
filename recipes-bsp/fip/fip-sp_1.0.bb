DESCRIPTION = "SunPlus OP-TEE FIP image"
SUMMARY = "SunPlus OP-TEE FIP image"
HOMEPAGE = "https://www.tibbo.com/"
SECTION = "devel"
LICENSE = "GPL-3.0-or-later"
COMPATIBLE_MACHINE = "^(sp7021|sp7053|q645)$"

inherit deploy

SRC_URI += "file://sp7021-optee.its.in"
SRC_URI += "file://sp7021-tfa.its.in"

def dv_parse_its(d,file_in,file_out):
    with open(file_in, "r") as f:
        content = f.read()

    expanded = d.expand(content)

    with open(file_out, "w") as f:
        f.write(expanded)
    return f"x"

def dv_find_its(d, dir):
    import os,glob
    globbed = glob.glob(dir, recursive=True)
    print( "globbed: %s" % globbed)
    return globbed

python do_configure () {
    files = dv_find_its(d, d.getVar( 'WORKDIR') + '/*.its.in')
    # print("xxx: %s" % files)
    for file in files:
        fileA0 = os.path.splitext(file)
        fileA1 = os.path.splitext(fileA0[0])
        x = fileA1[0] + '.its'
        print("ITS template:: %s -> %s" % (file, x))
        dv_parse_its(d, file, x)
}

do_compile() {
 install -d ${D}
 files=$(find ${WORKDIR} -name "*.its")
 for f in ${files}; do
   bf=$(basename -s .its ${f})
   f0="${WORKDIR}/${bf}.its"
   f1="${D}/${bf}.itb"
   echo "Building ${f1}..."
   ${WORKDIR}/recipe-sysroot-native/usr/bin/mkimage -v -f ${f0} ${f1}
 done
}

do_deploy() {
 install -d ${DEPLOYDIR}/${PN}/
 files=$(find ${WORKDIR}/image/ -name "*.itb")
 echo "file:${files}"
 for f in ${files}; do
   install -m 0644 ${f} ${DEPLOYDIR}/${PN}/
   echo "${f} to ${DEPLOYDIR}/${PN}/"
 done
}

addtask do_deploy after do_compile before do_build

DEPENDS += "u-boot-mkimage-native"
DEPENDS += "dtc-native"
do_compile[depends] += "virtual/kernel:do_deploy optee-os:do_deploy"

BBCLASSEXTEND = "native"

LIC_FILES_CHKSUM = "file://${FILESDIR_sunplus}/common-licenses/GPL-3.0-or-later;md5=1c76c4cc354acaac30ed4d5eefea7245"
