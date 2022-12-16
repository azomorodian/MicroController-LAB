;CodeVisionAVR C Compiler V1.24.2c Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 4.000000 MHz
;Memory model        : Small
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 256 byte(s)
;Heap size           : 0 byte(s)
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : Yes
;Enhanced core instructions    : On
;Automatic register allocation : On

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@2,@0+@1
	.ENDM

	.MACRO __GETWRMN
	LDS  R@2,@0+@1
	LDS  R@3,@0+@1+1
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOV  R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOV  R30,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "PS2.vec"
	.INCLUDE "PS2.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.24.2c Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.ro
;       7 e-mail:office@hpinfotech.ro
;       8 
;       9 Project : 
;      10 Version : 
;      11 Date    : 3/18/2008
;      12 Author  : Artin                           
;      13 Company :                                 
;      14 Comments: 
;      15 
;      16 
;      17 Chip type           : ATmega16
;      18 Program type        : Application
;      19 Clock frequency     : 4.000000 MHz
;      20 Memory model        : Small
;      21 External SRAM size  : 0
;      22 Data Stack size     : 256
;      23 *****************************************************/
;      24 
;      25 #include <mega16.h>
;      26 #include <stdlib.h>
;      27 #include <stdio.h>
;      28 #include <delay.h>
;      29 #define PS2DIN PINC.0 
;      30 #define BUFF_SIZE 64
;      31 
;      32 flash unsigned char unshifted[68][2] = {

	.CSEG
;      33 	0x0d,9,
;      34 	0x0e,'|',
;      35 	0x15,'q',
;      36 	0x16,'1',
;      37 	0x1a,'z',
;      38 	0x1b,'s',
;      39 	0x1c,'a',
;      40 	0x1d,'w',
;      41 	0x1e,'2',
;      42 	0x21,'c',
;      43 	0x22,'x',
;      44 	0x23,'d',
;      45 	0x24,'e',
;      46 	0x25,'4',
;      47 	0x26,'3',
;      48 	0x29,' ',
;      49 	0x2a,'v',
;      50 	0x2b,'f',
;      51 	0x2c,'t',
;      52 	0x2d,'r',
;      53 	0x2e,'5',
;      54 	0x31,'n',
;      55 	0x32,'b',
;      56 	0x33,'h',
;      57 	0x34,'g',
;      58 	0x35,'y',
;      59 	0x36,'6',
;      60 	0x39,',',
;      61 	0x3a,'m',
;      62 	0x3b,'j',
;      63 	0x3c,'u',
;      64 	0x3d,'7',
;      65 	0x3e,'8',
;      66 	0x41,',',
;      67 	0x42,'k',
;      68 	0x43,'i',
;      69 	0x44,'o',
;      70 	0x45,'0',
;      71 	0x46,'9',
;      72 	0x49,'.',
;      73 	0x4a,'-',
;      74 	0x4b,'l',
;      75 	0x4c,'ø',
;      76 	0x4d,'p',
;      77 	0x4e,'+',
;      78 	0x52,'æ',
;      79 	0x54,'å',
;      80 	0x55,'1', 
;      81 	0x5a,13,   
;      82 	0x5b,'¨',
;      83 	0x5d,'\\',
;      84 	0x61,'<',
;      85 	0x66, 8 ,
;      86 	0x69,'1',
;      87 	0x6b,'4',
;      88 	0x6c,'7',
;      89 	0x70,'0',
;      90 	0x71,',',
;      91 	0x72,'2',
;      92 	0x73,'5',
;      93 	0x74,'6',
;      94 	0x75,'8',
;      95 	0x79,'+',
;      96 	0x7a,'3',
;      97 	0x7b,'-',
;      98 	0x7c,'*',
;      99 	0x7d,'9',
;     100 	0,0
;     101 	};
;     102 
;     103 // Shifted characters
;     104 flash unsigned char shifted[68][2] = {
;     105 	0x0d,9,
;     106 	0x0e,'§',
;     107 	0x15,'Q',
;     108 	0x16,'!',
;     109 	0x1a,'Z',
;     110 	0x1b,'S',
;     111 	0x1c,'A',
;     112 	0x1d,'W',
;     113 	0x1e,'"',
;     114 	0x21,'C',
;     115 	0x22,'X',
;     116 	0x23,'D',
;     117 	0x24,'E',
;     118 	0x25,'¤',
;     119 	0x26,'#',
;     120 	0x29,' ',
;     121 	0x2a,'V',
;     122 	0x2b,'F',
;     123 	0x2c,'T',
;     124 	0x2d,'R',
;     125 	0x2e,'%',
;     126 	0x31,'N',
;     127 	0x32,'B',
;     128 	0x33,'H',
;     129 	0x34,'G',
;     130 	0x35,'Y',
;     131 	0x36,'&',
;     132 	0x39,'L',
;     133 	0x3a,'M',
;     134 	0x3b,'J',
;     135 	0x3c,'U',
;     136 	0x3d,'/',
;     137 	0x3e,'(',
;     138 	0x41,';',
;     139 	0x42,'K',
;     140 	0x43,'I',
;     141 	0x44,'O',
;     142 	0x45,'=',
;     143 	0x46,')',
;     144 	0x49,':',
;     145 	0x4a,'_',
;     146 	0x4b,'L',
;     147 	0x4c,'Ø',
;     148 	0x4d,'P',
;     149 	0x4e,'?',
;     150 	0x52,'Æ',
;     151 	0x54,'Å',
;     152 	0x55,'`',
;     153 	0x5a,13,
;     154 	0x5b,'^',
;     155 	0x5d,'*',
;     156 	0x61,'>',
;     157 	0x66,8,
;     158 	0x69,'1',
;     159 	0x6b,'4',
;     160 	0x6c,'7',
;     161 	0x70,'0',
;     162 	0x71,',',
;     163 	0x72,'2',
;     164 	0x73,'5',
;     165 	0x74,'6',
;     166 	0x75,'8',
;     167 	0x79,'+',
;     168 	0x7a,'3',
;     169 	0x7b,'-',
;     170 	0x7c,'*',
;     171 	0x7d,'9',
;     172 	0,0
;     173 	};
;     174 
;     175 unsigned char edge, bitcount;// 0 = neg. 1 = pos.
;     176 unsigned char kb_buffer[BUFF_SIZE];

	.DSEG
_kb_buffer:
	.BYTE 0x40
;     177 unsigned char *inpt, *outpt;
;     178 unsigned char buffcnt;
;     179 
;     180 void init_kb(void); 
;     181 void decode(unsigned char sc);
;     182 void put_kbbuff(unsigned char c);
;     183 int kb_getchar(void);
;     184 
;     185 // Alphanumeric LCD Module functions
;     186 #asm
;     187    .equ __lcd_port=0x18 ;PORTB
   .equ __lcd_port=0x18 ;PORTB
;     188 #endasm

;     189 #include <lcd.h>
;     190 char a;
;     191 char state=0;   
;     192 char ScanCode;
;     193 char Codes[20];
_Codes:
	.BYTE 0x14
;     194 char Index=0;    
;     195 
;     196 
;     197  
;     198 
;     199 
;     200 // External Interrupt 0 service routine
;     201 interrupt [EXT_INT0] void ext_int0_isr(void)
;     202 {

	.CSEG
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     203 	static unsigned char data;// Holds the received scan code

	.DSEG
_data_S0:
	.BYTE 0x1

	.CSEG
;     204 	if (!edge) // Routine entered at falling edge
	TST  R4
	BRNE _0x3
;     205 	{
;     206 		if(bitcount < 11 && bitcount > 2)// Bit 3 to 10 is data. Parity bit,
	LDI  R30,LOW(11)
	CP   R5,R30
	BRSH _0x5
	LDI  R30,LOW(2)
	CP   R30,R5
	BRLO _0x6
_0x5:
	RJMP _0x4
_0x6:
;     207 			{ // start and stop bits are ignored.
;     208 				data = (data >> 1);
	LDS  R30,_data_S0
	LSR  R30
	STS  _data_S0,R30
;     209 				if(PS2DIN)
	SBIS 0x13,0
	RJMP _0x7
;     210 					data = data | 0x80;// Store a '1'
	LDS  R30,_data_S0
	ORI  R30,0x80
	STS  _data_S0,R30
;     211 			}
_0x7:
;     212 		MCUCR = 3;// Set interrupt on rising edge
_0x4:
	LDI  R30,LOW(3)
	OUT  0x35,R30
;     213 		edge = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
;     214 	} else { // Routine entered at rising edge
	RJMP _0x8
_0x3:
;     215 		MCUCR = 2;// Set interrupt on falling edge
	CALL SUBOPT_0x0
;     216 		edge = 0;
;     217 		if(--bitcount == 0)// All bits received
	DEC  R5
	BRNE _0x9
;     218 		{
;     219 			decode(data);
	LDS  R30,_data_S0
	ST   -Y,R30
	RCALL _decode
;     220 			bitcount = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
;     221 		}
;     222 	}
_0x9:
_0x8:
;     223 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     224 
;     225 
;     226 
;     227 
;     228 // Declare your global variables here
;     229 
;     230 void main(void)
;     231 {
_main:
;     232 // Declare your local variables here
;     233 char as[10],i,b;
;     234 
;     235 // Input/Output Ports initialization
;     236 // Port A initialization
;     237 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     238 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     239 PORTA=0x00;
	SBIW R28,10
;	as -> Y+0
;	i -> R16
;	b -> R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     240 DDRA=0x00;
	OUT  0x1A,R30
;     241 
;     242 // Port B initialization
;     243 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     244 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     245 PORTB=0x00;
	OUT  0x18,R30
;     246 DDRB=0x00;
	OUT  0x17,R30
;     247 
;     248 // Port C initialization
;     249 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     250 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     251 PORTC=0x00;
	OUT  0x15,R30
;     252 DDRC=0x00;
	OUT  0x14,R30
;     253 
;     254 // Port D initialization
;     255 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     256 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     257 PORTD=0x00;
	OUT  0x12,R30
;     258 DDRD=0x00;
	OUT  0x11,R30
;     259 
;     260 // Timer/Counter 0 initialization
;     261 // Clock source: System Clock
;     262 // Clock value: Timer 0 Stopped
;     263 // Mode: Normal top=FFh
;     264 // OC0 output: Disconnected
;     265 TCCR0=0x00;
	OUT  0x33,R30
;     266 TCNT0=0x00;
	OUT  0x32,R30
;     267 OCR0=0x00;
	OUT  0x3C,R30
;     268 
;     269 // Timer/Counter 1 initialization
;     270 // Clock source: System Clock
;     271 // Clock value: Timer 1 Stopped
;     272 // Mode: Normal top=FFFFh
;     273 // OC1A output: Discon.
;     274 // OC1B output: Discon.
;     275 // Noise Canceler: Off
;     276 // Input Capture on Falling Edge
;     277 TCCR1A=0x00;
	OUT  0x2F,R30
;     278 TCCR1B=0x00;
	OUT  0x2E,R30
;     279 TCNT1H=0x00;
	OUT  0x2D,R30
;     280 TCNT1L=0x00;
	OUT  0x2C,R30
;     281 ICR1H=0x00;
	OUT  0x27,R30
;     282 ICR1L=0x00;
	OUT  0x26,R30
;     283 OCR1AH=0x00;
	OUT  0x2B,R30
;     284 OCR1AL=0x00;
	OUT  0x2A,R30
;     285 OCR1BH=0x00;
	OUT  0x29,R30
;     286 OCR1BL=0x00;
	OUT  0x28,R30
;     287 
;     288 // Timer/Counter 2 initialization
;     289 // Clock source: System Clock
;     290 // Clock value: Timer 2 Stopped
;     291 // Mode: Normal top=FFh
;     292 // OC2 output: Disconnected
;     293 ASSR=0x00;
	OUT  0x22,R30
;     294 TCCR2=0x00;
	OUT  0x25,R30
;     295 TCNT2=0x00;
	OUT  0x24,R30
;     296 OCR2=0x00;
	OUT  0x23,R30
;     297 
;     298 // External Interrupt(s) initialization
;     299 // INT0: On
;     300 // INT0 Mode: Falling Edge
;     301 // INT1: Off
;     302 // INT2: Off
;     303 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
;     304 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
;     305 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
;     306 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
;     307 
;     308 // Timer(s)/Counter(s) Interrupt(s) initialization
;     309 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
;     310 
;     311 // Analog Comparator initialization
;     312 // Analog Comparator: Off
;     313 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     314 // Analog Comparator Output: Off
;     315 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     316 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     317 
;     318 // LCD module initialization
;     319 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
;     320 lcd_clear();
	CALL _lcd_clear
;     321 for(i=0;i<20;i++) Codes[i] =0;
	LDI  R16,LOW(0)
_0xB:
	CPI  R16,20
	BRSH _0xC
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_Codes)
	SBCI R27,HIGH(-_Codes)
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R16,-1
	RJMP _0xB
_0xC:
;     322 
;     323 	
;     324 
;     325 init_kb();
	RCALL _init_kb
;     326 // Global enable interrupts
;     327 #asm("sei")  
	sei
;     328 
;     329 while (1)
_0xD:
;     330       {
;     331       // Place your code here  
;     332       b = kb_getchar(); 
	RCALL _kb_getchar
	MOV  R17,R30
;     333       if ((b>32) && (b<128))  lcd_putchar(b);
	LDI  R30,LOW(32)
	CP   R30,R17
	BRSH _0x11
	CPI  R17,128
	BRLO _0x12
_0x11:
	RJMP _0x10
_0x12:
	ST   -Y,R17
	CALL _lcd_putchar
;     334       };
_0x10:
	RJMP _0xD
;     335 }
	ADIW R28,10
_0x13:
	RJMP _0x13
;     336 
;     337 void init_kb(void)
;     338 {
_init_kb:
;     339 	inpt = kb_buffer;// Initialize buffer
	LDI  R30,LOW(_kb_buffer)
	LDI  R31,HIGH(_kb_buffer)
	__PUTW1R 6,7
;     340 	outpt = kb_buffer;
	LDI  R30,LOW(_kb_buffer)
	LDI  R31,HIGH(_kb_buffer)
	__PUTW1R 8,9
;     341 	buffcnt = 0;
	CLR  R10
;     342 	MCUCR = 2; // INT0 interrupt on falling edge
	CALL SUBOPT_0x0
;     343 	edge = 0; // 0 = falling edge 1 = rising edge
;     344 	bitcount = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
;     345 }   
	RET
;     346 void decode(unsigned char sc)
;     347 {
_decode:
;     348 static unsigned char is_up=0, shift = 0, mode = 0;

	.DSEG
_is_up_S3:
	.BYTE 0x1
_shift_S3:
	.BYTE 0x1
_mode_S3:
	.BYTE 0x1

	.CSEG
;     349 unsigned char i;
;     350 if (!is_up)// Last data received was the up-key identifier
	ST   -Y,R16
;	sc -> Y+1
;	i -> R16
	LDS  R30,_is_up_S3
	CPI  R30,0
	BREQ PC+3
	JMP _0x14
;     351 {
;     352 	switch (sc)
	LDD  R30,Y+1
;     353 	{
;     354 		case 0xF0 :// The up-key identifier
	CPI  R30,LOW(0xF0)
	BRNE _0x18
;     355 			is_up = 1;
	LDI  R30,LOW(1)
	STS  _is_up_S3,R30
;     356 		break;
	RJMP _0x17
;     357 		case 0x12 :// Left SHIFT
_0x18:
	CPI  R30,LOW(0x12)
	BRNE _0x19
;     358 			shift = 1;
	LDI  R30,LOW(1)
	STS  _shift_S3,R30
;     359 		break;
	RJMP _0x17
;     360 		case 0x59 :// Right SHIFT
_0x19:
	CPI  R30,LOW(0x59)
	BRNE _0x1A
;     361 			shift = 1;
	LDI  R30,LOW(1)
	STS  _shift_S3,R30
;     362 		break;
	RJMP _0x17
;     363 		case 0x05 :// F1
_0x1A:
	CPI  R30,LOW(0x5)
	BRNE _0x1E
;     364 			if(mode == 0)
	LDS  R30,_mode_S3
	CPI  R30,0
	BRNE _0x1C
;     365 				mode = 1;// Enter scan code mode
	LDI  R30,LOW(1)
	STS  _mode_S3,R30
;     366 			if(mode == 2)
_0x1C:
	LDS  R26,_mode_S3
	CPI  R26,LOW(0x2)
	BRNE _0x1D
;     367 				mode = 3;// Leave scan code mode
	LDI  R30,LOW(3)
	STS  _mode_S3,R30
;     368 		break;
_0x1D:
	RJMP _0x17
;     369 		default:
_0x1E:
;     370 			if(mode == 0 || mode == 3)// If ASCII mode
	LDS  R26,_mode_S3
	CPI  R26,LOW(0x0)
	BREQ _0x20
	CPI  R26,LOW(0x3)
	BREQ _0x20
	RJMP _0x1F
_0x20:
;     371 			{
;     372 				if(!shift)// If shift not pressed,
	LDS  R30,_shift_S3
	CPI  R30,0
	BRNE _0x22
;     373 					{ // do a table look-up
;     374 						for(i = 0; unshifted[i][0]!=sc && unshifted[i][0]; i++);
	LDI  R16,LOW(0)
_0x24:
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	BREQ _0x26
	CALL SUBOPT_0x1
	CPI  R30,0
	BRNE _0x27
_0x26:
	RJMP _0x25
_0x27:
	SUBI R16,-1
	RJMP _0x24
_0x25:
;     375 						if (unshifted[i][0] == sc) {
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	BRNE _0x28
;     376 							put_kbbuff(unshifted[i][1]);
	LDI  R26,LOW(_unshifted*2)
	LDI  R27,HIGH(_unshifted*2)
	CALL SUBOPT_0x3
	ADIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _put_kbbuff
;     377 						}
;     378 					} else {// If shift pressed
_0x28:
	RJMP _0x29
_0x22:
;     379 						for(i = 0; shifted[i][0]!=sc && shifted[i][0]; i++);
	LDI  R16,LOW(0)
_0x2B:
	LDI  R26,LOW(_shifted*2)
	LDI  R27,HIGH(_shifted*2)
	CALL SUBOPT_0x3
	LPM  R30,Z
	CALL SUBOPT_0x2
	BREQ _0x2D
	LDI  R26,LOW(_shifted*2)
	LDI  R27,HIGH(_shifted*2)
	CALL SUBOPT_0x3
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	SUBI R16,-1
	RJMP _0x2B
_0x2C:
;     380 						if (shifted[i][0] == sc) {
	LDI  R26,LOW(_shifted*2)
	LDI  R27,HIGH(_shifted*2)
	CALL SUBOPT_0x3
	LPM  R30,Z
	CALL SUBOPT_0x2
	BRNE _0x2F
;     381 							put_kbbuff(shifted[i][1]);
	LDI  R26,LOW(_shifted*2)
	LDI  R27,HIGH(_shifted*2)
	CALL SUBOPT_0x3
	ADIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _put_kbbuff
;     382 						}
;     383 					}
_0x2F:
_0x29:
;     384 			} else{ // Scan code mode
_0x1F:
;     385 			       //print_hexbyte(sc);// Print scan code
;     386 				//put_kbbuff(' ');
;     387 				//put_kbbuff(' ');
;     388 			}
;     389 		break;
;     390 }
_0x17:
;     391 } else {
	RJMP _0x31
_0x14:
;     392 	is_up = 0;// Two 0xF0 in a row not allowed
	LDI  R30,LOW(0)
	STS  _is_up_S3,R30
;     393 	switch (sc)
	LDD  R30,Y+1
;     394 	{
;     395 		case 0x12 :// Left SHIFT
	CPI  R30,LOW(0x12)
	BRNE _0x35
;     396 			shift = 0;
	LDI  R30,LOW(0)
	STS  _shift_S3,R30
;     397 		break;
	RJMP _0x34
;     398 		case 0x59 :// Right SHIFT
_0x35:
	CPI  R30,LOW(0x59)
	BRNE _0x36
;     399 			shift = 0;
	LDI  R30,LOW(0)
	STS  _shift_S3,R30
;     400 		break;
	RJMP _0x34
;     401 		case 0x05 :// F1
_0x36:
	CPI  R30,LOW(0x5)
	BRNE _0x37
;     402 			if(mode == 1)
	LDS  R26,_mode_S3
	CPI  R26,LOW(0x1)
	BRNE _0x38
;     403 				mode = 2;
	LDI  R30,LOW(2)
	STS  _mode_S3,R30
;     404 			if(mode == 3)
_0x38:
	LDS  R26,_mode_S3
	CPI  R26,LOW(0x3)
	BRNE _0x39
;     405 				mode = 0;
	LDI  R30,LOW(0)
	STS  _mode_S3,R30
;     406 		break;
_0x39:
	RJMP _0x34
;     407 		case 0x06 :// F2
_0x37:
	CPI  R30,LOW(0x6)
	BRNE _0x34
;     408 			lcd_clear();
	CALL _lcd_clear
;     409 		break;
;     410 	}
_0x34:
;     411 }
_0x31:
;     412 }
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     413 void put_kbbuff(unsigned char c)
;     414 {
_put_kbbuff:
;     415 	if (buffcnt<BUFF_SIZE)// If buffer not full
	LDI  R30,LOW(64)
	CP   R10,R30
	BRSH _0x3B
;     416 	{
;     417 		*inpt = c;// Put character into buffer
	LD   R30,Y
	__GETW2R 6,7
	ST   X,R30
;     418 		inpt++; // Increment pointer
	__GETW1R 6,7
	ADIW R30,1
	__PUTW1R 6,7
;     419 		buffcnt++;
	INC  R10
;     420 		if (inpt >= kb_buffer + BUFF_SIZE)// Pointer wrapping
	__POINTW1MN _kb_buffer,64
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x3C
;     421 		inpt = kb_buffer;
	LDI  R30,LOW(_kb_buffer)
	LDI  R31,HIGH(_kb_buffer)
	__PUTW1R 6,7
;     422 	}
_0x3C:
;     423 }
_0x3B:
	ADIW R28,1
	RET
;     424 int kb_getchar(void)
;     425 {
_kb_getchar:
;     426 	int byte;
;     427 	while(buffcnt == 0);// Wait for data
	ST   -Y,R17
	ST   -Y,R16
;	byte -> R16,R17
_0x3D:
	TST  R10
	BREQ _0x3D
;     428 	byte = *outpt;// Get byte
	__GETW2R 8,9
	LD   R30,X
	LDI  R31,0
	__PUTW1R 16,17
;     429 	outpt++; // Increment pointer
	__GETW1R 8,9
	ADIW R30,1
	__PUTW1R 8,9
;     430 	if (outpt >= kb_buffer + BUFF_SIZE)// Pointer wrapping
	__POINTW1MN _kb_buffer,64
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x40
;     431 		outpt = kb_buffer;
	LDI  R30,LOW(_kb_buffer)
	LDI  R31,HIGH(_kb_buffer)
	__PUTW1R 8,9
;     432 	buffcnt--; // Decrement buffer count
_0x40:
	DEC  R10
;     433 	return byte;
	__GETW1R 16,17
	LD   R16,Y+
	LD   R17,Y+
	RET
;     434 }
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G4:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
    rcall __lcd_delay
    sbi   __lcd_port,__lcd_enable ;EN=1
    rcall __lcd_delay
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
    rcall __lcd_delay
    sbi   __lcd_port,__lcd_enable ;EN=1
    rcall __lcd_delay
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
    rcall __lcd_delay
    cbi   __lcd_port,__lcd_enable ;EN=0
__lcd_delay:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
    ret
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
    rcall __lcd_write_nibble      ;RD=0, write MSN
    ld    r26,y
    swap  r26
    rcall __lcd_write_nibble      ;write LSN
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble:
    sbi   __lcd_port,__lcd_enable ;EN=1
    rcall __lcd_delay
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
    rcall __lcd_delay
    andi  r30,0xf0
    ret
_lcd_read_byte0_G4:
    rcall __lcd_delay
    rcall __lcd_read_nibble       ;read MSN
    mov   r26,r30
    rcall __lcd_read_nibble       ;read LSN
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G4)
	SBCI R31,HIGH(-__base_y_G4)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	CALL SUBOPT_0x4
	LDI  R30,LOW(12)
	CALL SUBOPT_0x4
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x42
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x42:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
__long_delay_G4:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G4:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
    rcall __lcd_write_nibble      ;RD=0, write MSN
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G4,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G4,3
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL __long_delay_G4
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G4
	CALL __long_delay_G4
	LDI  R30,LOW(40)
	CALL SUBOPT_0x6
	LDI  R30,LOW(4)
	CALL SUBOPT_0x6
	LDI  R30,LOW(133)
	CALL SUBOPT_0x6
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G4
	CPI  R30,LOW(0x5)
	BREQ _0x43
	LDI  R30,LOW(0)
	RJMP _0x44
_0x43:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x44:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(2)
	OUT  0x35,R30
	CLR  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1:
	LDI  R26,LOW(_unshifted*2)
	LDI  R27,HIGH(_unshifted*2)
	MOV  R30,R16
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x2:
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x3:
	MOV  R30,R16
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x5:
	CALL __long_delay_G4
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G4

