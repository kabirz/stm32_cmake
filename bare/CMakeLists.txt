project(main)

cmake_minimum_required(VERSION 2.8)
enable_language(ASM)
include_directories(include)
aux_source_directory(. SRC)
add_executable(${PROJECT_NAME} startup_stm32f103xb.s ${SRC})
stm32_set_target_properties(${PROJECT_NAME})
stm32_generate_bin(${PROJECT_NAME})