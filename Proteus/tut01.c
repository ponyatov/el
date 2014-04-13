#include <avr/io.h>
#include <util/delay.h>
#define LED PB0
#define PERIOD 300

int main(void) {
  // define pd4 as output
  DDRB |= (1 << LED);
  while (1) {
    PORTB |= (1 << LED);    // switch on
    _delay_ms(PERIOD/2);
    PORTB &= ~(1 << LED);    // switch off
    _delay_ms(PERIOD/2);
  }
return 0;
}

