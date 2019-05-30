set(CMAKE_C_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m3 -Wall -std=gnu99 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "c compiler flags")
set(CMAKE_ASM_FLAGS "-mthumb -mcpu=cortex-m3 -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")

set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -mthumb -mcpu=cortex-m3 -mabi=aapcs" CACHE INTERNAL "executable linker flags")
set(CMAKE_MODULE_LINKER_FLAGS "-mthumb -mcpu=cortex-m3 -mabi=aapcs" CACHE INTERNAL "module linker flags")

set(STM32_RAM_ORIGIN "0x20000000" CACHE INTERNAL "ram origin location")
set(STM32_RAM_SIZE "20K" CACHE INTERNAL "ram size")
set(STM32_FLASH_ORIGIN "0x08000000" CACHE INTERNAL "flash origin location")
set(STM32_FLASH_SIZE "64K" CACHE INTERNAL "flash size")
set(STM32_MIN_HEAP_SIZE "0x100" CACHE INTERNAL "min heap size")
set(STM32_MIN_STACK_SIZE "0x400" CACHE INTERNAL "min stack size")
set(BOARD "stm32f103c8t6" CACHE INTERNAL "stm32 board name")