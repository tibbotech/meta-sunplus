FILESEXTRAPATHS:prepend := "${THISDIR}/linux-sp-5.10:"

SUMMARY = "Linux kernel (SunPlus,pub)"

LINUX_VERSION = "5.10.201"

#KBRANCH:tppg2 = "kernel_5.10.201"
#KBRANCH = "kernel_5.10.201"
KBRANCH = "master"

#SRC_URI = "git://git@113.196.136.131:22/qac628/linux/kernel;protocol=ssh;name=machine;branch=${KBRANCH}"
SRC_URI = "git://github.com/tibbotech/plus1_kernel.git;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://kmeta;type=kmeta;name=kmeta;destsuffix=kmeta"
#SRC_URI += "file://kernel-meta.tar.gz;type=kmeta;name=meta;destsuffix=${KMETA}"
#SRC_URI += "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-4.19;destsuffix=${KMETA}"

# 5.10
#SRCREV_machine:tppg2 = "dd778e471d406adc47f3713b4e803d6e34948df1"
SRCREV_machine = "1adee32390473cd078b6e29a2871175c04a83c1a"

# temporary it is the copy
SRCREV = "1adee32390473cd078b6e29a2871175c04a83c1a"

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

# 485 test
SRC_URI += "file://uart_485/sunplus-uart.c.sleep1.patch"

# no TPM device by default for sp7021 BPI F2P (fails after 5 min if no device)
SRC_URI += "file://sp7021-bpi-f2p.dts.noTPM.patch"
