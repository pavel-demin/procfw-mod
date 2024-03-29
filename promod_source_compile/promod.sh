#!/bin/bash
rm -rf procfw
rm -rf procfw~
if ! [ -e procfw_bak ]
then
	hg clone https://code.google.com/p/procfw/ procfw_bak
fi
cp -R procfw_bak procfw
cp *.a procfw/Satelite
cp *.BIN procfw/contrib/fonts
cp *.diff procfw
cp *.patch procfw
cd procfw
hg patch -m "ignoreme" *.diff
hg patch -m "ignoreme" *.patch
echo Done!
sleep 10
rm -rf *.diff
rm -rf *.patch

make clean
make clean_lib
# cd ...
# rm ...
# cd ...
make build_lib
make CONFIG_620=1
mv dist dist_620

make clean
make clean_lib
# dirty hack
cd CIPL_installer
rm -rf *.elf
rm -rf *.o
rm -rf *.PBP
rm -rf flasher.prx
rm -rf *.SFO
cd kpspident
rm -rf *.elf
rm -rf *.o
rm -rf *.prx
cd ..
cd ..
# eof dirty hack
make build_lib
make CONFIG_639=1
mv dist dist_639

make clean
make clean_lib
# dirty hack
cd CIPL_installer
rm -rf *.elf
rm -rf *.o
rm -rf *.PBP
rm -rf flasher.prx
rm -rf *.SFO
cd kpspident
rm -rf *.elf
rm -rf *.o
rm -rf *.prx
cd ..
cd ..
# eof dirty hack
make build_lib
make CONFIG_660=1
mv dist dist_660

make clean
make clean_lib
# dirty hack
cd CIPL_installer
rm -rf *.elf
rm -rf *.o
rm -rf *.PBP
rm -rf flasher.prx
rm -rf *.SFO
cd kpspident
rm -rf *.elf
rm -rf *.o
rm -rf *.prx
cd ..
cd ..
# eof dirty hack
make build_lib
make CONFIG_661=1
mv dist dist_661

