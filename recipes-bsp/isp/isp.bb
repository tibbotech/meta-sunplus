
SRCREV = "48a0a8c6b880a30d27d3a4953777b34efc53a489"

#SRC_URI  = "git://git@113.196.136.131:22/qac628/build;protocol=ssh;branch=master;"
SRC_URI  = "git://github.com/tibbotech/plus1_isp.git;protocol=https;branch=master"
SRC_URI += "file://uEnv.txt.sdcard2.patch"

require isp.inc
