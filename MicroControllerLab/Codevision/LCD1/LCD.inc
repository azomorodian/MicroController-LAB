_7:
	.DB  0x80,0xC0
	.DEF __lcd_x=R4
	.DEF __lcd_y=R5
	.DEF __lcd_maxx=R6
_0:
	.DB  0x48,0x65,0x6C,0x6C,0x6F,0x20,0x57,0x6F
	.DB  0x72,0x6C,0x64,0x21,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G2
	.DW  _7*2

	.DW  0