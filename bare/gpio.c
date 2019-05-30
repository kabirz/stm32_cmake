#include <memory.h>
#include <system.h>
#include <gpio.h>


int gpio_output_init(PIN_NUMBER pin_num)
{
    GPIO_TypeDef *gpio = NULL;
    uint32_t base = pin_num >> 8;
    uint32_t pin = pin_num & 0xff;
    if (pin > 16)
        return -1;
    for(int i = 0; i < ARRAY_LENGTH(gpiolist); i++) {
        if (gpiolist[i].base == base) {
            RCC->APB2ENR |= gpiolist[i].bit;
            gpio = gpiolist[i].gpio;
            break;
        }
    }
    if (gpio == NULL)
        return -1;
    if (pin < 8) {
        gpio->CRL &= ~(0xf << (pin * 4));
        gpio->CRL |= 3 << (pin * 4);
    } else {
        gpio->CRH &= ~(0xf << ((pin - 8) * 4));
        gpio->CRH |= 3 << ((pin - 8) * 4);
    }
    return 0;
}

int gpio_output_write(PIN_NUMBER pin_num, uint32_t high)
{
    GPIO_TypeDef *gpio;
    uint32_t base = pin_num >> 8;
    uint32_t pin = pin_num & 0xff;
    if (pin > 16)
        return -1;

    for(int i = 0; i < ARRAY_LENGTH(gpiolist); i++) {
        if (gpiolist[i].base == base) {
            gpio = gpiolist[i].gpio;
            break;
        }
    }
    if (gpio == NULL)
        return -1;

    if (high) {
        gpio->ODR |= BIT(pin);
    } else {
        gpio->ODR &= ~BIT(pin);
    }
    return 0;
}
