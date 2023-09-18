# Path to drivers directory
IF(NOT WORKSPACE_ROOT_DIR)
    MESSAGE(WARNING "WORKSPACE_ROOT_DIR not defined. Using default value: ${CMAKE_CURRENT_SOURCE_DIR}")
    SET(WORKSPACE_ROOT_DIR  ${CMAKE_CURRENT_SOURCE_DIR})
ENDIF()

# Add the Modules folder to the search path for FindXXX.cmake files
SET(CMAKE_MODULE_PATH ${WORKSPACE_ROOT_DIR}/cmake/modules)

# Parse target platform from command line. If not specified, default to native
IF (NOT PLATFORM)
    MESSAGE(WARNING "PLATFORM not defined. Using default value: native")
    SET(PLATFORM "native")
ENDIF()

# Load platform-specific setup configuration
INCLUDE(${WORKSPACE_ROOT_DIR}/cmake/platforms/${PLATFORM}.cmake)

# Pack platform-related code as a library
IF(NOT PLATFORM_SOURCES STREQUAL "")
    ADD_LIBRARY(platform STATIC ${PLATFORM_SOURCES})
    TARGET_INCLUDE_DIRECTORIES(platform PUBLIC ${PLATFORM_INCLUDE_DIRS})
    # Link library to all targets
    LINK_LIBRARIES(platform)
ENDIF()

# Add platform-specific linker flags
ADD_LINK_OPTIONS(${PLATFORM_LINKER_FLAGS})

# Add third-party libraries. Note that each library must be added to each target manually
FILE(GLOB libs RELATIVE ${WORKSPACE_ROOT_DIR}/lib ${WORKSPACE_ROOT_DIR}/lib/*)
FOREACH(lib ${libs})
    IF(IS_DIRECTORY ${WORKSPACE_ROOT_DIR}/lib/${lib})
        FILE(GLOB lib_src ${WORKSPACE_ROOT_DIR}/lib/${lib}/src/**.c)
        ADD_LIBRARY(${lib} STATIC ${lib_src})
        TARGET_INCLUDE_DIRECTORIES(${lib} PUBLIC ${WORKSPACE_ROOT_DIR}/lib/${lib}/include ${WORKSPACE_ROOT_DIR}/lib/${lib}/src)
    ENDIF()
ENDFOREACH()
