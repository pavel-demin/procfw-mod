@echo off
if exist *.elf del /q *.elf
if exist *.o del /q *.o
if exist *.prx del /q *.prx
if exist *.s del /q *.s
cls
c:/pspsdk/bin/make -f makefile_mini
if exist *.elf del /q *.elf
if exist *.o del /q *.o
if exist *.prx psp-build-exports -s ksloader_exp_mini.exp
if exist *.prx psp-packer ksloader.prx
