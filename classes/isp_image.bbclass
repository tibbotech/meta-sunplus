inherit image_types

# defined in the machine config
#IMAGE_TYPEDEP_isp = "ext4"

do_image_isp[depends] = "ispe-native:do_populate_sysroot"
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
 bbnote "isp IMG_ISP_P:${IMG_ISP_P}"
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
    bfz=$(dv_2_arr $i "${IMG_ISP_BF}" " ")
    boz=$(dv_2_arr $i "${IMG_ISP_BO}" " ")
    IFS=","
    j=0
    for bf in $bfz; do
      bo=$(dv_2_arr $j "$boz" ",")
      bbnote "${c} setb file:${bf} off:${bo}"
      ff0="${DEPLOY_DIR_IMAGE}/${bf}"
      ff1="${IMGDEPLOYDIR}/${bf}"
      if [ -z "${bf}" ]; then
        bberror "${c} No file for setb at ${bo}?!"
      elif [ -f "${bf}" ]; then
        ispe ${ISP_IMG} setb ${bo} ${bf}
      elif [ -f "${ff0}" ]; then
        ispe ${ISP_IMG} setb ${bo} ${ff0}
      elif [ -f "${ff1}" ]; then
        ispe ${ISP_IMG} setb ${bo} ${ff1}
      else
        bberror "${c} No '${bf}' file found"
      fi;
      j=$(expr $j + 1)
    done
    paz=$(dv_2_arr $i "${IMG_ISP_P}" " ")
    faz=$(dv_2_arr $i "${IMG_ISP_F}" " ")
    oaz=$(dv_2_arr $i "${IMG_ISP_O}" " ")
    IFS=","
    j=0
    for p in $paz; do
      f=$(dv_2_arr $j "$faz" ",")
      o=$(dv_2_arr $j "$oaz" ",")
      bbnote "${c} part:${p} file:${f} off:${o}"
      ispe ${ISP_IMG} part "${p}" addp
      ff0="${DEPLOY_DIR_IMAGE}/${f}"
      ff1="${IMGDEPLOYDIR}/${f}"
      if [ -z "${f}" ]; then
        bberror "${c} No file for part '${p}'?!"
      elif [ -f "${f}" ]; then
        ispe ${ISP_IMG} part "${p}" file ${f}
      elif [ -f "${ff0}" ]; then
        ispe ${ISP_IMG} part "${p}" file ${ff0}
      elif [ -f "${ff1}" ]; then
        ispe ${ISP_IMG} part "${p}" file ${ff1}
      else
        bberror "${c} No '${f}' file found"
      fi;
      ispe ${ISP_IMG} part "${p}" emmc ${o}
      j=$(expr $j + 1)
    done
    boot_type=$(dv_2_arr $i "${IMG_ISP_T}" " ")
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
    bsa = d.getVarFlags('ISP_SETBOO')
    tsa = d.getVarFlags('ISP_BOOTYP')
    #bb.note( 'xxx:%s' % d.getVar('MACHINE'))
    #bb.note( 'bsa:%s' % bsa)
    csa = d.getVarFlags('ISP_CONFIG')
    for i, v in csa.items():
        #bb.note( 'i:%s' % i)
        #bb.note( 'bsa: %s' % d.getVarFlag('ISP_SETBOO', i))
        d.appendVar('IMG_ISP_P', ' ')
        d.appendVar('IMG_ISP_F', ' ')
        d.appendVar('IMG_ISP_O', ' ')
        pa0=[]
        pa1=[]
        pa2=[]
        for vv in v.strip().split(' '):
            #bb.note( 'vv:%s' % vv)
            da=vv.split(';')
            if len(da) < 3:
                raise bb.parse.SkipRecipe('Three items should be defined')
            pa0.append(da[0])
            pa1.append(da[1])
            pa2.append(da[2])
        d.appendVar('IMG_ISP_P', ','.join(pa0))
        d.appendVar('IMG_ISP_F', ','.join(pa1))
        d.appendVar('IMG_ISP_O', ','.join(pa2))
        # do same for SETb
        d.appendVar('IMG_ISP_BF', ' ')
        d.appendVar('IMG_ISP_BO', ' ')
        ba0=[]
        ba1=[]
        v=d.getVarFlag('ISP_SETBOO', i)
        for vv in v.strip().split(' '):
            #bb.note( 'vv:%s' % vv)
            ba=vv.split(';')
            if len(ba) < 2:
                raise bb.parse.SkipRecipe('Two items should be defined')
            ba0.append(ba[0])
            ba1.append(ba[1])
        d.appendVar('IMG_ISP_BF', ','.join(ba0))
        d.appendVar('IMG_ISP_BO', ','.join(ba1))
        # same for ISP_BOOTYP
        d.appendVar('IMG_ISP_T', ' ')
        v=d.getVarFlag('ISP_BOOTYP', i)
        if v == "":
            v = "emmc"
        d.appendVar('IMG_ISP_T', v)
            
    #bb.note('xxxxx')
}
