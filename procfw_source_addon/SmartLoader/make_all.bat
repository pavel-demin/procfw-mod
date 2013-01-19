@echo off
if not exist ..\libs\libpspsystemctrl_user.a (
echo.
echo YOU MUST DO "MAKE DEPS" FIRST!
echo.
pause
exit
)
if exist *.pbp del /q *.pbp
if exist *.prx del /q *.prx
cd prx
cd libksloader
call make_lib.bat
cd ..
call make_prx_mini.bat
cd ..
call make_pbp.bat
copy prx\ksloader.prx ksloader.prx
