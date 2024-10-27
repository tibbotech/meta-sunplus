
python () {
    xbootconfigs = d.getVarFlags('XBOOT_CONFIGS')
    for k, v in xbootconfigs.items():
        #bb.note( 'k:%s v:%s' % (k, v))
        d.appendVar('XBOOTX_MACHIN', ' ' + k)
        d.appendVar('XBOOTX_CONFIG', ' ' + v)

}
