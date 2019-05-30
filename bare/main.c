#include <gpio.h>
#include <delay.h>
#include <system.h>

int main(void)
{
    gpio_output_init(B8);
    while(1) {
        gpio_output_write(B8, 1);
        delay(100);
        gpio_output_write(B8, 0);
        delay(100);
    }
    return 0;
}
