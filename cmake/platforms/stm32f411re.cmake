# SETUP FOR STM32F411RETx BOARDS

SET(LINKER_FILE ${WORKSPACE_ROOT_DIR}/ld/STM32F4xxxEx.ld)
SET(PLATFORM_DEFINE STM32F411xE)

INCLUDE(${WORKSPACE_ROOT_DIR}/cmake/platforms/stm32f4xx.cmake)