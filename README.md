# GD32E230 Simple Digital Oscilloscope

GD32E230C8T6 simple digital oscilloscope firmware, built with CMake and ARM
GNU Toolchain. The application has been migrated into the template's `Core/`
layout and builds directly from that source tree. It uses the template's
externally configured GD32 firmware library rather than copying it into this
repository.

## Target

- MCU: GD32E230C8T6, Cortex-M23
- Memory: 64 KiB Flash, 8 KiB RAM
- Clock: 8 MHz HXTAL with PLL at 72 MHz, matching the original Keil project
- Debug/download: CMSIS-DAP with pyOCD

The GCC build uses only the SPL drivers required by the application, `-Os`,
LTO, section garbage collection, and newlib-nano. Floating-point `sprintf` is
kept because it is used by the on-screen voltage, frequency, and duty-cycle
readouts.

## Build

Install an ARM GNU Toolchain that provides `arm-none-eabi-gcc`, CMake, and
Ninja. Put the toolchain `bin` directory on `PATH`, or set
`ARM_GNU_TOOLCHAIN_ROOT` to the toolchain installation directory. Set
`GD32_FIRMWARE_ROOT` to the installed GD32E23x firmware library when its path
differs from the template configuration.

```powershell
cmake --preset Release
cmake --build build/Release
```

For a debug build:

```powershell
cmake --preset Debug
cmake --build build/Debug
```

The release artifacts are written to `build/Release/`:

- `GD32E230_Oscilloscope.elf`
- `GD32E230_Oscilloscope.hex`
- `GD32E230_Oscilloscope.bin`
- `GD32E230_Oscilloscope.map`

The linker script enforces the GD32E230C8T6 64 KiB Flash and 8 KiB RAM limits.
The current Release build uses 37,160 B Flash and 4,216 B RAM.

## Download and Debug

`Misc/pyocd.yaml` selects the `gd32e230c8` target from the included GD32 DFP
Pack. Example download command:

```powershell
uv tool run pyocd load --connect=under-reset --config Misc/pyocd.yaml `
  build/Release/GD32E230_Oscilloscope.elf
```

Hardware download/debug has not been tested as part of the GCC migration.

## Layout

- `Core/Src`, `Core/Inc`: application, peripheral drivers, interrupts, and headers
- External GD32 firmware library: GD32 SPL and CMSIS headers, via `GD32_FIRMWARE_ROOT`
- `cmake`: ARM GCC toolchain and explicit source list
- `Misc`: GD32 device pack, SVD, and pyOCD configuration

Keil build outputs and user-specific project files are ignored by Git.
