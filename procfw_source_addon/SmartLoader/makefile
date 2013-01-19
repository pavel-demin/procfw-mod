TARGET = eboot
OBJS = eboot.o
OBJS += prx/ksloader.S

INCDIR = inc inc_lib ../include
CFLAGS = -O2 -G0 -Wall
CXXFLAGS = $(CFLAGS) -fno-exceptions -fno-rtti
ASFLAGS = $(CFLAGS) -c

LIBDIR = lib inc_lib ../libs
LIBS = -lpspsystemctrl_user
#LDFLAGS = -L.

PSP_FW_VERSION = 660
#PSP_FW_VERSION_SFO = 1

EXTRA_TARGETS = EBOOT.PBP
PSP_EBOOT_TITLE = 6.60 PROMOD-C Smart Loader
PSP_EBOOT_ICON = inc_lib/ICON0.PNG

#ENCRYPT = 1
BUILD_PRX = 1

PSPSDK=$(shell psp-config --pspsdk-path)
include $(PSPSDK)/lib/build.mak
