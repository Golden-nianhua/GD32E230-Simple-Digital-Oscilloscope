set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_SYSTEM_PROCESSOR          arm)

set(ARM_GNU_TOOLCHAIN_ROOT "" CACHE PATH "ARM GNU Toolchain installation directory (optional when arm-none-eabi-gcc is on PATH)")
set(GD32_FIRMWARE_ROOT "D:/Code/MCU/GD32/GD32E23x_Firmware_Library_V2.5.0"
    CACHE PATH "GD32E23x firmware library directory")

if(NOT EXISTS "${GD32_FIRMWARE_ROOT}")
    message(FATAL_ERROR "GD32_FIRMWARE_ROOT does not exist: ${GD32_FIRMWARE_ROOT}")
endif()

if(ARM_GNU_TOOLCHAIN_ROOT)
    set(ARM_GCC_EXECUTABLE "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-gcc.exe")
    set(ARM_GXX_EXECUTABLE "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-g++.exe")
    set(ARM_OBJCOPY_EXECUTABLE "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-objcopy.exe")
    set(ARM_SIZE_EXECUTABLE "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-size.exe")
else()
    find_program(ARM_GCC_EXECUTABLE arm-none-eabi-gcc REQUIRED)
    find_program(ARM_GXX_EXECUTABLE arm-none-eabi-g++ REQUIRED)
    find_program(ARM_OBJCOPY_EXECUTABLE arm-none-eabi-objcopy REQUIRED)
    find_program(ARM_SIZE_EXECUTABLE arm-none-eabi-size REQUIRED)
endif()

foreach(required_executable ARM_GCC_EXECUTABLE ARM_GXX_EXECUTABLE ARM_OBJCOPY_EXECUTABLE ARM_SIZE_EXECUTABLE)
    if(NOT EXISTS "${${required_executable}}")
        message(FATAL_ERROR "${required_executable} does not exist: ${${required_executable}}")
    endif()
endforeach()

set(CMAKE_C_COMPILER "${ARM_GCC_EXECUTABLE}")
set(CMAKE_ASM_COMPILER "${CMAKE_C_COMPILER}")
set(CMAKE_CXX_COMPILER "${ARM_GXX_EXECUTABLE}")
set(CMAKE_OBJCOPY "${ARM_OBJCOPY_EXECUTABLE}")
set(CMAKE_SIZE "${ARM_SIZE_EXECUTABLE}")

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TARGET_FLAGS "-mcpu=cortex-m23 -mthumb")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${TARGET_FLAGS}")
set(CMAKE_ASM_FLAGS "${TARGET_FLAGS} -x assembler-with-cpp -MMD -MP")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fdata-sections -ffunction-sections -fstack-usage -flto")

# Most GCC toolchains do not support cyclomatic-complexity reporting, so it remains disabled.
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcyclomatic-complexity")

set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-Os -g0")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -g0")

set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics")

set(CMAKE_EXE_LINKER_FLAGS "${TARGET_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T \"${CMAKE_SOURCE_DIR}/GD32E230x8_FLASH.ld\"")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nano.specs --specs=nosys.specs -flto")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map -Wl,--gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--print-memory-usage")
# The oscilloscope UI formats voltage, frequency, and duty-cycle values as floats.
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -u_printf_float")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-warn-rwx-segments")
set(TOOLCHAIN_LINK_LIBRARIES "m")
