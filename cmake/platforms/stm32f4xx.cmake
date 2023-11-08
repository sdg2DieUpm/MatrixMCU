# SETUP FOR STM32F446RETx BOARDS

# Toolchain for ARM Cortex-M microcontrollers
SET(CMAKE_TOOLCHAIN_FILE "${WORKSPACE_ROOT_DIR}/cmake/toolchains/arm-none-eabi-gcc.cmake")

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
    SET(OPENOCD_CONFIG_FILE ${WORKSPACE_ROOT_DIR}/openocd/stm32f4x.cfg)
    # TODO: erase hangs. Why?
    # ADD_CUSTOM_TARGET(erase COMMAND ${OPENOCD_EXECUTABLE} -f ${OPENOCD_CONFIG_FILE} -c "init; reset halt; stm32f4x mass_erase 0; exit")
ENDIF()
