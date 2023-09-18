# SETUP FOR NATIVE COMPILATION. NO SPECIAL TOOLCHAIN FILE IS REQUIRED

# File extension
IF(WIN32)
    SET(PLATFORM_EXTENSION ".exe")
ENDIF()
# Platform-specific source files
SET(PLATFORM_SOURCES "")
# Platform-specific directories with header files
SET(PLATFORM_INCLUDE_DIRS "")
# Linker flags
SET(PLATFORM_LINKER_FLAGS "")
