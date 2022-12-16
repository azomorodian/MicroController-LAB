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

	.INCLUDE "serial.vec"
	.INCLUDE "serial.inc"

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
;      26 
;      27 #define RXB8 1
;      28 #define TXB8 0
;      29 #define UPE 2
;      30 #define OVR 3
;      31 #define FE 4
;      32 #define UDRE 5
;      33 #define RXC 7
;      34 
;      35 #define FRAMING_ERROR (1<<FE)
;      36 #define PARITY_ERROR (1<<UPE)
;      37 #define DATA_OVERRUN (1<<OVR)
;      38 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      39 #define RX_COMPLETE (1<<RXC)
;      40 
;      41 // USART Receiver buffer
;      42 #define RX_BUFFER_SIZE 8
;      43 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      44 
;      45 #if RX_BUFFER_SIZE<256
;      46 unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      47 #else
;      48 unsigned int rx_wr_index,rx_rd_index,rx_counter;
;      49 #endif
;      50 
;      51 // This flag is set on USART Receiver buffer overflow
;      52 bit rx_buffer_overflow;
;      53 
;      54 // USART Receiver interrupt service routine
;      55 interrupt [USART_RXC] void usart_rx_isr(void)
;      56 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      57 char status,data;
;      58 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	data -> R17
	IN   R16,11
;      59 data=UDR;
	IN   R17,12
;      60 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x3
;      61    {
;      62    rx_buffer[rx_wr_index]=data;
	MOV  R26,R4
	LDI  R27,0
	SUBI R26,LOW(-_rx_buffer)
	SBCI R27,HIGH(-_rx_buffer)
	ST   X,R17
;      63    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
;      64    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R6
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x5
;      65       {
;      66       rx_counter=0;
	CLR  R6
;      67       rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      68       };
_0x5:
;      69    };
_0x3:
;      70 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;      71 
;      72 #ifndef _DEBUG_TERMINAL_IO_
;      73 // Get a character from the USART Receiver buffer
;      74 #define _ALTERNATE_GETCHAR_
;      75 #pragma used+
;      76 char getchar(void)
;      77 {
;      78 char data;
;      79 while (rx_counter==0);
;	data -> R16
;      80 data=rx_buffer[rx_rd_index];
;      81 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;      82 #asm("cli")
	cli
;      83 --rx_counter;
;      84 #asm("sei")
	sei
;      85 return data;
;      86 }
;      87 #pragma used-
;      88 #endif
;      89 
;      90 // USART Transmitter buffer
;      91 #define TX_BUFFER_SIZE 8
;      92 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x8
;      93 
;      94 #if TX_BUFFER_SIZE<256
;      95 unsigned char tx_wr_index,tx_rd_index,tx_counter;
;      96 #else
;      97 unsigned int tx_wr_index,tx_rd_index,tx_counter;
;      98 #endif
;      99 
;     100 // USART Transmitter interrupt service routine
;     101 interrupt [USART_TXC] void usart_tx_isr(void)
;     102 {

	.CSEG
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     103 if (tx_counter)
	TST  R9
	BREQ _0xA
;     104    {
;     105    --tx_counter;
	DEC  R9
;     106    UDR=tx_buffer[tx_rd_index];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;     107    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R8
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0xB
	CLR  R8
;     108    };
_0xB:
_0xA:
;     109 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     110 
;     111 #ifndef _DEBUG_TERMINAL_IO_
;     112 // Write a character to the USART Transmitter buffer
;     113 #define _ALTERNATE_PUTCHAR_
;     114 #pragma used+
;     115 void putchar(char c)
;     116 {
_putchar:
;     117 while (tx_counter == TX_BUFFER_SIZE);
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ _0xC
;     118 #asm("cli")
	cli
;     119 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R9
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
;     120    {
;     121    tx_buffer[tx_wr_index]=c;
	MOV  R26,R7
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer)
	SBCI R27,HIGH(-_tx_buffer)
	LD   R30,Y
	ST   X,R30
;     122    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x12
	CLR  R7
;     123    ++tx_counter;
_0x12:
	INC  R9
;     124    }
;     125 else
	RJMP _0x13
_0xF:
;     126    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
_0x13:
;     127 #asm("sei")
	sei
;     128 }
	ADIW R28,1
	RET
;     129 #pragma used-
;     130 #endif
;     131 
;     132 // Standard Input/Output functions
;     133 #include <stdio.h>  
;     134 #include <delay.h>
;     135 
;     136 // Declare your global variables here
;     137 
;     138 void main(void)
;     139 {
_main:
;     140 // Declare your local variables here
;     141 
;     142 // Input/Output Ports initialization
;     143 // Port A initialization
;     144 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     145 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     146 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     147 DDRA=0x00;
	OUT  0x1A,R30
;     148 
;     149 // Port B initialization
;     150 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     151 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     152 PORTB=0x00;
	OUT  0x18,R30
;     153 DDRB=0x00;
	OUT  0x17,R30
;     154 
;     155 // Port C initialization
;     156 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     157 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     158 PORTC=0x00;
	OUT  0x15,R30
;     159 DDRC=0x00;
	OUT  0x14,R30
;     160 
;     161 // Port D initialization
;     162 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     163 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     164 PORTD=0x00;
	OUT  0x12,R30
;     165 DDRD=0x00;
	OUT  0x11,R30
;     166 
;     167 // Timer/Counter 0 initialization
;     168 // Clock source: System Clock
;     169 // Clock value: Timer 0 Stopped
;     170 // Mode: Normal top=FFh
;     171 // OC0 output: Disconnected
;     172 TCCR0=0x00;
	OUT  0x33,R30
;     173 TCNT0=0x00;
	OUT  0x32,R30
;     174 OCR0=0x00;
	OUT  0x3C,R30
;     175 
;     176 // Timer/Counter 1 initialization
;     177 // Clock source: System Clock
;     178 // Clock value: Timer 1 Stopped
;     179 // Mode: Normal top=FFFFh
;     180 // OC1A output: Discon.
;     181 // OC1B output: Discon.
;     182 // Noise Canceler: Off
;     183 // Input Capture on Falling Edge
;     184 TCCR1A=0x00;
	OUT  0x2F,R30
;     185 TCCR1B=0x00;
	OUT  0x2E,R30
;     186 TCNT1H=0x00;
	OUT  0x2D,R30
;     187 TCNT1L=0x00;
	OUT  0x2C,R30
;     188 ICR1H=0x00;
	OUT  0x27,R30
;     189 ICR1L=0x00;
	OUT  0x26,R30
;     190 OCR1AH=0x00;
	OUT  0x2B,R30
;     191 OCR1AL=0x00;
	OUT  0x2A,R30
;     192 OCR1BH=0x00;
	OUT  0x29,R30
;     193 OCR1BL=0x00;
	OUT  0x28,R30
;     194 
;     195 // Timer/Counter 2 initialization
;     196 // Clock source: System Clock
;     197 // Clock value: Timer 2 Stopped
;     198 // Mode: Normal top=FFh
;     199 // OC2 output: Disconnected
;     200 ASSR=0x00;
	OUT  0x22,R30
;     201 TCCR2=0x00;
	OUT  0x25,R30
;     202 TCNT2=0x00;
	OUT  0x24,R30
;     203 OCR2=0x00;
	OUT  0x23,R30
;     204 
;     205 // External Interrupt(s) initialization
;     206 // INT0: Off
;     207 // INT1: Off
;     208 // INT2: Off
;     209 MCUCR=0x00;
	OUT  0x35,R30
;     210 MCUCSR=0x00;
	OUT  0x34,R30
;     211 
;     212 // Timer(s)/Counter(s) Interrupt(s) initialization
;     213 TIMSK=0x00;
	OUT  0x39,R30
;     214 
;     215 // USART initialization
;     216 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     217 // USART Receiver: On
;     218 // USART Transmitter: On
;     219 // USART Mode: Asynchronous
;     220 // USART Baud rate: 9600
;     221 UCSRA=0x00;
	OUT  0xB,R30
;     222 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     223 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     224 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     225 UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
;     226 
;     227 // Analog Comparator initialization
;     228 // Analog Comparator: Off
;     229 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     230 // Analog Comparator Output: Off
;     231 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     232 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     233 
;     234 // Global enable interrupts
;     235 #asm("sei")
	sei
;     236 
;     237 while (1)
_0x14:
;     238       {
;     239       // Place your code here
;     240       putchar('A');
	LDI  R30,LOW(65)
	ST   -Y,R30
	RCALL _putchar
;     241       delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     242 
;     243       };
	RJMP _0x14
;     244 }
_0x17:
	RJMP _0x17

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

