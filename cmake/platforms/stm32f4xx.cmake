# SETUP FOR STM32F4xx BOARDS

IF(VERBOSE)
    MESSAGE(INFO "Setting up for STM32F4xx boards")
ENDIF()

# Extract micro model
STRING(REGEX MATCH "stm32f4([0-9]+)" _ ${PLATFORM})
SET(MICRO_MODEL ${CMAKE_MATCH_1})
# Extract number of pins
STRING(REGEX MATCH "stm32f4[0-9]+([a-z])" _ ${PLATFORM})
SET(NUM_PINS ${CMAKE_MATCH_1})
# Extract size of memory
STRING(REGEX MATCH "stm32f4[0-9]+[a-z]([a-z])" _ ${PLATFORM})
SET(MEM_SIZE ${CMAKE_MATCH_1})

IF(VERBOSE)
    # Print the extracted values
    MESSAGE(INFO "    Micro model: ${MICRO_MODEL}")
    MESSAGE(INFO "    Number of pins: ${NUM_PINS}")
    MESSAGE(INFO "    Memory size: ${MEM_SIZE}")
ENDIF()

# Map MICRO_MODEL to the correct platform definition
IF(MICRO_MODEL STREQUAL "01")
    IF(MEM_SIZE STREQUAL "b" OR MEM_SIZE STREQUAL "c")
        SET(PLATFORM_DEFINE "STM32F401xC")
    ELSE()
        SET(PLATFORM_DEFINE "STM32F401xE")
    ENDIF()
ELSEIF(MICRO_MODEL STREQUAL "10")
    IF(NUM_PINS STREQUAL "t")
        SET(PLATFORM_DEFINE "STM32F410Tx")
    ELSEIF(NUM_PINS STREQUAL "c")
        SET(PLATFORM_DEFINE "STM32F410Cx")
    ELSE()
        SET(PLATFORM_DEFINE "STM32F410Rx")
    ENDIF()
ELSEIF(MICRO_MODEL STREQUAL "11")
    SET(PLATFORM_DEFINE "STM32F411xE")
ELSEIF(MICRO_MODEL STREQUAL "12")
    IF(NUM_PINS STREQUAL "c")
        SET(PLATFORM_DEFINE "STM32F412Cx")
    ELSEIF(NUM_PINS STREQUAL "z")
        SET(PLATFORM_DEFINE "STM32F412Zx")
    ELSEIF(NUM_PINS STREQUAL "v")
        SET(PLATFORM_DEFINE "STM32F412Vx")
    ELSE()
        SET(PLATFORM_DEFINE "STM32F412Rx")
    ENDIF()
ELSE()
    SET(PLATFORM_DEFINE "STM32F4${MICRO_MODEL}xx")
ENDIF()

IF(VERBOSE)
    MESSAGE(INFO "    Platform define: ${PLATFORM_DEFINE}")
ENDIF()

# Linker file TODO MAKE IT MORE PORTABLE!!
SET(LINKER_FILE ${MATRIXMCU}/ld/${PLATFORM}.ld)
IF(EXISTS ${LINKER_FILE})
    IF(VERBOSE)
        MESSAGE(INFO "    Linker file: ${LINKER_FILE}")
    ENDIF()
ELSE()
    MESSAGE(FATAL_ERROR "Linker file does not exist for platform ${PLATFORM}")
ENDIF()

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
    MESSAGE(STATUS "** You can adapt and rename a copy of the template in ${MATRIXMCU}/drivers/stm32f4xx/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_conf_template.h **")
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
    -lc
    -lm
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map,--cref
    -Wl,--gc-sections
    -Wl,--print-memory-usage
    -Wl,--no-warn-rwx-segment
)
IF (USE_SEMIHOSTING)
    SET(PLATFORM_LINKER_FLAGS
        ${PLATFORM_LINKER_FLAGS}
        -specs=rdimon.specs
        -lrdimon
    )
ELSE()
    SET(PLATFORM_LINKER_FLAGS
        ${PLATFORM_LINKER_FLAGS}
        -specs=nano.specs
    )
ENDIF()

IF(VERBOSE)
    MESSAGE(INFO "    Platform-specific C flags: ${CMAKE_C_FLAGS}")
    MESSAGE(INFO "    Platform-specific ASM flags: ${CMAKE_ASM_FLAGS}")
    MESSAGE(INFO "    Platform-specific linker flags: ${PLATFORM_LINKER_FLAGS}")
ENDIF()

# Binary file extension
SET(PLATFORM_EXTENSION ".elf")

# Platform-specific source files
SET(PLATFORM_SOURCES ${STM32F4xx_CMSIS_SOURCES})
# Platform-specific HAL source files
IF(USE_HAL)
    SET(PLATFORM_HAL_SOURCES ${STM32F4xx_HAL_SOURCES})
ENDIF()

# Platform-specific directories with header files
SET(PLATFORM_INCLUDE_DIRS ${STM32F4xx_CMSIS_INCLUDE_DIRS})
# Platform-specific HAL header files
IF(USE_HAL)
    SET(PLATFORM_HAL_INCLUDE_DIRS ${STM32F4xx_HAL_INCLUDE_DIRS})
ENDIF()

IF(VERBOSE)
    MESSAGE(INFO "    Platform-specific source files: ${PLATFORM_SOURCES}")
    MESSAGE(INFO "    Platform-specific include directories: ${PLATFORM_INCLUDE_DIRS}")
    IF(USE_HAL)
        MESSAGE(INFO "    Platform-specific HAL source files: ${PLATFORM_HAL_SOURCES}")
        MESSAGE(INFO "    Platform-specific HAL include directories: ${PLATFORM_HAL_INCLUDE_DIRS}")
    ENDIF()
ENDIF()

# OpenOCD support (only if OpenOCD is found)
FIND_PACKAGE(OpenOCD)
IF(OpenOCD_FOUND)
    SET(OPENOCD_CONFIG_FILE ${MATRIXMCU}/openocd/stm32f4x.cfg)
    # TODO: erase hangs. Why?
    ADD_CUSTOM_TARGET(erase 
        COMMAND ${OPENOCD_EXECUTABLE} -f ${OPENOCD_CONFIG_FILE} -c "init; reset init; stm32f4x mass_erase 0; exit"
        COMMENT "Erasing flash memory"
    )
ENDIF()

# QEMU support (only if QEMU is found)
FIND_PACKAGE(QemuSystemArm)
IF(QemuSystemArm_FOUND)
    SET(QEMU_FLAGS
        -cpu cortex-m4
        -machine netduinoplus2
        -nographic
    )
    IF(USE_SEMIHOSTING)
        SET(QEMU_FLAGS
            ${QEMU_FLAGS}
            -semihosting-config enable=on,target=native
        )
    ENDIF()
ENDIF()
