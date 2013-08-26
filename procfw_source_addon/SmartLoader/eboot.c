#include <pspsdk.h>
#include <pspkernel.h>
#include <systemctrl.h>
#include <string.h>
#include <stdio.h> // sprintf()

PSP_MODULE_INFO("SmartLoaderProMod", 0, 1, 0);
PSP_MAIN_THREAD_ATTR(PSP_THREAD_ATTR_USER);
PSP_HEAP_SIZE_MAX();

#include "fast.h" // сам fast recovery
#include "cipl1pbp.h" // custom ipl 1 из 3
#include "cipl2prx.h" // custom ipl 2 из 3
#include "cipl3prx.h" // custom ipl 3 из 3
#include "prx/ksloader_mini.h"
#define printf pspDebugScreenPrintf

#include <pspctrl.h>
SceCtrlData pad;
void ExitCross(char*text)
{
	printf("%s, press X to exit...\n", text);
	do
	{
		sceCtrlReadBufferPositive(&pad, 1);
		sceKernelDelayThread(0.05*1000*1000);
	}
	while(!(pad.Buttons & PSP_CTRL_CROSS));
	sceKernelExitGame();
}

void ExitError(char*text, int delay, int error)
{
	printf(text, error);
	sceKernelDelayThread(delay*1000*1000);
	sceKernelExitGame();
}

int WriteFile(char*file, void*buf, int size)
{
	sceIoRemove(file);
	SceUID fd = sceIoOpen(file, PSP_O_WRONLY | PSP_O_CREAT | PSP_O_TRUNC, 0777);
	if (fd < 0)
		return fd;

	int written = sceIoWrite(fd, buf, size);
	sceIoClose(fd);

	return written;
}

int pspSdkLoadStartModule_Smart(const char*file)
{
	SceUID module_file;
	u8 module_type = 0;

	module_file = sceIoOpen(file, PSP_O_RDONLY, 0777);
	if (module_file >= 0)
	{
		sceIoLseek(module_file, 0x7C, PSP_SEEK_SET);
		sceIoRead(module_file, &module_type, 1);
		sceIoClose(module_file);

		if (module_type == 0x02)
			return pspSdkLoadStartModule(file, PSP_MEMORY_PARTITION_KERNEL);
		else if (module_type == 0x04)
			return pspSdkLoadStartModule(file, PSP_MEMORY_PARTITION_USER);
		else
			return -2; // неизвестный тип
	}
	else
		sceIoClose(module_file);

	return -1; // нет файла
}

int main(int argc, char*argv[])
{
	//Kprintf("pbpbuild: %s %s", __DATE__, __TIME__); // ERR:8002013C

	int i = 0;
	int ret = 0;
	int apitype = 0;
	char*mode = NULL;
	char*program = NULL;
	struct SceKernelLoadExecVSHParam param;
	char dir1[128] __attribute__((aligned(16))) = "\0"; // без align/достаточного размера ERR:80010002
	char dir2[128] __attribute__((aligned(16))) = "\0"; // без align/достаточного размера ERR:80010002
	char dir3[128] __attribute__((aligned(16))) = "\0"; // без align/достаточного размера ERR:80010002
	char fast_dir[128] = "xx0:/PSP/GAME/FIRMWARE";
	char file_pbp[128] = "xx0:/PSP/GAME/FIRMWARE/EBOOT.PBP";

	pspDebugScreenInit();
	pspDebugScreenClear(); // особо не нужно
	printf("Welcome to Smart Loader!\n\n");

	SceUID mod = pspSdkLoadStartModule_Smart("ksloader.prx");
	if (mod < 0)
	{
		ExitError("Error: LoadStart() returned 0x%08x\n", 5, mod);
	}

	i = sceSysregGetTachyonVersion();
	if (i < 0x00140000) // раньше, чем первая фатка
	{
		ExitError("Error: GetTachyon() returned 0x%08x\n", 5, i);
	}
	else if (i < 0x00600000) // прошивайка - тип 1
	{
		printf("Your PSP type is 1!\n");
		sceKernelDelayThread(3*1000*1000);
		// обходим ERR:8002032C и получаем папку
		sprintf(dir1, "%s", argv[0]);
		dir1[strlen(dir1)-9] = 0x00; // обрываем строку при помощи "\0"
		sprintf(dir1, "%s%s%s", dir1, "CIPL.PBP", "\0"); // тут ноль, возможно, лишний
		sprintf(dir2, "%s", argv[0]);
		dir2[strlen(dir2)-9] = 0x00; // обрываем строку при помощи "\0"
		sprintf(dir2, "%s%s%s", dir2, "ipl_update.prx", "\0"); // тут ноль, возможно, лишний
		sprintf(dir3, "%s", argv[0]);
		dir3[strlen(dir3)-9] = 0x00; // обрываем строку при помощи "\0"
		sprintf(dir3, "%s%s%s", dir3, "kpspident.prx", "\0"); // тут ноль, возможно, лишний
		// распаковываем файлы из буфера
		ret = 0; // не нужно, в общем-то
		ret = WriteFile(dir1, cipl1pbp, size_cipl1pbp);
		if (ret != size_cipl1pbp)
		{
			ExitError("Error: WriteFile() returned 0x%08x\n", 5, ret);
		}
		sceKernelDelayThread(0.10*1000*1000);
		ret = 0;
		ret = WriteFile(dir2, cipl2prx, size_cipl2prx);
		if (ret != size_cipl2prx)
		{
			ExitError("Error: WriteFile() returned 0x%08x\n", 5, ret);
		}
		sceKernelDelayThread(0.10*1000*1000);
		ret = 0;
		ret = WriteFile(dir3, cipl3prx, size_cipl3prx);
		if (ret != size_cipl3prx)
		{
			ExitError("Error: WriteFile() returned 0x%08x\n", 5, ret);
		}
		sceKernelDelayThread(0.10*1000*1000);
		// устанавливаем параметры
		apitype = 0x141;
		program = dir1;
		mode = "game";
		// создаём и наполняем
		memset(&param, 0, sizeof(param));
		param.size = sizeof(param);
		param.args = strlen(program)+1;
		param.argp = program;
		param.key = mode;
		// применяем/запускаем
		sctrlKernelLoadExecVSHWithApitype(apitype, program, &param);
	}
	else // непрошивайка - тип 2
	{
		printf("Your PSP type is 2!\n");
		sceKernelDelayThread(3*1000*1000);
		// вычисляем путь
		fast_dir[0] = argv[0][0]; // m или e
		fast_dir[1] = argv[0][1]; // s или f
		file_pbp[0] = argv[0][0]; // m или e
		file_pbp[1] = argv[0][1]; // s или f
		// записываем fast recovery из буфера
		sceIoMkdir(fast_dir, 0777);
		sceKernelDelayThread(0.10*1000*1000);
		ret = 0;
		ret = WriteFile(file_pbp, fast_pbp, size_fast_pbp);
		if (ret != size_fast_pbp)
		{
			ExitError("Error: WriteFile() returned 0x%08x\n", 5, ret);
		}
	}

	ExitCross("\nDone");
	return 0;
}