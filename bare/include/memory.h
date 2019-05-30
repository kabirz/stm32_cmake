#ifndef _MEMORY_H_
#define _MEMORY_H_
#include <stm32f103xx.h>
#define TIMER1      0x40012C00
#define TIMER2      0x40000000
#define TIMER3      0x40000400
#define TIMER4      0x40000800
#define TIMER5      0x40000C00
#define TIMER6      0x40001000
#define TIMER7      0x40001400
#define TIMER8      0x40013400
#define TIMER9      0x40014C00
#define TIMER10     0x40015000
#define TIMER11     0x40015400
#define TIMER12     0x40001800
#define TIMER13     0x40001C00
#define TIMER14     0x40002000
#define RTC         0x40002800
#define WWDG        0x40002C00
#define IWDG        0x40003000
#define SPI1        0x40013000
#define SPI2        0x40003800
#define SPI3        0x40003C00
#define USART1      0x40013800
#define USART2      0x40004400
#define USART3      0x40004800
#define UART4       0x40004C00
#define UART5       0x40005000
#define I2C1        0x40005400
#define I2C2        0x40005800
#define USB_FS      0x40005C00
#define USB_CAN     0x40006000
#define CAN1        0x40006400
#define CAN2        0x40006800
#define PWR_CTL     0x40007000
#define DAC         0x40007400
#define AFIO        0x40010000
#define EXTI        0x40010400
#define GPIOA       ((GPIO_TypeDef*)0x40010800)
#define GPIOB       ((GPIO_TypeDef*)0x40010C00)
#define GPIOC       ((GPIO_TypeDef*)0x40011000)
#define GPIOD       ((GPIO_TypeDef*)0x40011400)
#define GPIOE       ((GPIO_TypeDef*)0x40011800)
#define GPIOF       ((GPIO_TypeDef*)0x40011C00)
#define GPIOG       ((GPIO_TypeDef*)0x40012000)
#define ADC1        0x40012400
#define ADC2        0x40012800
#define ADC3        0x40013C00
#define SDIO        0x40018000
#define DMA1        0x40020000
#define DMA2        0x40020400
#define RCC         ((RCC_TypeDef*)0x40021000)
#define FLASH       0x40022000
#define CRC         0x40023000
#define ETH         0x40028000
#define USB_OTG     0x50000000
#define FSMC        0xA0000000
#define NULL        (void*)0
#define ARRAY_LENGTH(x) (sizeof(x)/sizeof(x[0]))
#endif // _MEMORY_H_
