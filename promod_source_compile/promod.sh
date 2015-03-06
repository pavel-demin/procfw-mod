#!/bin/bash
rm -rf procfw
rm -rf procfw~
hg clone https://code.google.com/p/procfw/
cp *.a procfw/Satelite
cp *.BIN procfw/contrib/fonts
cp *.diff procfw
cp *.patch procfw
cd procfw
hg patch *.diff
hg patch *.patch
rm -rf *.diff
rm -rf *.patch

make clean
make clean_lib
make build_lib
make CONFIG_620=1
mv dist dist_620

make clean
make clean_lib
make build_lib
make CONFIG_639=1
mv dist dist_639

make clean
make clean_lib
make build_lib
make CONFIG_660=1
mv dist dist_660

make clean
make clean_lib
make build_lib
make CONFIG_661=1
mv dist dist_661

