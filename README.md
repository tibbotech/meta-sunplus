# SunPlus BSP OpenEmbedded Project Layer

SunPlus SoC producer (https://www.sunplus.com/)

## Dependances

https://git.openembedded.org/openembedded-core
    Core

## Description

SoCs supported: sp7021.

Contains:
- a926 Xboot;
- a926 FW sample (B-Chip);
- U-Boot;
- Kernel;
- ISPBOOOT.BIN assemble helper;
- base image files.

## Quick Start

```
OEBR=X
BBBR=Y

W=~/workspace/tibbo.${OEBR}.0/
install -d ${W}/layers
cd ${W}/layers/
git clone -b ${OEBR} https://git.openembedded.org/meta-openembedded
git clone -b ${OEBR} https://git.openembedded.org/openembedded-core
git clone https://github.com/tibbotech/meta-sunplus.git
git clone -b ${BBBR} https://git.openembedded.org/bitbake
cd ${W}
TEMPLATECONF=`pwd`/layers/meta-sunplus/conf/templates/sp7021 . layers/openembedded-core/oe-init-build-env ./build.sp7021
install -m 0644 ../layers/meta-sunplus/conf/templates/site.conf conf/
MACHINE=sp7021 bitbake mc:sp7021:core-image-minimal
```
, where:

BBBR=1.46, OEBR=dunfell

BBBR=2.0, OEBR=kirkstone

BBBR=2.8, OEBR=scarthgap

## Notes

Compatibility: Dunfell, Kirstone, Nanbield

For >= Nanbield:
```
PREFERRED_VERSION_linux-sp = "5.10%"
```
in any child layer.

## Build time and requirements

AMD Ryzen 7900, 64 GB RAM, SSD:
```
[dv@dvh1 build.sp7021]$ time MACHINE=sp7021 bitbake mc:sp7021:core-image-minimal
...
NOTE: Tasks Summary: Attempted 2671 tasks of which 663 didn't need to be rerun and all succeeded.

Summary: There were 6 WARNING messages shown.

real    11m51,863s
...
```
Build folder space:
```
[dv@dvh1 build.sunplus.dunfell.0]$ du -sh /disk2/build.sunplus.dunfell.0
21G     /disk2/build.sunplus.dunfell.0
```

## Maintainers

* Dvorkin Dmitry `<dvorkin at tibbo.com>`
