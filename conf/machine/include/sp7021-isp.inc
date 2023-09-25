
IMAGE_FSTYPES += "tar.bz2 ext4 squashfs ubi"
UBI_VOLNAME="rootfs"
# 
# -m is min io unit
# -s is sub-page-size (flash can support smaller blocks - subpages)
# -p is PEB (x*1024)
# -e is LEB size = PEB size - EC - VID
# -c is maximum ubi volume size (for auto-resize)
# calcs: http://www.linux-mtd.infradead.org/faq/ubi.html#L_ubi_mkimg
#MKUBIFS_ARGS = "-F -m 2048 -e 126976 -c 4036"
# 2030 is for 2G NAND
#MKUBIFS_ARGS = "-F -m 2048 -e 126976 -c 2030 -x zlib"
#MKUBIFS_ARGS = "-F -m 2048 -e 126976 -c 2030"
MKUBIFS_ARGS = "-F -m 2048 -e 126976 -c 4060"
#UBINIZE_ARGS = "-m 2048 -p 128KiB -s 2048"
UBINIZE_ARGS = "-m 2048 -p 124KiB -s 2048"

# SDcard image
IMAGE_FSTYPES += "wic wic.bz2"
WKS_FILE ?= "sd.sunplus.wks"
WIC_CREATE_EXTRA_ARGS ?= "--no-fstab-update"

KERNEL_IMAGETYPE = "uImage"
KERNEL_DEVICETREE = ""
KERNEL_DEVICETREE += "sp7021-ltpp3g2revD.dtb"
KERNEL_DEVICETREE += "sp7021-dsx.dtb"
KERNEL_DEVICETREE += "sp7021-ev.dtb"
KERNEL_DEVICETREE += "sp7021-bpi-f2p.dtb"
KERNEL_DEVICETREE += "sp7021-bpi-f2s.dtb"
KERNEL_DEVICETREE += "sp7021-demov2.dtb"
KERNEL_DEVICETREE += "sp7021-demov3.dtb"
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

UBOOT_CONFIG ??= "a7021_emmc a7021_nand a7021_romt a7021_ppg2 a7021_dsxe"
#UBOOT_CONFIG ??= "a7021_emmc a7021_ppg2 a7021_dsxe"
#UBOOT_CONFIG ??= "tppg2"
#UBOOT_CONFIG[tppg2] = "pentagram_sp7021_emmc_defconfig"
UBOOT_CONFIG[a7021_emmc] = "sp7021_emmc_c_defconfig"
UBOOT_CONFIG[a7021_nand] = "sp7021_nand_c_defconfig"
UBOOT_CONFIG[a7021_romt] = "sp7021_romter_c_defconfig"
UBOOT_CONFIG[a7021_ppg2] = "sp7021_tppg2_defconfig"
UBOOT_CONFIG[a7021_dsxe] = "sp7021_dsxe_defconfig"
UBOOT_ENTRYPOINT = "0x00308000"
UBOOT_LOADADDRESS = "0x00308000"

IMAGE_BOOT_FILES  = "u-boot.bin-a7021_emmc.img;u-boot.img"
IMAGE_BOOT_FILES += "sdcard_uEnv.txt;uEnv.txt"
#IMAGE_BOOT_FILES += "a926.img"
IMAGE_BOOT_FILES += "${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.img;${KERNEL_IMAGETYPE}"
#IMAGE_BOOT_FILES += "ISPBOOOT.BIN"
# move this
IMAGE_BOOT_FILES += "sp7021-ltpp3g2-empty.dtb;dtb"

# new for ISP
IMAGE_CLASSES += "isp_image"
IMAGE_FSTYPES += "isp"

IMAGE_TYPEDEP:isp += "ext4"

# ISPBOOOT.BIN for EMMC
ISP_CONFIG += "emmc0"

ISP_BOOTYP[emmc0] = "emmc"

ISP_SETBOO[emmc0] += "../${SOC_B}/xboot-emmc.img;0x0"
ISP_SETBOO[emmc0] += "u-boot.bin-a7021_ppg2.img;0x10000"

ISP_CONFIG[emmc0] += "xboot1;../${SOC_B}/xboot-emmc.img"
ISP_CONFIG[emmc0] += "uboot1;u-boot.bin-a7021_ppg2.img"
ISP_CONFIG[emmc0] += "uboot2;u-boot.bin-a7021_ppg2.img"
ISP_CONFIG[emmc0] += "env;"
ISP_CONFIG[emmc0] += "env_redund;"
ISP_CONFIG[emmc0] += "nonos;../${SOC_B}/a926-empty.img"
ISP_CONFIG[emmc0] += "dtb;${ISP_VAR_DTB}"
ISP_CONFIG[emmc0] += "kernel;${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.img"
ISP_CONFIG[emmc0] += "rootfs;${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.ext4"

ISP_EMMCOF[emmc0] += "uboot1;0x22"
ISP_EMMCOF[emmc0] += "uboot2;0x822"
ISP_EMMCOF[emmc0] += "env;0x1022"
ISP_EMMCOF[emmc0] += "env_redund;0x1422"
ISP_EMMCOF[emmc0] += "nonos;0x1822"
ISP_EMMCOF[emmc0] += "dtb;0x2022"
ISP_EMMCOF[emmc0] += "kernel;0x2222"
ISP_EMMCOF[emmc0] += "rootfs;0x12222"

# ISPBOOOT.BIN for SD-bootable image (xboot only, should be 64K)
ISP_CONFIG += "sdboo"
ISP_BOOTYP[sdboo] = "none"
ISP_CONFIG[sdboo] += "part0;-;-"
ISP_SETBOO[sdboo] += "../${SOC_B}/xboot-emmc.img;0x0"

IMAGE_TYPEDEP:isp += "ubi"

# ISPBOOOT.BIN for NAND
ISP_CONFIG += "nand0"

ISP_BOOTYP[nand0] = "nand"

ISP_SETBOO[nand0] += "../${SOC_B}/xboot-nand.img;0x0"
ISP_SETBOO[nand0] += "u-boot.bin-a7021_nand.img;0x10000"

ISP_CONFIG[nand0] += "xboot1;../${SOC_B}/xboot-nand.img"
ISP_CONFIG[nand0] += "uboot1;u-boot.bin-a7021_nand.img"
ISP_CONFIG[nand0] += "uboot2;u-boot.bin-a7021_nand.img"
ISP_CONFIG[nand0] += "env;"
ISP_CONFIG[nand0] += "env_redund;"
ISP_CONFIG[nand0] += "nonos;../${SOC_B}/a926-empty.img"
ISP_CONFIG[nand0] += "dtb;${ISP_VAR_DTB}"
ISP_CONFIG[nand0] += "kernel;${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.img"
ISP_CONFIG[nand0] += "rootfs;${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.ubi"

ISP_PFLAGS[nand0] += "xboot1;0x5"
ISP_PFLAGS[nand0] += "uboot1;0x5"
ISP_PFLAGS[nand0] += "uboot2;0x3"

ISP_NANDOF[nand0] += "env_redund;0x80000"
ISP_NANDOF[nand0] += "nonos;0x100000"
ISP_NANDOF[nand0] += "dtb;0x200000"
ISP_NANDOF[nand0] += "kernel;0x240000"
ISP_NANDOF[nand0] += "rootfs;0x2240000"
