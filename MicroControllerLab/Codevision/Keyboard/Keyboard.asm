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

	.INCLUDE "Keyboard.vec"
	.INCLUDE "Keyboard.inc"

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
;      26 #include <stdio.h>
;      27 #include <delay.h>
;      28 
;      29 // Alphanumeric LCD Module functions
;      30 #asm
;      31    .equ __lcd_port=0x18 ;PORTB
   .equ __lcd_port=0x18 ;PORTB
;      32 #endasm

;      33 #include <lcd.h>
;      34 
;      35 // Declare your global variables here
;      36 
;      37 void main(void)
;      38 {

	.CSEG
_main:
;      39 // Declare your local variables here
;      40 char a[20];       
;      41 char Data;
;      42 char scan;
;      43 
;      44 // Input/Output Ports initialization
;      45 // Port A initialization
;      46 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      47 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      48 //1 2 3 4 are rows 5 6 7 are columns
;      49 PORTA=0x00;
	SBIW R28,20
;	a -> Y+0
;	Data -> R16
;	scan -> R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;      50 DDRA=0x0F;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
;      51 
;      52 // Port B initialization
;      53 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      54 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      55 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;      56 DDRB=0x00;
	OUT  0x17,R30
;      57 
;      58 // Port C initialization
;      59 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      60 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      61 PORTC=0x00;
	OUT  0x15,R30
;      62 DDRC=0x00;
	OUT  0x14,R30
;      63 
;      64 // Port D initialization
;      65 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;      66 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;      67 PORTD=0x00;
	OUT  0x12,R30
;      68 DDRD=0x00;
	OUT  0x11,R30
;      69 
;      70 
;      71 // Timer/Counter 0 initialization
;      72 // Clock source: System Clock
;      73 // Clock value: Timer 0 Stopped
;      74 // Mode: Normal top=FFh
;      75 // OC0 output: Disconnected
;      76 TCCR0=0x00;
	OUT  0x33,R30
;      77 TCNT0=0x00;
	OUT  0x32,R30
;      78 OCR0=0x00;
	OUT  0x3C,R30
;      79 
;      80 // Timer/Counter 1 initialization
;      81 // Clock source: System Clock
;      82 // Clock value: Timer 1 Stopped
;      83 // Mode: Normal top=FFFFh
;      84 // OC1A output: Discon.
;      85 // OC1B output: Discon.
;      86 // Noise Canceler: Off
;      87 // Input Capture on Falling Edge
;      88 TCCR1A=0x00;
	OUT  0x2F,R30
;      89 TCCR1B=0x00;
	OUT  0x2E,R30
;      90 TCNT1H=0x00;
	OUT  0x2D,R30
;      91 TCNT1L=0x00;
	OUT  0x2C,R30
;      92 ICR1H=0x00;
	OUT  0x27,R30
;      93 ICR1L=0x00;
	OUT  0x26,R30
;      94 OCR1AH=0x00;
	OUT  0x2B,R30
;      95 OCR1AL=0x00;
	OUT  0x2A,R30
;      96 OCR1BH=0x00;
	OUT  0x29,R30
;      97 OCR1BL=0x00;
	OUT  0x28,R30
;      98 
;      99 // Timer/Counter 2 initialization
;     100 // Clock source: System Clock
;     101 // Clock value: Timer 2 Stopped
;     102 // Mode: Normal top=FFh
;     103 // OC2 output: Disconnected
;     104 ASSR=0x00;
	OUT  0x22,R30
;     105 TCCR2=0x00;
	OUT  0x25,R30
;     106 TCNT2=0x00;
	OUT  0x24,R30
;     107 OCR2=0x00;
	OUT  0x23,R30
;     108 
;     109 // External Interrupt(s) initialization
;     110 // INT0: Off
;     111 // INT1: Off
;     112 // INT2: Off
;     113 MCUCR=0x00;
	OUT  0x35,R30
;     114 MCUCSR=0x00;
	OUT  0x34,R30
;     115 
;     116 // Timer(s)/Counter(s) Interrupt(s) initialization
;     117 TIMSK=0x00;
	OUT  0x39,R30
;     118 
;     119 // Analog Comparator initialization
;     120 // Analog Comparator: Off
;     121 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     122 // Analog Comparator Output: Off
;     123 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     124 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     125 
;     126 // LCD module initialization
;     127 lcd_init(20); 
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _lcd_init
;     128 lcd_clear();
	CALL _lcd_clear
;     129 
;     130 while (1)
_0x3:
;     131       {
;     132       // Place your code here  
;     133       PORTA = 0xFE;  
	LDI  R30,LOW(254)
	CALL SUBOPT_0x0
;     134       delay_ms(10);
;     135       scan = PINA;  
	IN   R17,25
;     136       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
;     137       sprintf(a,"%2x",scan);
	__POINTW1FN _0,0
	CALL SUBOPT_0x2
	LDI  R24,4
	CALL SUBOPT_0x3
;     138       lcd_puts(a);
;     139       switch (scan)
;     140       {
;     141       	case 0xee:
	CPI  R30,LOW(0xEE)
	BRNE _0x9
;     142       		Data = '1';
	LDI  R16,LOW(49)
;     143       		break;
	RJMP _0x8
;     144       	case 0xde:         
_0x9:
	CPI  R30,LOW(0xDE)
	BRNE _0xA
;     145       		Data = '2';
	LDI  R16,LOW(50)
;     146       		break;
	RJMP _0x8
;     147       	case 0xbe:         
_0xA:
	CPI  R30,LOW(0xBE)
	BRNE _0x8
;     148       		Data = '3';
	LDI  R16,LOW(51)
;     149       		break;      		
;     150       }
_0x8:
;     151       PORTA = 0xFD;
	LDI  R30,LOW(253)
	CALL SUBOPT_0x0
;     152       delay_ms(10);
;     153       scan = PINA; 
	IN   R17,25
;     154       lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1
;     155       sprintf(a,"%2x",scan);
	__POINTW1FN _0,0
	CALL SUBOPT_0x2
	LDI  R24,4
	CALL SUBOPT_0x3
;     156       lcd_puts(a);
;     157       
;     158       switch (scan)
;     159       {
;     160       	case 0xed:
	CPI  R30,LOW(0xED)
	BRNE _0xF
;     161       		Data = '4';
	LDI  R16,LOW(52)
;     162       		break;
	RJMP _0xE
;     163       	case 0xdd:         
_0xF:
	CPI  R30,LOW(0xDD)
	BRNE _0x10
;     164       		Data = '5';
	LDI  R16,LOW(53)
;     165       		break;
	RJMP _0xE
;     166       	case 0xbd:         
_0x10:
	CPI  R30,LOW(0xBD)
	BRNE _0xE
;     167       		Data = '6';
	LDI  R16,LOW(54)
;     168       		break;      		
;     169       }
_0xE:
;     170       PORTA = 0xFB;
	LDI  R30,LOW(251)
	CALL SUBOPT_0x0
;     171       delay_ms(10);
;     172       scan = PINA; 
	IN   R17,25
;     173       lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4
;     174       sprintf(a,"%2x",scan);
	__POINTW1FN _0,0
	CALL SUBOPT_0x2
	LDI  R24,4
	CALL SUBOPT_0x3
;     175       lcd_puts(a);
;     176 
;     177       switch (scan)
;     178       {
;     179       	case 0xeb:
	CPI  R30,LOW(0xEB)
	BRNE _0x15
;     180       		Data = '7';
	LDI  R16,LOW(55)
;     181       		break;
	RJMP _0x14
;     182       	case 0xdb:         
_0x15:
	CPI  R30,LOW(0xDB)
	BRNE _0x16
;     183       		Data = '8';
	LDI  R16,LOW(56)
;     184       		break;
	RJMP _0x14
;     185       	case 0xbb:         
_0x16:
	CPI  R30,LOW(0xBB)
	BRNE _0x14
;     186       		Data = '9';
	LDI  R16,LOW(57)
;     187       		break;      		
;     188       }    
_0x14:
;     189             
;     190       PORTA = 0xF7;
	LDI  R30,LOW(247)
	CALL SUBOPT_0x0
;     191       delay_ms(10);
;     192       scan = PINA;  
	IN   R17,25
;     193       lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x4
;     194       sprintf(a,"%2x",scan);
	__POINTW1FN _0,0
	CALL SUBOPT_0x2
	LDI  R24,4
	CALL SUBOPT_0x3
;     195       lcd_puts(a);          
;     196       switch (scan)
;     197       {
;     198       	case 0xe7:
	CPI  R30,LOW(0xE7)
	BRNE _0x1B
;     199       		Data = '*';
	LDI  R16,LOW(42)
;     200       		break;
	RJMP _0x1A
;     201       	case 0xd7:         
_0x1B:
	CPI  R30,LOW(0xD7)
	BRNE _0x1C
;     202       		Data = '0';
	LDI  R16,LOW(48)
;     203       		break;
	RJMP _0x1A
;     204       	case 0xb7:         
_0x1C:
	CPI  R30,LOW(0xB7)
	BRNE _0x1A
;     205       		Data = '#';
	LDI  R16,LOW(35)
;     206       		break;      		
;     207       }          
_0x1A:
;     208       
;     209       lcd_gotoxy(15,1);
	LDI  R30,LOW(15)
	CALL SUBOPT_0x4
;     210       sprintf(a,"%c",Data);
	__POINTW1FN _0,4
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
;     211       lcd_puts(a);      
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;     212       
;     213 
;     214       };
	RJMP _0x3
;     215 }
	ADIW R28,20
_0x1E:
	RJMP _0x1E
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
	BREQ _0x1F
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
	SBIW R30,1
	MOVW R26,R30
	LDD  R30,Y+2
	ST   X,R30
	RJMP _0x20
_0x1F:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0x20:
	ADIW R28,3
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R16,0
_0x21:
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
	JMP _0x23
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x27
	CPI  R19,37
	BRNE _0x28
	LDI  R16,LOW(1)
	RJMP _0x29
_0x28:
	CALL SUBOPT_0x5
_0x29:
	RJMP _0x26
_0x27:
	CPI  R30,LOW(0x1)
	BRNE _0x2A
	CPI  R19,37
	BRNE _0x2B
	CALL SUBOPT_0x5
	LDI  R16,LOW(0)
	RJMP _0x26
_0x2B:
	LDI  R16,LOW(2)
	LDI  R21,LOW(0)
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x2C
	LDI  R17,LOW(1)
	RJMP _0x26
_0x2C:
	CPI  R19,43
	BRNE _0x2D
	LDI  R21,LOW(43)
	RJMP _0x26
_0x2D:
	CPI  R19,32
	BRNE _0x2E
	LDI  R21,LOW(32)
	RJMP _0x26
_0x2E:
	RJMP _0x2F
_0x2A:
	CPI  R30,LOW(0x2)
	BRNE _0x30
_0x2F:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x31
	ORI  R17,LOW(128)
	RJMP _0x26
_0x31:
	RJMP _0x32
_0x30:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x26
_0x32:
	CPI  R19,48
	BRLO _0x35
	CPI  R19,58
	BRLO _0x36
_0x35:
	RJMP _0x34
_0x36:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x26
_0x34:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x3A
	CALL SUBOPT_0x6
	LD   R30,X
	CALL SUBOPT_0x7
	RJMP _0x3B
_0x3A:
	CPI  R30,LOW(0x73)
	BRNE _0x3D
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL _strlen
	MOV  R16,R30
	RJMP _0x3E
_0x3D:
	CPI  R30,LOW(0x70)
	BRNE _0x40
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x3E:
	ORI  R17,LOW(2)
	ANDI R17,LOW(127)
	LDI  R18,LOW(0)
	RJMP _0x41
_0x40:
	CPI  R30,LOW(0x64)
	BREQ _0x44
	CPI  R30,LOW(0x69)
	BRNE _0x45
_0x44:
	ORI  R17,LOW(4)
	RJMP _0x46
_0x45:
	CPI  R30,LOW(0x75)
	BRNE _0x47
_0x46:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R16,LOW(5)
	RJMP _0x48
_0x47:
	CPI  R30,LOW(0x58)
	BRNE _0x4A
	ORI  R17,LOW(8)
	RJMP _0x4B
_0x4A:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x79
_0x4B:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R16,LOW(4)
_0x48:
	SBRS R17,2
	RJMP _0x4D
	CALL SUBOPT_0x6
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x4E
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R21,LOW(45)
_0x4E:
	CPI  R21,0
	BREQ _0x4F
	SUBI R16,-LOW(1)
	RJMP _0x50
_0x4F:
	ANDI R17,LOW(251)
_0x50:
	RJMP _0x51
_0x4D:
	CALL SUBOPT_0x6
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x51:
_0x41:
	SBRC R17,0
	RJMP _0x52
_0x53:
	CP   R16,R20
	BRSH _0x55
	SBRS R17,7
	RJMP _0x56
	SBRS R17,2
	RJMP _0x57
	ANDI R17,LOW(251)
	MOV  R19,R21
	SUBI R16,LOW(1)
	RJMP _0x58
_0x57:
	LDI  R19,LOW(48)
_0x58:
	RJMP _0x59
_0x56:
	LDI  R19,LOW(32)
_0x59:
	CALL SUBOPT_0x5
	SUBI R20,LOW(1)
	RJMP _0x53
_0x55:
_0x52:
	MOV  R18,R16
	SBRS R17,1
	RJMP _0x5A
_0x5B:
	CPI  R18,0
	BREQ _0x5D
	SBRS R17,3
	RJMP _0x5E
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x7E
_0x5E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x7E:
	ST   -Y,R30
	CALL SUBOPT_0x9
	CPI  R20,0
	BREQ _0x60
	SUBI R20,LOW(1)
_0x60:
	SUBI R18,LOW(1)
	RJMP _0x5B
_0x5D:
	RJMP _0x61
_0x5A:
_0x63:
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
	BRSH _0x65
	SBRS R17,3
	RJMP _0x66
	SUBI R19,-LOW(7)
	RJMP _0x67
_0x66:
	SUBI R19,-LOW(39)
_0x67:
_0x65:
	SBRC R17,4
	RJMP _0x69
	LDI  R30,LOW(48)
	CP   R30,R19
	BRLO _0x6B
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BRNE _0x6A
_0x6B:
	ORI  R17,LOW(16)
	RJMP _0x6D
_0x6A:
	CP   R20,R18
	BRLO _0x6F
	SBRS R17,0
	RJMP _0x70
_0x6F:
	RJMP _0x6E
_0x70:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x71
	LDI  R19,LOW(48)
	ORI  R17,LOW(16)
_0x6D:
	SBRS R17,2
	RJMP _0x72
	ANDI R17,LOW(251)
	ST   -Y,R21
	CALL SUBOPT_0x9
	CPI  R20,0
	BREQ _0x73
	SUBI R20,LOW(1)
_0x73:
_0x72:
_0x71:
_0x69:
	CALL SUBOPT_0x5
	CPI  R20,0
	BREQ _0x74
	SUBI R20,LOW(1)
_0x74:
_0x6E:
	SUBI R18,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x64
	RJMP _0x63
_0x64:
_0x61:
	SBRS R17,0
	RJMP _0x75
_0x76:
	CPI  R20,0
	BREQ _0x78
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x7
	RJMP _0x76
_0x78:
_0x75:
_0x79:
_0x3B:
	LDI  R16,LOW(0)
_0x26:
	RJMP _0x21
_0x23:
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
	CALL SUBOPT_0xA
	LDI  R30,LOW(12)
	CALL SUBOPT_0xA
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
	BRSH _0x7B
	__lcd_putchar1:
	INC  R5
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R5
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x7B:
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
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	CALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G3
	CALL __long_delay_G3
	LDI  R30,LOW(40)
	CALL SUBOPT_0xC
	LDI  R30,LOW(4)
	CALL SUBOPT_0xC
	LDI  R30,LOW(133)
	CALL SUBOPT_0xC
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x7C
	LDI  R30,LOW(0)
	RJMP _0x7D
_0x7C:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x7D:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x0:
	OUT  0x1B,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3:
	CALL _sprintf
	ADIW R28,8
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x5:
	ST   -Y,R19
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x6:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	STD  Y+14,R26
	STD  Y+14+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	ST   -Y,R30
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	CALL __GETD1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xB:
	CALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC:
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

