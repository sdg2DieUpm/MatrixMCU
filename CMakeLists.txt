# Path to drivers directory
IF(NOT MATRIXMCU)
    MESSAGE(WARNING "MATRIXMCU not defined. Using default value: ${CMAKE_CURRENT_SOURCE_DIR}")
    SET(MATRIXMCU ${CMAKE_CURRENT_SOURCE_DIR})
ENDIF()

# Add the Modules folder to the search path for FindXXX.cmake files
SET(CMAKE_MODULE_PATH ${MATRIXMCU}/cmake/modules)

# Parse target platform from command line. If not specified, default to native
IF (NOT PLATFORM)
    MESSAGE(WARNING "PLATFORM not defined. Using default value: native")
    SET(PLATFORM "native")
ENDIF()

# Load platform-specific setup configuration
STRING(FIND ${PLATFORM} "stm32f4" PLATFORM_START)
IF(PLATFORM_START EQUAL 0)
    INCLUDE(${MATRIXMCU}/cmake/platforms/stm32f4xx.cmake)
else()
    INCLUDE(${MATRIXMCU}/cmake/platforms/${PLATFORM}.cmake)
endif()

# Pack platform-related code as a library
IF(NOT PLATFORM_SOURCES STREQUAL "")
    ADD_LIBRARY(platform STATIC ${PLATFORM_SOURCES})
    TARGET_INCLUDE_DIRECTORIES(platform PUBLIC ${PLATFORM_INCLUDE_DIRS})
    # Link library to all targets
    LINK_LIBRARIES(platform)
ENDIF()
IF(USE_HAL)
    IF(NOT PLATFORM_HAL_SOURCES STREQUAL "")
        ADD_LIBRARY(hal STATIC ${PLATFORM_HAL_SOURCES})
        TARGET_INCLUDE_DIRECTORIES(hal PUBLIC ${PLATFORM_HAL_INCLUDE_DIRS})
        # Link library to all targets
        LINK_LIBRARIES(hal)
    ENDIF()
ENDIF()

# Add platform-specific linker flags
ADD_LINK_OPTIONS(${PLATFORM_LINKER_FLAGS})

# Add third-party libraries. Note that each library must be added to each target manually
FILE(GLOB libs RELATIVE ${MATRIXMCU}/lib ${MATRIXMCU}/lib/*)
FOREACH(lib ${libs})
    IF(IS_DIRECTORY ${MATRIXMCU}/lib/${lib})
        FILE(GLOB lib_src ${MATRIXMCU}/lib/${lib}/src/**.c)
        ADD_LIBRARY(${lib} STATIC ${lib_src})
        TARGET_INCLUDE_DIRECTORIES(${lib} PUBLIC ${MATRIXMCU}/lib/${lib}/include ${MATRIXMCU}/lib/${lib}/src)
    ENDIF()
ENDFOREACH()
