cmake_minimum_required(VERSION 3.22)

set(GD32_CMSIS_DIR "${GD32_FIRMWARE_ROOT}/Firmware/CMSIS")
set(GD32_DEVICE_DIR "${GD32_CMSIS_DIR}/GD/GD32E23x")
set(GD32_SPL_DIR "${GD32_FIRMWARE_ROOT}/Firmware/GD32E23x_standard_peripheral")

set(GD32_APPLICATION_SOURCES
    ${CMAKE_SOURCE_DIR}/Core/Src/main.c
    ${CMAKE_SOURCE_DIR}/Core/Src/gd32e23x_it.c
    ${CMAKE_SOURCE_DIR}/Core/Src/systick.c
    ${CMAKE_SOURCE_DIR}/Core/Src/system_gd32e23x.c
    ${CMAKE_SOURCE_DIR}/Core/Src/syscalls.c
    ${CMAKE_SOURCE_DIR}/Core/Src/sysmem.c
    ${CMAKE_SOURCE_DIR}/startup_gd32e23x.S
)

file(GLOB GD32_SPL_SOURCES CONFIGURE_DEPENDS "${GD32_SPL_DIR}/Source/*.c")

add_library(gd32e23x_spl OBJECT ${GD32_SPL_SOURCES})
target_include_directories(gd32e23x_spl PUBLIC
    ${CMAKE_SOURCE_DIR}/Core/Inc
    ${GD32_SPL_DIR}/Include
    ${GD32_DEVICE_DIR}/Include
    ${GD32_CMSIS_DIR}
)
target_compile_definitions(gd32e23x_spl PUBLIC GD32E23x)

target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${GD32_APPLICATION_SOURCES})
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE gd32e23x_spl ${TOOLCHAIN_LINK_LIBRARIES})
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/Core/Inc
    ${GD32_SPL_DIR}/Include
    ${GD32_DEVICE_DIR}/Include
    ${GD32_CMSIS_DIR}
)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE GD32E23x)

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    ADDITIONAL_CLEAN_FILES "${CMAKE_PROJECT_NAME}.map")
