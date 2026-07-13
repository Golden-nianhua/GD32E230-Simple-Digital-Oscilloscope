set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_SYSTEM_PROCESSOR          arm)

set(ARM_GNU_TOOLCHAIN_ROOT "D:/Code/c-env/arm-gnu-toolchain/arm-gnu-toolchain-15.2.rel1-mingw-w64-x86_64-arm-none-eabi"
    CACHE PATH "ARM GNU Toolchain installation directory")
set(MINGW64_ROOT "D:/Code/c-env/mingw64/x86_64-15.2.0-release-posix-seh-ucrt-rt_v13-rev1"
    CACHE PATH "MinGW-w64 runtime installation directory")
set(GD32_FIRMWARE_ROOT "D:/Code/MCU/GD32/GD32E23x_Firmware_Library_V2.5.0"
    CACHE PATH "GD32E23x firmware library directory")

foreach(required_path ARM_GNU_TOOLCHAIN_ROOT MINGW64_ROOT GD32_FIRMWARE_ROOT)
    if(NOT EXISTS "${${required_path}}")
        message(FATAL_ERROR "${required_path} does not exist: ${${required_path}}")
    endif()
endforeach()

set(ENV{PATH} "${ARM_GNU_TOOLCHAIN_ROOT}/bin;${MINGW64_ROOT}/bin;$ENV{PATH}")

set(CMAKE_C_COMPILER "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-gcc.exe")
set(CMAKE_ASM_COMPILER "${CMAKE_C_COMPILER}")
set(CMAKE_CXX_COMPILER "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-g++.exe")
set(CMAKE_OBJCOPY "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-objcopy.exe")
set(CMAKE_SIZE "${ARM_GNU_TOOLCHAIN_ROOT}/bin/arm-none-eabi-size.exe")

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TARGET_FLAGS "-mcpu=cortex-m23 -mthumb")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${TARGET_FLAGS}")
set(CMAKE_ASM_FLAGS "${TARGET_FLAGS} -x assembler-with-cpp -MMD -MP")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fdata-sections -ffunction-sections -fstack-usage")

# Most GCC toolchains do not support cyclomatic-complexity reporting, so it remains disabled.
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcyclomatic-complexity")

set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-Os -g0")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -g0")

set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics")

set(CMAKE_EXE_LINKER_FLAGS "${TARGET_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T \"${CMAKE_SOURCE_DIR}/GD32E230x8_FLASH.ld\"")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nano.specs")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map -Wl,--gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--print-memory-usage")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -u_printf_float")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-warn-rwx-segments")
set(TOOLCHAIN_LINK_LIBRARIES "m")
