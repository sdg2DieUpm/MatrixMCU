# Path to drivers directory
IF(NOT DEFINED MATRIXMCU)
    SET(MATRIXMCU ${CMAKE_CURRENT_SOURCE_DIR})
    MESSAGE(STATUS "No path to MatrixMCU directory selected, using default (${MATRIXMCU}). You can override it by passing -DMATRIXMCU=<MATRIXMCU> to cmake")
ENDIF()
# Parse target platform from command line. If not specified, raise error
IF(NOT DEFINED PLATFORM)
    MESSAGE(FATAL_ERROR "No platform selected. You can provide one by passing -DPLATFORM=<platform> to cmake")
ENDIF()

# Add the Modules folder to the search path for FindXXX.cmake files
SET(CMAKE_MODULE_PATH ${MATRIXMCU}/cmake/modules)

# Load platform-specific setup configuration
STRING(FIND ${PLATFORM} "stm32f4" PLATFORM_START)
IF(PLATFORM_START EQUAL 0)
    INCLUDE(${MATRIXMCU}/cmake/platforms/stm32f4xx.cmake)
else()
    INCLUDE(${MATRIXMCU}/cmake/platforms/${PLATFORM}.cmake)
endif()

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
