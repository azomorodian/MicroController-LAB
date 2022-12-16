/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.2c Standard
Automatic Program Generator
� Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.ro
e-mail:office@hpinfotech.ro

Project : 
Version : 
Date    : 3/18/2008
Author  : Artin                           
Company :                                 
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 4.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
#include <stdlib.h>
#include <stdio.h>
#include <delay.h>
#define PS2DIN PINC.0 
#define BUFF_SIZE 64

flash unsigned char unshifted[68][2] = {
	0x0d,9,
	0x0e,'|',
	0x15,'q',
	0x16,'1',
	0x1a,'z',
	0x1b,'s',
	0x1c,'a',
	0x1d,'w',
	0x1e,'2',
	0x21,'c',
	0x22,'x',
	0x23,'d',
	0x24,'e',
	0x25,'4',
	0x26,'3',
	0x29,' ',
	0x2a,'v',
	0x2b,'f',
	0x2c,'t',
	0x2d,'r',
	0x2e,'5',
	0x31,'n',
	0x32,'b',
	0x33,'h',
	0x34,'g',
	0x35,'y',
	0x36,'6',
	0x39,',',
	0x3a,'m',
	0x3b,'j',
	0x3c,'u',
	0x3d,'7',
	0x3e,'8',
	0x41,',',
	0x42,'k',
	0x43,'i',
	0x44,'o',
	0x45,'0',
	0x46,'9',
	0x49,'.',
	0x4a,'-',
	0x4b,'l',
	0x4c,'�',
	0x4d,'p',
	0x4e,'+',
	0x52,'�',
	0x54,'�',
	0x55,'1', 
	0x5a,13,   
	0x5b,'�',
	0x5d,'\\',
	0x61,'<',
	0x66, 8 ,
	0x69,'1',
	0x6b,'4',
	0x6c,'7',
	0x70,'0',
	0x71,',',
	0x72,'2',
	0x73,'5',
	0x74,'6',
	0x75,'8',
	0x79,'+',
	0x7a,'3',
	0x7b,'-',
	0x7c,'*',
	0x7d,'9',
	0,0
	};

// Shifted characters
flash unsigned char shifted[68][2] = {
	0x0d,9,
	0x0e,'�',
	0x15,'Q',
	0x16,'!',
	0x1a,'Z',
	0x1b,'S',
	0x1c,'A',
	0x1d,'W',
	0x1e,'"',
	0x21,'C',
	0x22,'X',
	0x23,'D',
	0x24,'E',
	0x25,'�',
	0x26,'#',
	0x29,' ',
	0x2a,'V',
	0x2b,'F',
	0x2c,'T',
	0x2d,'R',
	0x2e,'%',
	0x31,'N',
	0x32,'B',
	0x33,'H',
	0x34,'G',
	0x35,'Y',
	0x36,'&',
	0x39,'L',
	0x3a,'M',
	0x3b,'J',
	0x3c,'U',
	0x3d,'/',
	0x3e,'(',
	0x41,';',
	0x42,'K',
	0x43,'I',
	0x44,'O',
	0x45,'=',
	0x46,')',
	0x49,':',
	0x4a,'_',
	0x4b,'L',
	0x4c,'�',
	0x4d,'P',
	0x4e,'?',
	0x52,'�',
	0x54,'�',
	0x55,'`',
	0x5a,13,
	0x5b,'^',
	0x5d,'*',
	0x61,'>',
	0x66,8,
	0x69,'1',
	0x6b,'4',
	0x6c,'7',
	0x70,'0',
	0x71,',',
	0x72,'2',
	0x73,'5',
	0x74,'6',
	0x75,'8',
	0x79,'+',
	0x7a,'3',
	0x7b,'-',
	0x7c,'*',
	0x7d,'9',
	0,0
	};

unsigned char edge, bitcount;// 0 = neg. 1 = pos.
unsigned char kb_buffer[BUFF_SIZE];
unsigned char *inpt, *outpt;
unsigned char buffcnt;

void init_kb(void); 
void decode(unsigned char sc);
void put_kbbuff(unsigned char c);
int kb_getchar(void);

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
char a;
char state=0;   
char ScanCode;
char Codes[20];
char Index=0;    


 


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
	static unsigned char data;// Holds the received scan code
	if (!edge) // Routine entered at falling edge
	{
		if(bitcount < 11 && bitcount > 2)// Bit 3 to 10 is data. Parity bit,
			{ // start and stop bits are ignored.
				data = (data >> 1);
				if(PS2DIN)
					data = data | 0x80;// Store a '1'
			}
		MCUCR = 3;// Set interrupt on rising edge
		edge = 1;
	} else { // Routine entered at rising edge
		MCUCR = 2;// Set interrupt on falling edge
		edge = 0;
		if(--bitcount == 0)// All bits received
		{
			decode(data);
			bitcount = 11;
		}
	}
}




// Declare your global variables here

void main(void)
{
// Declare your local variables here
char as[10],i,b;

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
// Analog Comparator Output: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(20);
lcd_clear();
for(i=0;i<20;i++) Codes[i] =0;

	

init_kb();
// Global enable interrupts
#asm("sei")  

while (1)
      {
      // Place your code here  
      b = kb_getchar(); 
      if ((b>32) && (b<128))  lcd_putchar(b);
      };
}

void init_kb(void)
{
	inpt = kb_buffer;// Initialize buffer
	outpt = kb_buffer;
	buffcnt = 0;
	MCUCR = 2; // INT0 interrupt on falling edge
	edge = 0; // 0 = falling edge 1 = rising edge
	bitcount = 11;
}   
void decode(unsigned char sc)
{
static unsigned char is_up=0, shift = 0, mode = 0;
unsigned char i;
if (!is_up)// Last data received was the up-key identifier
{
	switch (sc)
	{
		case 0xF0 :// The up-key identifier
			is_up = 1;
		break;
		case 0x12 :// Left SHIFT
			shift = 1;
		break;
		case 0x59 :// Right SHIFT
			shift = 1;
		break;
		case 0x05 :// F1
			if(mode == 0)
				mode = 1;// Enter scan code mode
			if(mode == 2)
				mode = 3;// Leave scan code mode
		break;
		default:
			if(mode == 0 || mode == 3)// If ASCII mode
			{
				if(!shift)// If shift not pressed,
					{ // do a table look-up
						for(i = 0; unshifted[i][0]!=sc && unshifted[i][0]; i++);
						if (unshifted[i][0] == sc) {
							put_kbbuff(unshifted[i][1]);
						}
					} else {// If shift pressed
						for(i = 0; shifted[i][0]!=sc && shifted[i][0]; i++);
						if (shifted[i][0] == sc) {
							put_kbbuff(shifted[i][1]);
						}
					}
			} else{ // Scan code mode
			       //print_hexbyte(sc);// Print scan code
				//put_kbbuff(' ');
				//put_kbbuff(' ');
			}
		break;
}
} else {
	is_up = 0;// Two 0xF0 in a row not allowed
	switch (sc)
	{
		case 0x12 :// Left SHIFT
			shift = 0;
		break;
		case 0x59 :// Right SHIFT
			shift = 0;
		break;
		case 0x05 :// F1
			if(mode == 1)
				mode = 2;
			if(mode == 3)
				mode = 0;
		break;
		case 0x06 :// F2
			lcd_clear();
		break;
	}
}
}
void put_kbbuff(unsigned char c)
{
	if (buffcnt<BUFF_SIZE)// If buffer not full
	{
		*inpt = c;// Put character into buffer
		inpt++; // Increment pointer
		buffcnt++;
		if (inpt >= kb_buffer + BUFF_SIZE)// Pointer wrapping
		inpt = kb_buffer;
	}
}
int kb_getchar(void)
{
	int byte;
	while(buffcnt == 0);// Wait for data
	byte = *outpt;// Get byte
	outpt++; // Increment pointer
	if (outpt >= kb_buffer + BUFF_SIZE)// Pointer wrapping
		outpt = kb_buffer;
	buffcnt--; // Decrement buffer count
	return byte;
}
