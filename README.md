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

TBD

## Notes

For >= Nanbield:
```
PREFERRED_VERSION_linux-sp = "5.10%"
```
in any child layer.

See "Yocto branch:" comments at
```
conf/machine/sp7021-arm5.conf
conf/machine/sp7021.conf
```

## Maintainers

* Dvorkin Dmitry `<dvorkin at tibbo.com>`
