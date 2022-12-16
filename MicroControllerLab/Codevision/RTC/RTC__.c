/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.2c Standard
Automatic Program Generator
© Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <bcd.h>   
#include <stdio.h> 
#include <delay.h>        
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

#define RTC_ADDRESS     0xD0  
struct time {
		unsigned char ti_sec;
		unsigned char ti_min;
		unsigned char ti_hour;
		unsigned char ti_day;
		unsigned char ti_date;
		unsigned char ti_month;
		unsigned char ti_year;
	    };                 
	    

void i2c__start(void);
unsigned char i2c__write(unsigned char Data);
unsigned char RTCRd(unsigned char Address);
void i2c__stop(void);
void gettime(struct time *t);
void settime(struct time t);
unsigned char RTCRd(unsigned char Address); 
void stop_clock(); 
void start_clock();         


// Declare your global variables here

void main(void)
{
// Declare your local variables here 
char a[20];
struct time t,t1;  
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

// TWO WIRW BUS
TWSR=0x00;
TWBR=0x20;
TWCR=0x04;

// LCD module initialization
lcd_init(20);
t.ti_sec = 5;      	
t.ti_min=34;
t.ti_hour = 13;
t.ti_day = 5;
t.ti_date = 19;
t.ti_month = 3;
t.ti_year=2008;
settime(t); 
start_clock();
while (1)
      {   
      lcd_clear();      
      gettime(&t1); 
      sprintf(a,"Time = %2d:%2d:%2d",t1.ti_hour,t1.ti_min,t1.ti_sec);     
      //sprintf(a,"Time =");     
      lcd_gotoxy(1,1);
      lcd_puts(a);  
      delay_ms(1000);	     
      // Place your code here

      };
}  
void i2c__start(void)
{
unsigned char temp;
do 
  {
  TWCR=0xA4;
  while(!(TWCR&0x80));
  temp=TWSR & 0xF8;
  } while ((temp!=0x08) && (temp!=0x10));
}  
unsigned char i2c__write(unsigned char Data)
{                                          
unsigned char temp;
TWDR=Data;
TWCR=0x84;
while(!(TWCR&0x80));
temp=TWSR & 0xF8;
return(temp);
}          

unsigned char i2c__read(unsigned char ack,unsigned char *status)
{
unsigned char temp;
TWCR=0x84 | (ack<<7);
while(!(TWCR&0x80));
temp=TWSR & 0xF8;
*status=temp;
return(TWDR);
}

void i2c__stop(void)
{
TWCR=0x94;
}


unsigned char RTCRd(unsigned char Address)
{
unsigned char data,temp;
i2c__start();
i2c__write(RTC_ADDRESS);
i2c__write(Address);
i2c__start();
i2c__write(RTC_ADDRESS | 1);
data=i2c__read(0,&temp);
i2c__stop();
return data;
} 

void gettime(struct time *t)
{
unsigned char temp;
temp=RTCRd(0x00);
t->ti_sec = (temp&0x0F)+(temp>>4)*10;

temp=RTCRd(0x01);
t->ti_min = (temp&0x0F)+(temp>>4)*10;

temp=RTCRd(0x02);
t->ti_hour = (temp&0x0F) + ((temp>>4)&0x03)*10;  

temp=RTCRd(0x03);                              
t->ti_day = temp;                              

temp=RTCRd(0x04);                              
t->ti_date = (temp&0x0F)+((temp>>4)&0x03)*10;  
  
temp=RTCRd(0x05);                              
t->ti_month = (temp&0x0F)+((temp>>4)&0x01)*10;  

temp=RTCRd(0x06);                              
t->ti_year = (temp&0x0F)+((temp>>4)&0x0F)*10;  

}   

void RTCWr(unsigned char Address ,unsigned char Data)
{
i2c__start();
i2c__write(RTC_ADDRESS);
i2c__write(Address);
i2c__write(Data);
i2c__stop();
}                                                                                
void settime(struct time t)
{                  
unsigned char temp;
temp=RTCRd(0x00);
RTCWr(0x0,(bin2bcd(t.ti_sec)|(temp&0x80)));

RTCWr(0x01,bin2bcd(t.ti_min));

temp=RTCRd(0x00);
RTCWr(0x02,(bin2bcd(t.ti_hour)|(temp&0xC0)));

RTCWr(0x03,bin2bcd(t.ti_day));

RTCWr(0x04,bin2bcd(t.ti_date));

RTCWr(0x05,bin2bcd(t.ti_month));

RTCWr(0x06,bin2bcd(t.ti_year));
}   
void stop_clock()
{
unsigned char temp;
temp=RTCRd(0x00); 
RTCWr(0x0,temp|0x80);
}

void start_clock()
{                
unsigned char temp;
temp=RTCRd(0x00);    
RTCWr(0x0,temp&0x7F);
}                            

        
