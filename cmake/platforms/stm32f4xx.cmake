# SETUP FOR STM32F4xx BOARDS
message("Setting up for STM32F4xx boards")

# Extract micro model
string(REGEX MATCH "stm32f4([0-9]+)" _ ${PLATFORM})
set(MICRO_MODEL ${CMAKE_MATCH_1})

# Extract number of pins
string(REGEX MATCH "stm32f4[0-9]+([a-z])" _ ${PLATFORM})
set(NUM_PINS ${CMAKE_MATCH_1})

# Extract size of memory
string(REGEX MATCH "stm32f4[0-9]+[a-z]([a-z])" _ ${PLATFORM})
set(MEM_SIZE ${CMAKE_MATCH_1})

# Print the extracted values
message("    Micro model: ${MICRO_MODEL}")
message("    Number of pins: ${NUM_PINS}")
message("    Memory size: ${MEM_SIZE}")

# Map MICRO_MODEL to the correct platform definition
if(MICRO_MODEL STREQUAL "01")
    if(MEM_SIZE STREQUAL "b" OR MEM_SIZE STREQUAL "c")
        set(PLATFORM_DEFINE "STM32F401xC")
    else()
        set(PLATFORM_DEFINE "STM32F401xE")
    endif()
elseif(MICRO_MODEL STREQUAL "10")
    if(NUM_PINS STREQUAL "t")
        set(PLATFORM_DEFINE "STM32F410Tx")
    elseif(NUM_PINS STREQUAL "c")
        set(PLATFORM_DEFINE "STM32F410Cx")
    else()
        set(PLATFORM_DEFINE "STM32F410Rx")
    endif()
elseif(MICRO_MODEL STREQUAL "11")
    set(PLATFORM_DEFINE "STM32F411xE")
elseif(MICRO_MODEL STREQUAL "12")
    if(NUM_PINS STREQUAL "c")
        set(PLATFORM_DEFINE "STM32F412Cx")
    elseif(NUM_PINS STREQUAL "z")
        set(PLATFORM_DEFINE "STM32F412Zx")
    elseif(NUM_PINS STREQUAL "v")
        set(PLATFORM_DEFINE "STM32F412Vx")
    else()
        set(PLATFORM_DEFINE "STM32F412Rx")
    endif()
else()
    set(PLATFORM_DEFINE "STM32F4${MICRO_MODEL}xx")
endif()
message("    Platform define: ${PLATFORM_DEFINE}")

# Linker file TODO MAKE IT MORE GENERIC!!
SET(LINKER_FILE ${MATRIXMCU}/ld/STM32F4xxxEx.ld)
MESSAGE("    Linker file: ${LINKER_FILE}")

# Toolchain for ARM Cortex-M microcontrollers
SET(CMAKE_TOOLCHAIN_FILE "${MATRIXMCU}/cmake/toolchains/arm-none-eabi-gcc.cmake")

# STM32 HAL and CMSIS
FIND_PACKAGE("STM32F4xx" REQUIRED)

# Compiler flags
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D${PLATFORM_DEFINE}")
IF(USE_HAL)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSE_HAL_DRIVER")
    # Log a message to remind the user to add the HAL configuration file
    MESSAGE(STATUS "************  THIS CODE USES THE STM32 HAL ************")
    MESSAGE(STATUS "** You need to add stm32f4xx_hal_conf.h to the port/xxx/include folder. **")
    MESSAGE(STATUS "** You can adapt and rename a copy of the template in workspace/drivers/stm32f4xx/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_conf_template.h **")
    MESSAGE(STATUS "*******************************************************")
ENDIF()
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
SET(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# Linker flags
SET(PLATFORM_LINKER_FLAGS
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
    -T${LINKER_FILE}
    -specs=nano.specs
    -lc
    -lm
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map,--cref
    -Wl,--gc-sections
    -Wl,--print-memory-usage
    -Wl,--no-warn-rwx-segment
)

# Binary file extension
SET(PLATFORM_EXTENSION ".elf")

# Platform-specific source files
SET(PLATFORM_SOURCES ${STM32F4xx_CMSIS_SOURCES})
# Platform-specific HAL source files
SET(PLATFORM_HAL_SOURCES ${STM32F4xx_HAL_SOURCES})

# Platform-specific directories with header files
SET(PLATFORM_INCLUDE_DIRS ${STM32F4xx_CMSIS_INCLUDE_DIRS})
# Platform-specific HAL header files
SET(PLATFORM_HAL_INCLUDE_DIRS ${STM32F4xx_HAL_INCLUDE_DIRS})

# OpenOCD support (only if OpenOCD is found)
FIND_PACKAGE(OpenOCD)
IF(OpenOCD_FOUND)
    SET(OPENOCD_CONFIG_FILE ${MATRIXMCU}/openocd/stm32f4x.cfg)
    # TODO: erase hangs. Why?
    # ADD_CUSTOM_TARGET(erase COMMAND ${OPENOCD_EXECUTABLE} -f ${OPENOCD_CONFIG_FILE} -c "init; reset halt; stm32f4x mass_erase 0; exit")
ENDIF()
