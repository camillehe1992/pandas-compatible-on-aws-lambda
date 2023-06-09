import os
import sys
import time
import zipfile


def zip_dir(dirname, zipfilename):
    filelist = []
    if os.path.isfile(dirname):
        filelist.append(dirname)
    else:
        for root, dirs, files in os.walk(dirname):
            for name in files:
                filelist.append(os.path.join(root, name))
    zf = zipfile.ZipFile(zipfilename, "w", zipfile.zlib.DEFLATED)
    for tar in filelist:
        arcname = tar[len(dirname) :]
        zf.write(tar, arcname)
    zf.close()
    time.sleep(3)
    print(f"{zipfilename} ok")


if __name__ == "__main__":
    zip_dir(sys.argv[1], sys.argv[2])
