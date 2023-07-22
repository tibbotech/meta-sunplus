inherit image_types

# defined in the machine config
#IMAGE_TYPEDEP_isp = "ext4"

do_image_isp[depends]  = "ispe-native:do_populate_sysroot"
do_image_isp[depends] += "u-boot-tools-native:do_populate_sysroot"
do_image_isp[depends] += "virtual/bootloader:do_deploy"
do_image_isp[depends] += "virtual/kernel:do_deploy"

dv_2_arr () {
 i=0
 IFS="${3}"
 for p in ${2}; do
   if [ $i -eq $1 ]; then  echo "$p";  fi;
   i=$(expr $i + 1)
 done
 echo ""
}

IMAGE_CMD_isp () {
 bbnote "isp IMGDEPLOYDIR:${IMGDEPLOYDIR}"
 bbnote "isp IMAGE_NAME:${IMAGE_NAME}"
 bbnote "isp IMAGE_NAME_SUFFIX:${IMAGE_NAME_SUFFIX}"
 bbnote "isp IMAGE_ROOTFS:${IMAGE_ROOTFS}"
 bbnote "isp ISP_CONFIG:${ISP_CONFIG}"
 bbnote "isp WORKDIR:${WORKDIR}"
 bbnote "isp DEPLOY_DIR_IMAGE:${DEPLOY_DIR_IMAGE}"
 ls -1 ${IMGDEPLOYDIR}/
 ISPEDIR=${WORKDIR}/recipe-sysroot-native/usr/bin/
 ISP_TMPDIR="${WORKDIR}/isptmp"
 rm -rf "${ISP_TMPDIR}"
 install -d ${ISP_TMPDIR}/
 i=0
 for c in ${ISP_CONFIG}; do
    bbnote "${c} Image [${i}]"
    rm -rf ${IMGDEPLOYDIR}/${c}
    #install -d ${IMGDEPLOYDIR}/${c}/
    install -d ${DEPLOY_DIR_IMAGE}/${c}/
    ISP_IMG="${DEPLOY_DIR_IMAGE}/${c}/${IMAGE_NAME}.ISP"
    ispe ${ISP_IMG} crea

    iinc=$(expr $i + 1)

    # ISP_SETBOO_* handling _K is file, _V is offset
    ka=$(dv_2_arr $iinc "${IMG_ISP_SETBOO_K}" "|")
    va=$(dv_2_arr $iinc "${IMG_ISP_SETBOO_V}" "|")
    IFS=","
    j=0
    for f in $ka; do
      v=$(dv_2_arr $j "$va" ",")
      bbnote "${c} SETBOO file:${f} off:${v}"
      ff0="${DEPLOY_DIR_IMAGE}/${f}"
      ff1="${IMGDEPLOYDIR}/${f}"
      if [ -z "${f}" ]; then
        bberror "${c}:setb No file for ${v}"
      elif [ -f "${f}" ]; then
        ispe ${ISP_IMG} setb ${v} ${f}
      elif [ -f "${ff0}" ]; then
        ispe ${ISP_IMG} setb ${v} ${ff0}
      elif [ -f "${ff1}" ]; then
        ispe ${ISP_IMG} setb ${v} ${ff1}
      else
        bberror "${c}:setb '${bf}' not found"
      fi;
      j=$(expr $j + 1)
    done

    # ISP_ISP_* handling _P is partition name, _F is the file, _O is EMMC offset (optional)
    paz=$(dv_2_arr $i "${IMG_ISP_P}" " ")
    faz=$(dv_2_arr $i "${IMG_ISP_F}" " ")
    oaz=$(dv_2_arr $i "${IMG_ISP_O}" " ")
    IFS=","
    j=0
    for p in $paz; do
      f=$(dv_2_arr $j "$faz" ",")
      o=$(dv_2_arr $j "$oaz" ",")
      bbnote "${c} CONFIG ${p} file:${f} off:${o}"
      if [ "x${p}" = "x-" ]; then
        j=$(expr $j + 1)
        continue;
      fi;
      ispe ${ISP_IMG} part "${p}" addp
      ff0="${DEPLOY_DIR_IMAGE}/${f}"
      ff1="${IMGDEPLOYDIR}/${f}"
      if [ -z "${f}" ]; then
        bbwarn "${c}[${p}] No contents"
      elif [ "x${f}" = "x-" ]; then
        bbnote "${c}[${p}] Skipped"
      elif [ -f "${f}" ]; then
        ispe ${ISP_IMG} part "${p}" file ${f}
      elif [ -f "${ff0}" ]; then
        ispe ${ISP_IMG} part "${p}" file ${ff0}
      elif [ -f "${ff1}" ]; then
        ispe ${ISP_IMG} part "${p}" file ${ff1}
      else
        bberror "${c}[${p}] '${f}' not found"
      fi;
      ispe ${ISP_IMG} part "${p}" emmc ${o}
      j=$(expr $j + 1)
    done

    # ISP_PFLAGS_* handling _K is parts, _V is flag value
    ka=$(dv_2_arr $iinc "${IMG_ISP_PFLAGS_K}" "|")
    va=$(dv_2_arr $iinc "${IMG_ISP_PFLAGS_V}" "|")
# bbnote "${c} IMG_ISP_PFLAGS_K:${IMG_ISP_PFLAGS_K}"
# bbnote "${c} ka:${ka}"
    IFS=","
    j=0
    for p in $ka; do
      v=$(dv_2_arr $j "$va" ",")
      bbnote "${c} PFLAGS ${p} flag:${v}"
      ispe ${ISP_IMG} part "${p}" flag ${v}
      j=$(expr $j + 1)
    done

    # ISP_NANDOF_* handling _K is parts, _V is offset value
    ka=$(dv_2_arr $iinc "${IMG_ISP_NANDOF_K}" "|")
    va=$(dv_2_arr $iinc "${IMG_ISP_NANDOF_V}" "|")
    IFS=","
    j=0
    for p in $ka; do
      v=$(dv_2_arr $j "$va" ",")
      bbnote "${c} NANDOF ${p} off:${v}"
      ispe ${ISP_IMG} part "${p}" nand ${v}
      j=$(expr $j + 1)
    done

    # ISP_EMMCOF_* handling _K is parts, _V is offset value
    ka=$(dv_2_arr $iinc "${IMG_ISP_EMMCOF_K}" "|")
    va=$(dv_2_arr $iinc "${IMG_ISP_EMMCOF_V}" "|")
    IFS=","
    j=0
    for p in $ka; do
      v=$(dv_2_arr $j "$va" ",")
      bbnote "${c} EMMCOF ${p} off:${v}"
      ispe ${ISP_IMG} part "${p}" emmc ${v}
      j=$(expr $j + 1)
    done

    boot_type=$(dv_2_arr $i "${IMG_ISP_BOOTYP}" " ")
    bbnote "${c} ISP script type: ${boot_type}"
    if [ "x${boot_type}" = "xnone" ]; then
      i=$(expr $i + 1)
      continue;
    fi;
    if [ ! -f "${ISPEDIR}ispe-helpers/genisp.${boot_type}.sh" ]; then
      bberror "${c}:ISP boot type '${boot_type}' not found"
    fi;
    bbnote "${c} Generating the ISP(${boot_type}) script..."
    ISPEDIR=${ISPEDIR} ${ISPEDIR}ispe-helpers/genisp.${boot_type}.sh ${ISP_IMG} ${ISP_TMPDIR}/${c}.${boot_type}.txt
    ${ISPEDIR}ispe-helpers/script_enc.sh "ISP Script" ${ISP_TMPDIR}/${c}.${boot_type}.txt ${ISP_TMPDIR}/${c}.${boot_type}.raw
    bbnote "${c} Installing the ISP(${boot_type}) script..."
    ${ISPEDIR}ispe ${ISP_IMG} -vv setb eof ${ISP_TMPDIR}/${c}.${boot_type}.raw
    bbnote "${c} Checking the offsets..."
    output=$(ispe ${ISP_IMG} list)
    LP=$(echo "${output}" | grep "Last part " | sed -e 's/Last part EOF: 0x//')
    TL=$(echo "${output}" | grep "Tail data " | sed -e 's/Tail data len: //')
    TLh=$(printf '%x' $TL)
    bbnote "${c} Last part: ${LP}"
    bbnote "${c} Tail data: ${TL}"
    bbnote "${c} Installing the HDR script ${TLh}..."
    cat ${ISPEDIR}ispe-templates/sp7021.hdr.T | sed -e "s/{T_OFF}/0x${LP}/" -e "s/{T_SIZE}/0x${TLh}/" > ${ISP_TMPDIR}/${c}.head.script.txt
    ${ISPEDIR}ispe-helpers/script_enc.sh "Init ISP Script" ${ISP_TMPDIR}/${c}.head.script.txt ${ISP_TMPDIR}/${c}.head.script.raw
    ispe ${ISP_IMG} head sets ${ISP_TMPDIR}/${c}.head.script.raw
    ln -sf ${ISP_IMG} ${DEPLOY_DIR_IMAGE}/${c}/ISPBOOOT.BIN
    i=$(expr $i + 1)
 done
}

python () {
    #bb.note( 'xxx:%s' % d.getVar('MACHINE'))
    csa = d.getVarFlags('ISP_CONFIG')
    for i, v in csa.items():
        #bb.note( 'i:%s' % i)
        d.appendVar('IMG_ISP_P', ' ')
        d.appendVar('IMG_ISP_F', ' ')
        d.appendVar('IMG_ISP_O', ' ')
        pa0=[]
        pa1=[]
        pa2=[]
        for vv in v.strip().split(' '):
            #bb.note( 'vv ISP_CONFIG:%s' % vv)
            da=vv.split(';')
            if len(da) < 2:
                raise bb.parse.SkipRecipe('ISP_CONFIG[%s]: At least 2 items should be defined in %s' % (i, vv))
            pa0.append(da[0])
            pa1.append(da[1])
            if len(da) > 2:
                pa2.append(da[2])
            else:
                pa2.append('0x0')
        d.appendVar('IMG_ISP_P', ','.join(pa0))
        d.appendVar('IMG_ISP_F', ','.join(pa1))
        d.appendVar('IMG_ISP_O', ','.join(pa2))

    for i, v in csa.items():
        # *** handle ISP_BOOTYP
        d.appendVar('IMG_ISP_BOOTYP', ' ')
        v=d.getVarFlag('ISP_BOOTYP', i)
        if v == "":
            v = "emmc"
        d.appendVar('IMG_ISP_BOOTYP', v)

    for i, v in csa.items():
        # *** handle ISP_PFLAGS
        d.appendVar('IMG_ISP_PFLAGS_K', '|')
        d.appendVar('IMG_ISP_PFLAGS_V', '|')
        ba0=[]
        ba1=[]
        v=d.getVarFlag('ISP_PFLAGS', i)
        if v is None:
            continue
        for vv in v.strip().split(' '):
            ba=vv.split(';')
            if len(ba) < 2:
                raise bb.parse.SkipRecipe('ISP_PFLAGST[%s]: two items should be defined in %s' % (i, vv))
            ba0.append(ba[0])
            ba1.append(ba[1])
        d.appendVar('IMG_ISP_PFLAGS_K', ','.join(ba0))
        d.appendVar('IMG_ISP_PFLAGS_V', ','.join(ba1))

    for i, v in csa.items():
        # *** handle ISP_NANDOF
        d.appendVar('IMG_ISP_NANDOF_K', '|')
        d.appendVar('IMG_ISP_NANDOF_V', '|')
        ba0=[]
        ba1=[]
        v=d.getVarFlag('ISP_NANDOF', i)
        if v is None:
            continue
        for vv in v.strip().split(' '):
            ba=vv.split(';')
            if len(ba) < 2:
                raise bb.parse.SkipRecipe('ISP_NANDOF[%s]: two items should be defined in %s' % (i, vv))
            ba0.append(ba[0])
            ba1.append(ba[1])
        d.appendVar('IMG_ISP_NANDOF_K', ','.join(ba0))
        d.appendVar('IMG_ISP_NANDOF_V', ','.join(ba1))

    for i, v in csa.items():
        # *** handle ISP_EMMCOF
        d.appendVar('IMG_ISP_EMMCOF_K', '|')
        d.appendVar('IMG_ISP_EMMCOF_V', '|')
        ba0=[]
        ba1=[]
        v=d.getVarFlag('ISP_EMMCOF', i)
        if v is None:
            continue
        for vv in v.strip().split(' '):
            ba=vv.split(';')
            if len(ba) < 2:
                raise bb.parse.SkipRecipe('ISP_EMMCOF[%s]: two items should be defined in %s' % (i, vv))
            ba0.append(ba[0])
            ba1.append(ba[1])
        d.appendVar('IMG_ISP_EMMCOF_K', ','.join(ba0))
        d.appendVar('IMG_ISP_EMMCOF_V', ','.join(ba1))

    for i, v in csa.items():
        # *** handle ISP_SETBOO
        d.appendVar('IMG_ISP_SETBOO_K', '|')
        d.appendVar('IMG_ISP_SETBOO_V', '|')
        ba0=[]
        ba1=[]
        v=d.getVarFlag('ISP_SETBOO', i)
        if v is None:
            continue
        for vv in v.strip().split(' '):
            ba=vv.split(';')
            if len(ba) < 2:
                raise bb.parse.SkipRecipe('ISP_SETBOO[%s]: two items should be defined in %s' % (i, vv))
            ba0.append(ba[0])
            ba1.append(ba[1])
        d.appendVar('IMG_ISP_SETBOO_K', ','.join(ba0))
        d.appendVar('IMG_ISP_SETBOO_V', ','.join(ba1))
            
    #bb.note('xxxxx')
}
