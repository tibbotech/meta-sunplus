def dv_expand_file(d,file_in,file_out):
    with open(file_in, "r") as f:
        content = f.read()

    expanded = d.expand(content)

    with open(file_out, "w") as f:
        f.write(expanded)
    return f"x"

def dv_find_glob(d, dir):
    import os,glob
    print( "glob in: %s" % dir)
    globbed = glob.glob(dir, recursive=True)
    print( "globbed: %s" % globbed)
    return globbed

def dv_fileexpand ( d, _pattern, _ext):
    print( "pattern: %s" % _pattern)
    exts = os.path.splitext( _ext)
    print( "ext split: %s + %s" % exts)
    files = dv_find_glob(d, d.getVar( 'WORKDIR') + '/' + _pattern)
    # print("xxx: %s" % files)
    for file in files:
        fileA0 = os.path.splitext(file)
        fileA1 = os.path.splitext(fileA0[0])
        x = fileA1[0] + exts[0]
        print("IN template:: %s -> %s" % (file, x))
        dv_expand_file(d, file, x)
