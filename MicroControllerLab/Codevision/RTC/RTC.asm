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

	.INCLUDE "RTC.vec"
	.INCLUDE "RTC.inc"

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
;      11 Date    : 3/19/2008
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
;      26 #include <bcd.h>   
;      27 #include <stdio.h> 
;      28 #include <delay.h>        
;      29 // Alphanumeric LCD Module functions
;      30 #asm
;      31    .equ __lcd_port=0x18 ;PORTB
   .equ __lcd_port=0x18 ;PORTB
;      32 #endasm

;      33 #include <lcd.h>
;      34 
;      35 #define RTC_ADDRESS     0xD0  
;      36 struct time {
;      37 		unsigned char ti_sec;
;      38 		unsigned char ti_min;
;      39 		unsigned char ti_hour;
;      40 		unsigned char ti_day;
;      41 		unsigned char ti_date;
;      42 		unsigned char ti_month;
;      43 		unsigned char ti_year;
;      44 	    };                 
;      45 	    
;      46 
;      47 void i2c__start(void);
;      48 unsigned char i2c__write(unsigned char Data);
;      49 unsigned char RTCRd(unsigned char Address);
;      50 void i2c__stop(void);
;      51 void gettime(struct time *t);
;      52 void settime(struct time t);
;      53 unsigned char RTCRd(unsigned char Address); 
;      54 void stop_clock(); 
;      55 void start_clock();         
;      56 
;      57 
;      58 // Declare your global variables here
;      59 
;      60 void main(void)
;      61 {

	.CSEG
_main:
;      62 // Declare your local variables here 
;      63 char a[20];
;      64 struct time t,t1;  
;      65 // Input/Output Ports initialization
;      66 // Port A initialization
;      67 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      68 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      69 PORTA=0x00;
	SBIW R28,34
;	a -> Y+14
;	t -> Y+7
;	t1 -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;      70 DDRA=0x00;
	OUT  0x1A,R30
;      71 
;      72 // Port B initialization
;      73 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      74 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      75 PORTB=0x00;
	OUT  0x18,R30
;      76 DDRB=0x00;
	OUT  0x17,R30
;      77 
;      78 // Port C initialization
;      79 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      80 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      81 PORTC=0x00;
	OUT  0x15,R30
;      82 DDRC=0x00;
	OUT  0x14,R30
;      83 
;      84 // Port D initialization
;      85 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      86 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      87 PORTD=0x00;
	OUT  0x12,R30
;      88 DDRD=0x00;
	OUT  0x11,R30
;      89 
;      90 // Timer/Counter 0 initialization
;      91 // Clock source: System Clock
;      92 // Clock value: Timer 0 Stopped
;      93 // Mode: Normal top=FFh
;      94 // OC0 output: Disconnected
;      95 TCCR0=0x00;
	OUT  0x33,R30
;      96 TCNT0=0x00;
	OUT  0x32,R30
;      97 OCR0=0x00;
	OUT  0x3C,R30
;      98 
;      99 // Timer/Counter 1 initialization
;     100 // Clock source: System Clock
;     101 // Clock value: Timer 1 Stopped
;     102 // Mode: Normal top=FFFFh
;     103 // OC1A output: Discon.
;     104 // OC1B output: Discon.
;     105 // Noise Canceler: Off
;     106 // Input Capture on Falling Edge
;     107 TCCR1A=0x00;
	OUT  0x2F,R30
;     108 TCCR1B=0x00;
	OUT  0x2E,R30
;     109 TCNT1H=0x00;
	OUT  0x2D,R30
;     110 TCNT1L=0x00;
	OUT  0x2C,R30
;     111 ICR1H=0x00;
	OUT  0x27,R30
;     112 ICR1L=0x00;
	OUT  0x26,R30
;     113 OCR1AH=0x00;
	OUT  0x2B,R30
;     114 OCR1AL=0x00;
	OUT  0x2A,R30
;     115 OCR1BH=0x00;
	OUT  0x29,R30
;     116 OCR1BL=0x00;
	OUT  0x28,R30
;     117 
;     118 // Timer/Counter 2 initialization
;     119 // Clock source: System Clock
;     120 // Clock value: Timer 2 Stopped
;     121 // Mode: Normal top=FFh
;     122 // OC2 output: Disconnected
;     123 ASSR=0x00;
	OUT  0x22,R30
;     124 TCCR2=0x00;
	OUT  0x25,R30
;     125 TCNT2=0x00;
	OUT  0x24,R30
;     126 OCR2=0x00;
	OUT  0x23,R30
;     127 
;     128 // External Interrupt(s) initialization
;     129 // INT0: Off
;     130 // INT1: Off
;     131 // INT2: Off
;     132 MCUCR=0x00;
	OUT  0x35,R30
;     133 MCUCSR=0x00;
	OUT  0x34,R30
;     134 
;     135 // Timer(s)/Counter(s) Interrupt(s) initialization
;     136 TIMSK=0x00;
	OUT  0x39,R30
;     137 
;     138 // Analog Comparator initialization
;     139 // Analog Comparator: Off
;     140 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     141 // Analog Comparator Output: Off
;     142 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     143 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     144 
;     145 // TWO WIRW BUS
;     146 TWSR=0x00;
	OUT  0x1,R30
;     147 TWBR=0x20;
	LDI  R30,LOW(32)
	OUT  0x0,R30
;     148 TWCR=0x04;
	LDI  R30,LOW(4)
	OUT  0x36,R30
;     149 
;     150 // LCD module initialization
;     151 lcd_init(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
;     152 t.ti_sec = 5;      	
	LDI  R30,LOW(5)
	STD  Y+7,R30
;     153 t.ti_min=34;
	LDI  R30,LOW(34)
	STD  Y+8,R30
;     154 t.ti_hour = 13;
	LDI  R30,LOW(13)
	STD  Y+9,R30
;     155 t.ti_day = 5;
	LDI  R30,LOW(5)
	STD  Y+10,R30
;     156 t.ti_date = 19;
	LDI  R30,LOW(19)
	STD  Y+11,R30
;     157 t.ti_month = 3;
	LDI  R30,LOW(3)
	STD  Y+12,R30
;     158 t.ti_year=2008;
	MOVW R26,R28
	ADIW R26,13
	LDI  R30,LOW(2008)
	LDI  R31,HIGH(2008)
	ST   X,R30
;     159 settime(t); 
	MOVW R30,R28
	ADIW R30,7
	LDI  R26,7
	CALL __PUTPARL
	RCALL _settime
;     160 start_clock();
	RCALL _start_clock
;     161 while (1)
_0x3:
;     162       {   
;     163       lcd_clear();      
	CALL _lcd_clear
;     164       gettime(&t1); 
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RCALL _gettime
;     165       sprintf(a,"Time = %2d:%2d:%2d",t1.ti_hour,t1.ti_min,t1.ti_sec);     
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDD  R30,Y+12
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
;     166       //sprintf(a,"Time =");     
;     167       lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
;     168       lcd_puts(a);  
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;     169       delay_ms(1000);	     
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     170       // Place your code here
;     171 
;     172       };
	RJMP _0x3
;     173 }  
	ADIW R28,34
_0x6:
	RJMP _0x6
;     174 void i2c__start(void)
;     175 {
_i2c__start:
;     176 unsigned char temp;
;     177 do 
	ST   -Y,R16
;	temp -> R16
_0x8:
;     178   {
;     179   TWCR=0xA4;
	LDI  R30,LOW(164)
	OUT  0x36,R30
;     180   while(!(TWCR&0x80));
_0xA:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0xA
;     181   temp=TWSR & 0xF8;
	CALL SUBOPT_0x0
;     182   } while ((temp!=0x08) && (temp!=0x10));
	CPI  R16,8
	BREQ _0xD
	CPI  R16,16
	BRNE _0xE
_0xD:
	RJMP _0x9
_0xE:
	RJMP _0x8
_0x9:
;     183 }  
	RJMP _0x74
;     184 unsigned char i2c__write(unsigned char Data)
;     185 {                                          
_i2c__write:
;     186 unsigned char temp;
;     187 TWDR=Data;
	ST   -Y,R16
;	Data -> Y+1
;	temp -> R16
	LDD  R30,Y+1
	OUT  0x3,R30
;     188 TWCR=0x84;
	LDI  R30,LOW(132)
	OUT  0x36,R30
;     189 while(!(TWCR&0x80));
_0xF:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0xF
;     190 temp=TWSR & 0xF8;
	CALL SUBOPT_0x0
;     191 return(temp);
	MOV  R30,R16
	LDD  R16,Y+0
	RJMP _0x75
;     192 }          
;     193 
;     194 unsigned char i2c__read(unsigned char ack,unsigned char *status)
;     195 {
_i2c__read:
;     196 unsigned char temp;
;     197 TWCR=0x84 | (ack<<7);
	ST   -Y,R16
;	ack -> Y+3
;	*status -> Y+1
;	temp -> R16
	LDD  R30,Y+3
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,LOW(0x84)
	OUT  0x36,R30
;     198 while(!(TWCR&0x80));
_0x12:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x12
;     199 temp=TWSR & 0xF8;
	CALL SUBOPT_0x0
;     200 *status=temp;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R16
;     201 return(TWDR);
	IN   R30,0x3
	LDD  R16,Y+0
	ADIW R28,4
	RET
;     202 }
;     203 
;     204 void i2c__stop(void)
;     205 {
_i2c__stop:
;     206 TWCR=0x94;
	LDI  R30,LOW(148)
	OUT  0x36,R30
;     207 }
	RET
;     208 
;     209 
;     210 unsigned char RTCRd(unsigned char Address)
;     211 {
_RTCRd:
;     212 unsigned char data,temp;
;     213 i2c__start();
	ST   -Y,R17
	ST   -Y,R16
;	Address -> Y+2
;	data -> R16
;	temp -> R17
	CALL SUBOPT_0x1
;     214 i2c__write(RTC_ADDRESS);
;     215 i2c__write(Address);
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c__write
;     216 i2c__start();
	CALL _i2c__start
;     217 i2c__write(RTC_ADDRESS | 1);
	LDI  R30,LOW(209)
	ST   -Y,R30
	CALL _i2c__write
;     218 data=i2c__read(0,&temp);
	LDI  R30,LOW(0)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	CALL _i2c__read
	POP  R17
	MOV  R16,R30
;     219 i2c__stop();
	CALL _i2c__stop
;     220 return data;
	MOV  R30,R16
	LDD  R17,Y+1
	RJMP _0x76
;     221 } 
;     222 
;     223 void gettime(struct time *t)
;     224 {
_gettime:
;     225 unsigned char temp;
;     226 temp=RTCRd(0x00);
	CALL SUBOPT_0x2
;	*t -> Y+1
;	temp -> R16
;     227 t->ti_sec = (temp&0x0F)+(temp>>4)*10;
	MOV  R30,R16
	ANDI R30,LOW(0xF)
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	ADD  R30,R26
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
;     228 
;     229 temp=RTCRd(0x01);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4
;     230 t->ti_min = (temp&0x0F)+(temp>>4)*10;
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	ADD  R30,R26
	__PUTB1SNS 1,1
;     231 
;     232 temp=RTCRd(0x02);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x4
;     233 t->ti_hour = (temp&0x0F) + ((temp>>4)&0x03)*10;  
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	ADD  R30,R26
	__PUTB1SNS 1,2
;     234 
;     235 temp=RTCRd(0x03);                              
	LDI  R30,LOW(3)
	CALL SUBOPT_0x6
;     236 t->ti_day = temp;                              
	MOV  R30,R16
	__PUTB1SNS 1,3
;     237 
;     238 temp=RTCRd(0x04);                              
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
;     239 t->ti_date = (temp&0x0F)+((temp>>4)&0x03)*10;  
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	ADD  R30,R26
	__PUTB1SNS 1,4
;     240   
;     241 temp=RTCRd(0x05);                              
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4
;     242 t->ti_month = (temp&0x0F)+((temp>>4)&0x01)*10;  
	PUSH R30
	MOV  R30,R16
	SWAP R30
	ANDI R30,LOW(0x1)
	CALL SUBOPT_0x7
	POP  R26
	ADD  R30,R26
	__PUTB1SNS 1,5
;     243 
;     244 temp=RTCRd(0x06);                              
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4
;     245 t->ti_year = (temp&0x0F)+((temp>>4)&0x0F)*10;  
	PUSH R30
	MOV  R30,R16
	SWAP R30
	ANDI R30,LOW(0xF)
	CALL SUBOPT_0x7
	POP  R26
	ADD  R30,R26
	__PUTB1SNS 1,6
;     246 
;     247 }   
_0x76:
	LDD  R16,Y+0
	ADIW R28,3
	RET
;     248 
;     249 void RTCWr(unsigned char Address ,unsigned char Data)
;     250 {
_RTCWr:
;     251 i2c__start();
	CALL SUBOPT_0x1
;     252 i2c__write(RTC_ADDRESS);
;     253 i2c__write(Address);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c__write
;     254 i2c__write(Data);
	LD   R30,Y
	ST   -Y,R30
	CALL _i2c__write
;     255 i2c__stop();
	CALL _i2c__stop
;     256 }                                                                                
_0x75:
	ADIW R28,2
	RET
;     257 void settime(struct time t)
;     258 {                  
_settime:
;     259 unsigned char temp;
;     260 temp=RTCRd(0x00);
	CALL SUBOPT_0x2
;	t -> Y+1
;	temp -> R16
;     261 RTCWr(0x0,(bin2bcd(t.ti_sec)|(temp&0x80)));
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bin2bcd
	PUSH R30
	MOV  R30,R16
	ANDI R30,LOW(0x80)
	POP  R26
	CALL SUBOPT_0x8
;     262 
;     263 RTCWr(0x01,bin2bcd(t.ti_min));
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+3
	CALL SUBOPT_0x9
;     264 
;     265 temp=RTCRd(0x00);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x6
;     266 RTCWr(0x02,(bin2bcd(t.ti_hour)|(temp&0xC0)));
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _bin2bcd
	PUSH R30
	MOV  R30,R16
	ANDI R30,LOW(0xC0)
	POP  R26
	CALL SUBOPT_0x8
;     267 
;     268 RTCWr(0x03,bin2bcd(t.ti_day));
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDD  R30,Y+5
	CALL SUBOPT_0x9
;     269 
;     270 RTCWr(0x04,bin2bcd(t.ti_date));
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDD  R30,Y+6
	CALL SUBOPT_0x9
;     271 
;     272 RTCWr(0x05,bin2bcd(t.ti_month));
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDD  R30,Y+7
	CALL SUBOPT_0x9
;     273 
;     274 RTCWr(0x06,bin2bcd(t.ti_year));
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDD  R30,Y+8
	CALL SUBOPT_0x9
;     275 }   
	LDD  R16,Y+0
	ADIW R28,8
	RET
;     276 void stop_clock()
;     277 {
;     278 unsigned char temp;
;     279 temp=RTCRd(0x00); 
;	temp -> R16
;     280 RTCWr(0x0,temp|0x80);
;     281 }
;     282 
;     283 void start_clock()
;     284 {                
_start_clock:
;     285 unsigned char temp;
;     286 temp=RTCRd(0x00);    
	CALL SUBOPT_0x2
;	temp -> R16
;     287 RTCWr(0x0,temp&0x7F);
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R30,R16
	ANDI R30,0x7F
	ST   -Y,R30
	CALL _RTCWr
;     288 }                            
_0x74:
	LD   R16,Y+
	RET
;     289 
;     290         
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
__put_G2:
	put:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x15
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
	SBIW R30,1
	MOVW R26,R30
	LDD  R30,Y+2
	ST   X,R30
	RJMP _0x16
_0x15:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0x16:
	ADIW R28,3
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R16,0
_0x17:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x19
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x1D
	CPI  R19,37
	BRNE _0x1E
	LDI  R16,LOW(1)
	RJMP _0x1F
_0x1E:
	CALL SUBOPT_0xA
_0x1F:
	RJMP _0x1C
_0x1D:
	CPI  R30,LOW(0x1)
	BRNE _0x20
	CPI  R19,37
	BRNE _0x21
	CALL SUBOPT_0xA
	LDI  R16,LOW(0)
	RJMP _0x1C
_0x21:
	LDI  R16,LOW(2)
	LDI  R21,LOW(0)
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x22
	LDI  R17,LOW(1)
	RJMP _0x1C
_0x22:
	CPI  R19,43
	BRNE _0x23
	LDI  R21,LOW(43)
	RJMP _0x1C
_0x23:
	CPI  R19,32
	BRNE _0x24
	LDI  R21,LOW(32)
	RJMP _0x1C
_0x24:
	RJMP _0x25
_0x20:
	CPI  R30,LOW(0x2)
	BRNE _0x26
_0x25:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x27
	ORI  R17,LOW(128)
	RJMP _0x1C
_0x27:
	RJMP _0x28
_0x26:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x1C
_0x28:
	CPI  R19,48
	BRLO _0x2B
	CPI  R19,58
	BRLO _0x2C
_0x2B:
	RJMP _0x2A
_0x2C:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x1C
_0x2A:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x30
	CALL SUBOPT_0xB
	LD   R30,X
	CALL SUBOPT_0xC
	RJMP _0x31
_0x30:
	CPI  R30,LOW(0x73)
	BRNE _0x33
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlen
	MOV  R16,R30
	RJMP _0x34
_0x33:
	CPI  R30,LOW(0x70)
	BRNE _0x36
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x34:
	ORI  R17,LOW(2)
	ANDI R17,LOW(127)
	LDI  R18,LOW(0)
	RJMP _0x37
_0x36:
	CPI  R30,LOW(0x64)
	BREQ _0x3A
	CPI  R30,LOW(0x69)
	BRNE _0x3B
_0x3A:
	ORI  R17,LOW(4)
	RJMP _0x3C
_0x3B:
	CPI  R30,LOW(0x75)
	BRNE _0x3D
_0x3C:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R16,LOW(5)
	RJMP _0x3E
_0x3D:
	CPI  R30,LOW(0x58)
	BRNE _0x40
	ORI  R17,LOW(8)
	RJMP _0x41
_0x40:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x6F
_0x41:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R16,LOW(4)
_0x3E:
	SBRS R17,2
	RJMP _0x43
	CALL SUBOPT_0xB
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x44
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R21,LOW(45)
_0x44:
	CPI  R21,0
	BREQ _0x45
	SUBI R16,-LOW(1)
	RJMP _0x46
_0x45:
	ANDI R17,LOW(251)
_0x46:
	RJMP _0x47
_0x43:
	CALL SUBOPT_0xB
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x47:
_0x37:
	SBRC R17,0
	RJMP _0x48
_0x49:
	CP   R16,R20
	BRSH _0x4B
	SBRS R17,7
	RJMP _0x4C
	SBRS R17,2
	RJMP _0x4D
	ANDI R17,LOW(251)
	MOV  R19,R21
	SUBI R16,LOW(1)
	RJMP _0x4E
_0x4D:
	LDI  R19,LOW(48)
_0x4E:
	RJMP _0x4F
_0x4C:
	LDI  R19,LOW(32)
_0x4F:
	CALL SUBOPT_0xA
	SUBI R20,LOW(1)
	RJMP _0x49
_0x4B:
_0x48:
	MOV  R18,R16
	SBRS R17,1
	RJMP _0x50
_0x51:
	CPI  R18,0
	BREQ _0x53
	SBRS R17,3
	RJMP _0x54
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x77
_0x54:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x77:
	ST   -Y,R30
	CALL SUBOPT_0xE
	CPI  R20,0
	BREQ _0x56
	SUBI R20,LOW(1)
_0x56:
	SUBI R18,LOW(1)
	RJMP _0x51
_0x53:
	RJMP _0x57
_0x50:
_0x59:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,2
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
                                      ldd  r26,y+10  ;R26,R27=n
                                      ldd  r27,y+11
                                  calc_digit:
                                      cp   r26,r30
                                      cpc  r27,r31
                                      brlo calc_digit_done
	SUBI R19,-LOW(1)
	                                  sub  r26,r30
	                                  sbc  r27,r31
	                                  brne calc_digit
                                  calc_digit_done:
                                      std  Y+10,r26 ;n=R26,R27
                                      std  y+11,r27
	LDI  R30,LOW(57)
	CP   R30,R19
	BRSH _0x5B
	SBRS R17,3
	RJMP _0x5C
	SUBI R19,-LOW(7)
	RJMP _0x5D
_0x5C:
	SUBI R19,-LOW(39)
_0x5D:
_0x5B:
	SBRC R17,4
	RJMP _0x5F
	LDI  R30,LOW(48)
	CP   R30,R19
	BRLO _0x61
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BRNE _0x60
_0x61:
	ORI  R17,LOW(16)
	RJMP _0x63
_0x60:
	CP   R20,R18
	BRLO _0x65
	SBRS R17,0
	RJMP _0x66
_0x65:
	RJMP _0x64
_0x66:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x67
	LDI  R19,LOW(48)
	ORI  R17,LOW(16)
_0x63:
	SBRS R17,2
	RJMP _0x68
	ANDI R17,LOW(251)
	ST   -Y,R21
	CALL SUBOPT_0xE
	CPI  R20,0
	BREQ _0x69
	SUBI R20,LOW(1)
_0x69:
_0x68:
_0x67:
_0x5F:
	CALL SUBOPT_0xA
	CPI  R20,0
	BREQ _0x6A
	SUBI R20,LOW(1)
_0x6A:
_0x64:
	SUBI R18,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x5A
	RJMP _0x59
_0x5A:
_0x57:
	SBRS R17,0
	RJMP _0x6B
_0x6C:
	CPI  R20,0
	BREQ _0x6E
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0xC
	RJMP _0x6C
_0x6E:
_0x6B:
_0x6F:
_0x31:
	LDI  R16,LOW(0)
_0x1C:
	RJMP _0x17
_0x19:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_sprintf:
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	__PUTW2R 16,17
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL __print_G2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G3:
	.BYTE 0x4

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
_lcd_read_byte0_G3:
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
	SUBI R30,LOW(-__base_y_G3)
	SBCI R31,HIGH(-__base_y_G3)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R4,Y+1
	LDD  R5,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	CALL SUBOPT_0xF
	LDI  R30,LOW(12)
	CALL SUBOPT_0xF
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R5,R30
	MOV  R4,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	INC  R4
	CP   R6,R4
	BRSH _0x71
	__lcd_putchar1:
	INC  R5
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R5
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x71:
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
_lcd_puts:
    ldd  r31,y+1
    ld   r30,y
__lcd_puts0:
    ld   r26,z+
    tst  r26
    breq __lcd_puts1
    st   -y,r26    
    rcall _lcd_putchar
    rjmp __lcd_puts0
__lcd_puts1:
	ADIW R28,2
	RET
__long_delay_G3:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G3:
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
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G3,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G3,3
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G3
	CALL __long_delay_G3
	LDI  R30,LOW(40)
	CALL SUBOPT_0x11
	LDI  R30,LOW(4)
	CALL SUBOPT_0x11
	LDI  R30,LOW(133)
	CALL SUBOPT_0x11
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x72
	LDI  R30,LOW(0)
	RJMP _0x73
_0x72:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x73:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x0:
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	CALL _i2c__start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c__write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	ST   -Y,R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _RTCRd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	MOV  R30,R16
	SWAP R30
	ANDI R30,0xF
	MOV  R26,R30
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x4:
	ST   -Y,R30
	CALL _RTCRd
	MOV  R16,R30
	MOV  R30,R16
	ANDI R30,LOW(0xF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	MOV  R30,R16
	SWAP R30
	ANDI R30,LOW(0x3)
	MOV  R26,R30
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	ST   -Y,R30
	CALL _RTCRd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	MOV  R26,R30
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	OR   R30,R26
	ST   -Y,R30
	JMP  _RTCWr

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x9:
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _RTCWr

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xA:
	ST   -Y,R19
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xB:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	STD  Y+14,R26
	STD  Y+14+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	ST   -Y,R30
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	CALL __GETD1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x10:
	CALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G3

_strlen:
	ld   r26,y+
	ld   r27,y+
	clr  r30
	clr  r31
__strlen0:
	ld   r22,x+
	tst  r22
	breq __strlen1
	adiw r30,1
	rjmp __strlen0
__strlen1:
	ret

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_bin2bcd:
	ld   r26,y+
	clr  r30
__bin2bcd0:
	subi r26,10
	brmi __bin2bcd1
	subi r30,-16
	rjmp __bin2bcd0
__bin2bcd1:
	subi r26,-10
	add  r30,r26
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

