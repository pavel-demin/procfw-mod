#include <pspsdk.h>
#include <pspkernel.h>

PSP_MODULE_INFO("ksloader", 0x1006, 7, 4);
PSP_MAIN_THREAD_ATTR(0);

u32 sceSysreg_driver_E2A5D1EE(void);		// Tachyon

u32 sceSysregGetTachyonVersion(void)
{
	int k1 = pspSdkSetK1(0);
	int err = sceSysreg_driver_E2A5D1EE();
	pspSdkSetK1(k1);
	return err;
}

int module_start(SceSize args, void *argp)
{
	Kprintf("prxbuild: %s %s", __DATE__, __TIME__);
	return 0;
}

int module_stop(void)
{
	return 0;
}
