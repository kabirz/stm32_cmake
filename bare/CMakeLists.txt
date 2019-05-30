project(main)

cmake_minimum_required(VERSION 2.8)
enable_language(ASM)
include_directories(include)
set(SRC main.c startup_stm32f103xb.s system.c gpio.c delay.c)

add_executable(${PROJECT_NAME} ${SRC})
stm32_set_target_properties(${PROJECT_NAME})
stm32_generate_bin(${PROJECT_NAME})