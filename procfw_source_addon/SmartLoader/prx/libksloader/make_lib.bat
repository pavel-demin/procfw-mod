@echo off
if exist *.a del /q *.a
if exist *.o del /q *.o
cls
c:/pspsdk/bin/make
if exist *.o del /q *.o
