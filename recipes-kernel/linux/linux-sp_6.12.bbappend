FILESEXTRAPATHS:prepend := "${THISDIR}/linux-sp-6.12:"

SUMMARY = "Linux kernel (kernel.org,pub)"

LINUX_VERSION = "6.12.60"

##KBRANCH:tppg2 = "kernel_5.10.201"
##KBRANCH = "kernel_5.10.201"
#KBRANCH = "master"

SRC_URI = "git://git.yoctoproject.org/linux-yocto.git;name=machine;branch=${KBRANCH};protocol=https"
SRC_URI += "file://kmeta;type=kmeta;name=kmeta;destsuffix=kmeta"
#SRC_URI += "file://kernel-meta.tar.gz;type=kmeta;name=meta;destsuffix=${KMETA}"
#SRC_URI += "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-4.19;destsuffix=${KMETA}"

# 5.10
#SRCREV_machine:sp7021 = "cd2fe60ac1c07ad28e3c84e4325c3f8163ce3719"
SRCREV_machine = "cd2fe60ac1c07ad28e3c84e4325c3f8163ce3719"

# temporary it is the copy
SRCREV = "\cd2fe60ac1c07ad28e3c84e4325c3f8163ce3719"

# if using meta from master
#SRCREV_meta ?= "cebe198870d781829bd997a188cc34d9f7a61023"

#LINUX_KERNEL_TYPE = "debug"

MIRRORS=""
PREMIRRORS=""

#SRC_URI += "file://pinctrl_dbg/sppctl.c.err.patch"
#SRC_URI += "file://pinctrl_dbg/sp7021_gpio_ops.c.Fdbg.patch"
#SRC_URI += "file://pinctrl_dbg/sppctl_gpio_ops.c.idbg.patch"
#SRC_URI += "file://pinctrl_dbg/sppctl_gpio_ops.c.irq.patch"
#SRC_URI += "file://pinctrl_dbg/pins.newdbg.patch"

# SDIO debug
#SRC_URI += "file://sdio_dbg/spsdv2.c.err.patch"
#SRC_URI += "file://sdio_dbg/spsdv2.c.inf.patch"

# FB patch
#SRC_URI += "file://video/fb_sp7021_main.c.set.patch"

## 485 test
#SRC_URI += "file://uart_485/sunplus-uart.c.sleep1.patch"

KERNEL_DTS_SUBDIR = "sunplus/"

SRC_URI += "file://dts/sp7021-ltpp3g2revD.dtsi.patch"
SRC_URI += "file://dts/sp7021-ltpp3g2revD.dts.patch"
SRC_URI += "file://dts/sp7021-ev.dts.patch"
SRC_URI += "file://dts/sp7021-bpi-f2p.dts.patch"
SRC_URI += "file://dts/sp7021-bpi-f2s.dts.patch"
SRC_URI += "file://dts/sp7021-demov2.dts.patch"
SRC_URI += "file://dts/sp7021-demov3.dts.patch"
