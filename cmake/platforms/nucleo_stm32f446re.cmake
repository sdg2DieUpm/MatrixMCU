# SETUP FOR STM32F446RETx BOARDS

# Toolchain for ARM Cortex-M microcontrollers
SET(CMAKE_TOOLCHAIN_FILE "${WORKSPACE_ROOT_DIR}/cmake/toolchains/arm-none-eabi-gcc.cmake")

# STM32 HAL and CMSIS
FIND_PACKAGE("STM32F4xx" REQUIRED)

# Compiler flags
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -DUSE_HAL_DRIVER -DSTM32F446xx -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
SET(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# Linker flags
SET(PLATFORM_LINKER_FLAGS
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard
    -T${WORKSPACE_ROOT_DIR}/ld/STM32F446RETx.ld
    -specs=nano.specs
    -lc
    -lm
    -lnosys 
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map,--cref
    -Wl,--gc-sections
    -Wl,--print-memory-usage
)

# Binary file extension
SET(PLATFORM_EXTENSION ".elf")

# Platform-specific source files
SET(PLATFORM_SOURCES ${STM32F4xx_SOURCES})

# Platform-specific directories with header files
SET(PLATFORM_INCLUDE_DIRS ${STM32F4xx_INCLUDE_DIRS})

# OpenOCD support (only if OpenOCD is found)
FIND_PACKAGE(OpenOCD)
IF(OpenOCD_FOUND)
    SET(OPENOCD_CONFIG_FILE ${WORKSPACE_ROOT_DIR}/openocd/stm32f4x.cfg)
    # TODO: erase hangs. Why?
    # ADD_CUSTOM_TARGET(erase COMMAND ${OPENOCD_EXECUTABLE} -f ${OPENOCD_CONFIG_FILE} -c "init; reset halt; stm32f4x mass_erase 0; exit")
ENDIF()
