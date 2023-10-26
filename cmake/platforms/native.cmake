# SETUP FOR NATIVE COMPILATION. NO SPECIAL TOOLCHAIN FILE IS REQUIRED

# File extension
IF(WIN32)
    SET(PLATFORM_EXTENSION ".exe")
ENDIF()
# Platform-specific source files
SET(PLATFORM_SOURCES "")
# Platform-specific HAL source files
SET(PLATFORM_HAL_SOURCES "")
# Platform-specific directories with header files
SET(PLATFORM_INCLUDE_DIRS "")
# Platform-specific HAL directories with header files
SET(PLATFORM_HAL_INCLUDE_DIRS "")
# Linker flags
SET(PLATFORM_LINKER_FLAGS "")
