cmake_minimum_required(VERSION 3.22)

set(GD32_CMSIS_DIR "${CMAKE_SOURCE_DIR}/Oscilloscope/Firmware/CMSIS")
set(GD32_DEVICE_DIR "${GD32_CMSIS_DIR}/GD/GD32E23x")
set(GD32_SPL_DIR "${CMAKE_SOURCE_DIR}/Oscilloscope/Firmware/GD32E23x_standard_peripheral")

set(GD32_APPLICATION_SOURCES
    ${CMAKE_SOURCE_DIR}/Oscilloscope/User/main.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/User/gd32e23x_it.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/User/systick.c
    ${GD32_DEVICE_DIR}/Source/system_gd32e23x.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/ADC/adc.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/FREQ/freq.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/KEY/key.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/LED/led.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TFT/tft.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TFT/tft_init.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TIMER/timer.c
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/USART/usart.c
    ${CMAKE_SOURCE_DIR}/Core/Src/syscalls.c
    ${CMAKE_SOURCE_DIR}/startup_gd32e23x.S
)

set(GD32_SPL_SOURCES
    ${GD32_SPL_DIR}/Source/gd32e23x_adc.c
    ${GD32_SPL_DIR}/Source/gd32e23x_dma.c
    ${GD32_SPL_DIR}/Source/gd32e23x_exti.c
    ${GD32_SPL_DIR}/Source/gd32e23x_gpio.c
    ${GD32_SPL_DIR}/Source/gd32e23x_misc.c
    ${GD32_SPL_DIR}/Source/gd32e23x_rcu.c
    ${GD32_SPL_DIR}/Source/gd32e23x_spi.c
    ${GD32_SPL_DIR}/Source/gd32e23x_syscfg.c
    ${GD32_SPL_DIR}/Source/gd32e23x_timer.c
    ${GD32_SPL_DIR}/Source/gd32e23x_usart.c
)

add_library(gd32e23x_spl OBJECT ${GD32_SPL_SOURCES})
target_include_directories(gd32e23x_spl PUBLIC
    ${CMAKE_SOURCE_DIR}/Oscilloscope/User
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/ADC
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/FREQ
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/KEY
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/LED
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TFT
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TIMER
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/USART
    ${GD32_SPL_DIR}/Include
    ${GD32_DEVICE_DIR}/Include
    ${GD32_CMSIS_DIR}
)
target_compile_definitions(gd32e23x_spl PUBLIC GD32E230)

target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${GD32_APPLICATION_SOURCES})
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE gd32e23x_spl ${TOOLCHAIN_LINK_LIBRARIES})
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/Oscilloscope/User
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/ADC
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/FREQ
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/KEY
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/LED
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TFT
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/TIMER
    ${CMAKE_SOURCE_DIR}/Oscilloscope/Hardware/USART
    ${GD32_SPL_DIR}/Include
    ${GD32_DEVICE_DIR}/Include
    ${GD32_CMSIS_DIR}
)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE GD32E230)

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    ADDITIONAL_CLEAN_FILES "${CMAKE_PROJECT_NAME}.map")
