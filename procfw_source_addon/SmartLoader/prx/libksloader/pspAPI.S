	.set noreorder

	#include "pspImport.s"

	IMPORT_START	"sceSysreg_driver",0x00010000
		# tachyon
		IMPORT_FUNC		"sceSysreg_driver",0xE2A5D1EE,sceSysreg_driver_E2A5D1EE
		# fuseid
		IMPORT_FUNC		"sceSysreg_driver",0x4F46EEDE,sceSysreg_driver_4F46EEDE
		# fusecfg
		IMPORT_FUNC		"sceSysreg_driver",0x8F4F4E96,sceSysreg_driver_8F4F4E96
		# enable kirk clock
		IMPORT_FUNC		"sceSysreg_driver",0x4F5AFBBE,sceSysregKirkBusClockEnable
		# enable spock clock
		IMPORT_FUNC		"sceSysreg_driver",0x16909002,sceSysregAtaBusClockEnable

	IMPORT_START	"sceSyscon_driver",0x00010000
		# baryon
		IMPORT_FUNC		"sceSyscon_driver",0x7EC5A957,sceSyscon_driver_7EC5A957
		# pommel
		IMPORT_FUNC		"sceSyscon_driver",0xE7E87741,sceSyscon_driver_E7E87741
