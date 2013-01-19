@echo off
if exist *.elf del /q *.elf
if exist *.h del /q *.h
if exist *.o del /q *.o
if exist *.pbp del /q *.pbp
if exist *.prx del /q *.prx
if exist *.s del /q *.s
if exist *.sfo del /q *.sfo
cls
bin2c bin\FAST.PBP fast.h fast_pbp
bin2c bin\CIPL.PBP cipl1pbp.h cipl1pbp
bin2c bin\ipl_update.prx cipl2prx.h cipl2prx
bin2c bin\kpspident.prx cipl3prx.h cipl3prx
c:/pspsdk/bin/make
if exist *.elf del /q *.elf
if exist *.h del /q *.h
if exist *.o del /q *.o
if exist *.prx del /q *.prx
if exist *.s del /q *.s
if exist *.sfo del /q *.sfo
if not exist EBOOT.PBP pause
