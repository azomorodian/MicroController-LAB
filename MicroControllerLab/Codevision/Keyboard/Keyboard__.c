/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.2c Standard
Automatic Program Generator
� Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.ro
e-mail:office@hpinfotech.ro

Project : 
Version : 
Date    : 3/19/2008
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
#include <stdio.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

// Declare your global variables here

void main(void)
{
// Declare your local variables here
char a[20];       
char Data;
char scan;

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
//1 2 3 4 are rows 5 6 7 are columns
PORTA=0x00;
DDRA=0x0F;

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
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

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

while (1)
      {
      // Place your code here  
      PORTA = 0xFE;  
      delay_ms(10);
      scan = PINA;  
      lcd_gotoxy(0,0);
      sprintf(a,"%2x",scan);
      lcd_puts(a);
      switch (scan)
      {
      	case 0xee:
      		Data = '1';
      		break;
      	case 0xde:         
      		Data = '2';
      		break;
      	case 0xbe:         
      		Data = '3';
      		break;      		
      }
      PORTA = 0xFD;
      delay_ms(10);
      scan = PINA; 
      lcd_gotoxy(10,0);
      sprintf(a,"%2x",scan);
      lcd_puts(a);
      
      switch (scan)
      {
      	case 0xed:
      		Data = '4';
      		break;
      	case 0xdd:         
      		Data = '5';
      		break;
      	case 0xbd:         
      		Data = '6';
      		break;      		
      }
      PORTA = 0xFB;
      delay_ms(10);
      scan = PINA; 
      lcd_gotoxy(0,1);
      sprintf(a,"%2x",scan);
      lcd_puts(a);

      switch (scan)
      {
      	case 0xeb:
      		Data = '7';
      		break;
      	case 0xdb:         
      		Data = '8';
      		break;
      	case 0xbb:         
      		Data = '9';
      		break;      		
      }    
            
      PORTA = 0xF7;
      delay_ms(10);
      scan = PINA;  
      lcd_gotoxy(10,1);
      sprintf(a,"%2x",scan);
      lcd_puts(a);          
      switch (scan)
      {
      	case 0xe7:
      		Data = '*';
      		break;
      	case 0xd7:         
      		Data = '0';
      		break;
      	case 0xb7:         
      		Data = '#';
      		break;      		
      }          
      
      lcd_gotoxy(15,1);
      sprintf(a,"%c",Data);
      lcd_puts(a);      
      

      };
}
