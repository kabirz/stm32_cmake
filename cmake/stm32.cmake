get_filename_component(STM32_CMAKE_DIR ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
set(CMAKE_MODULE_PATH ${STM32_CMAKE_DIR} ${CMAKE_MODULE_PATH})
set(STM32_SUPPORTED_FAMILIES F1 F7 H7 CACHE INTERNAL "stm32 supported families")
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CROSS_COMPILER_PREFIX arm-none-eabi)
if (NOT CROSS_COMPILER_PREFIX)
    set(CROSS_COMPILER_PREFIX arm-none-eabi)
    message(STATUS "No TARGET_TRIPLET specified, using default: " ${CROSS_COMPILER_PREFIX})
endif()
add_link_options(--specs=nosys.specs)
if (UNIX)
    set(TOOL_CHAIN_SUFFIX "")
elseif(WIN32)
    set(TOOL_CHAIN_SUFFIX ".exe")
else()
    message(FATAL_ERROR "Only support linux and windows")
endif()
set(CMAKE_C_COMPILER ${CROSS_COMPILER_PREFIX}-gcc${TOOL_CHAIN_SUFFIX})
set(CMAKE_CXX_COMPILER ${CROSS_COMPILER_PREFIX}-g++${TOOL_CHAIN_SUFFIX})
set(CMAKE_ASM_COMPILER ${CROSS_COMPILER_PREFIX}-gcc${TOOL_CHAIN_SUFFIX})
set(CMAKE_CPPFILT ${CROSS_COMPILER_PREFIX}-c++filt${TOOL_CHAIN_SUFFIX})
set(CMAKE_OBJCOPY ${CROSS_COMPILER_PREFIX}-objcopy${TOOL_CHAIN_SUFFIX} CACHE INTERNAL "objcopy tool")
set(CMAKE_OBJDUMP ${CROSS_COMPILER_PREFIX}-objdump${TOOL_CHAIN_SUFFIX} CACHE INTERNAL "objdump tool")
set(CMAKE_SIZE ${CROSS_COMPILER_PREFIX}-size${TOOL_CHAIN_SUFFIX} CACHE INTERNAL "size tool")


set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")

set(CMAKE_C_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "c compiler flags debug")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "cxx compiler flags debug")
set(CMAKE_ASM_FLAGS_DEBUG "-g" CACHE INTERNAL "asm compiler flags debug")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "linker flags debug")

set(CMAKE_C_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "c compiler flags release")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "cxx compiler flags release")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "asm compiler flags release")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto" CACHE INTERNAL "linker flags release")
set(STM32_FAMILY "F1")
if (NOT STM32_FAMILY)
    set(STM32_FAMILY "F1" CACHE INTERNAL "stm32 family")
endif()

list(FIND STM32_SUPPORTED_FAMILIES "${STM32_FAMILY}" FAMILY_INDEX)
if(FAMILY_INDEX EQUAL -1)
    message(FATAL_ERROR "Invalid/unsupported STM32 family: ${STM32_FAMILY}")
endif()
string(TOLOWER ${STM32_FAMILY} STM32_FAMILY_LOWER)
include(stm32${STM32_FAMILY_LOWER})


function(stm32_generate_bin TARGET)
    if (EXECUTABLE_OUTPUT_PATH)
        set(FILENAME "${EXECUTABLE_OUTPUT_PATH}/${TARGET}")
    else()
        set(FILENAME ${TARGET})
    endif()
    add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND ${CMAKE_SIZE} ${FILENAME}${CMAKE_EXECUTABLE_SUFFIX_C})
    add_custom_command(TARGET ${FILENAME} POST_BUILD
                    COMMAND ${CMAKE_OBJCOPY} -Obinary ${FILENAME}${CMAKE_EXECUTABLE_SUFFIX_C} ${FILENAME}.bin
                    COMMENT "Creating binary output ${FILENAME}.bin"
    )
    add_custom_target(dump DEPENDS ${TARGET}
                    COMMAND ${CMAKE_OBJDUMP} -x -D -S -s ${FILENAME}${CMAKE_EXECUTABLE_SUFFIX_C} | ${CMAKE_CPPFILT} > ${FILENAME}.dump
    )
    add_custom_target(bin DEPENDS ${TARGET}
                    COMMAND ${CMAKE_OBJCOPY} -Obinary ${FILENAME}${CMAKE_EXECUTABLE_SUFFIX_C} ${FILENAME}.bin
    )
    add_custom_target(hex DEPENDS ${TARGET}
                    COMMAND ${CMAKE_OBJCOPY} -Oihex ${FILENAME}${CMAKE_EXECUTABLE_SUFFIX_C} ${FILENAME}.hex
                    COMMENT "Creating hex output ${FILENAME}.hex"
    )

    find_program(STM32_ISP stm32isp)
    if (STM32_ISP STREQUAL "STM32_ISP-NOTFOUND")
        find_program(STM32_FLASH stm32flash)
        if (STM32_FLASH STREQUAL "STM32_FLASH-NOTFOUND")
            message(FATAL_ERROR "Can't find a flash tool Please install stm32loader or stm32isp")
        else()
            add_custom_target(upload DEPENDS ${TARGET}
                            COMMAND stm32flash -w ${FILENAME}.bin -v -g 0x0 /dev/ttyUSB0 -b 115200
                            COMMENT "flash image ${FILENAME}.bin to target board"
            )
        endif()
    else()
        add_custom_target(upload DEPENDS ${TARGET}
                        COMMAND stm32isp ${FILENAME}.bin -d /dev/ttyUSB0
                        COMMENT "flash image ${FILENAME}.bin to target board"
        )
    endif()

endfunction()

function(stm32_set_flash_params TARGET)
    if(NOT STM32_LINKER_SCRIPT)
        message(STATUS "No linker script specified, generating default")
        include(stm32_linker)
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${BOARD}.ld ${STM32_LINKER_SCRIPT_TEXT})
    else()
        configure_file(${STM32_LINKER_SCRIPT} ${CMAKE_CURRENT_BINARY_DIR}/${BOARD}.ld)
    endif()

    get_target_property(TARGET_LD_FLAGS ${TARGET} LINK_FLAGS)
    if(TARGET_LD_FLAGS)
        set(TARGET_LD_FLAGS "-T${BOARD}.ld ${TARGET_LD_FLAGS}")
    else()
        set(TARGET_LD_FLAGS -T${BOARD}.ld)
    endif()
    set(TARGET_LD_FLAGS "-Wl,-Map,${TARGET}.map ${TARGET_LD_FLAGS}")
    set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${TARGET_LD_FLAGS})
endfunction()

function(stm32_set_target_properties TARGET)
    stm32_set_flash_params(${TARGET})
    message(STATUS "${STM32_FAMILY} has ${STM32_FLASH_SIZE}iB of flash memory and ${STM32_RAM_SIZE}iB of RAM")
endfunction()

set(outputs
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map
    )
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${outputs}")