# GD32E230 SPL CLion Template

基于 GD32E23x 标准外设库（SPL）的 CLion + CMake + ARM GCC 模板工程。

默认目标为 `GD32E230C8`（64 KiB Flash、8 KiB RAM），使用 Cortex-M23、内部 IRC8M 和 CMSIS-DAP/pyOCD。`main.c` 当前让 PC13 每 500 ms 翻转一次，便于首次烧录验证。

## 依赖

- CLion（自带 CMake 和 Ninja 可用）
- ARM GNU Toolchain，包含 `arm-none-eabi-gcc`
- MinGW-w64 运行时，供 Windows 版 ARM 工具链使用
- `GD32E23x_Firmware_Library_V2.5.0` 标准库
- `uv` 与 CMSIS-DAP 调试器

标准库不会复制进本仓库。CMake 通过本机路径引用它。

## 配置路径

首次使用前，检查 [cmake/gcc-arm-none-eabi.cmake](cmake/gcc-arm-none-eabi.cmake) 顶部的三个缓存变量：

```cmake
ARM_GNU_TOOLCHAIN_ROOT
MINGW64_ROOT
GD32_FIRMWARE_ROOT
```

将它们改为本机安装路径，或在首次配置时覆盖：

```powershell
cmake --preset Debug `
  "-DARM_GNU_TOOLCHAIN_ROOT=D:/toolchains/arm-gnu-toolchain" `
  "-DMINGW64_ROOT=D:/toolchains/mingw64" `
  "-DGD32_FIRMWARE_ROOT=D:/mcu/GD32E23x_Firmware_Library_V2.5.0"
```

工具链文件会在配置阶段将 ARM GCC 和 MinGW 的 `bin` 目录加入 `PATH`。修改工具链根目录后，删除对应构建目录再重新配置。

## 构建

```powershell
cmake --preset Debug
cmake --build build/Debug

cmake --preset Release
cmake --build build/Release
```

构建产物位于 `build/Debug` 或 `build/Release`：

- `GD32E230_SPL_Template.elf`
- `GD32E230_SPL_Template.hex`
- `GD32E230_SPL_Template.bin`
- `GD32E230_SPL_Template.map`

Debug 使用 `-O0 -g3`，用于单步调试；Release 使用 `-Os`，用于发布。

## CLion

打开工程后执行 **Reload CMake Project**。CMake Profile 使用导入的 `Debug` 或 `Release` preset；日常下载和调试请选择 `Debug`。

工程已提交 `.idea` 配置，包括 `pyOCD 下载` 和 `pyOCD调试` 两个运行配置。换电脑后，更新以下文件中的 `uv.exe` 绝对路径：

- `.idea/runConfigurations/pyOCD.xml`
- `.idea/runConfigurations/pyOCD2.xml`

可在 PowerShell 中用 `Get-Command uv` 查找实际路径。CLion 的运行配置不会稳定地通过 `PATH` 解析裸 `uv` 命令。

在 CLion 的 ARM 工具链中配置可用于 Cortex-M 的 GDB，`pyOCD调试` 会启动本地 GDB Server 并连接 `localhost:65533`。

## 下载与调试

`Misc` 中包含 GD32E23x DFP Pack、从同一 Pack 提取的 SVD，以及 pyOCD 配置。命令行下载示例：

```powershell
uv tool run pyocd load --connect=under-reset --config Misc/pyocd.yaml `
  build/Debug/GD32E230_SPL_Template.elf
```

使用 CLion 时直接运行 `pyOCD 下载` 或启动 `pyOCD调试`。

当前配置固定为 `gd32e230c8`。若实际芯片是 K8、G8、F8 或 E8，修改 [Misc/pyocd.yaml](Misc/pyocd.yaml) 中的 `target_override` 为 Pack 内对应目标名；x8 器件的 Flash/RAM 容量相同，链接脚本无需修改。

## 时钟与平台文件

- [Core/Src/system_gd32e23x.c](Core/Src/system_gd32e23x.c) 默认使用内部 IRC8M。切换 HXTAL 或 PLL 前，按板级时钟硬件启用该文件中的对应配置。
- [GD32E230x8_FLASH.ld](GD32E230x8_FLASH.ld) 定义 64 KiB Flash、8 KiB RAM 和 newlib 堆栈符号。
- [startup_gd32e23x.S](startup_gd32e23x.S) 与链接脚本、中断处理文件构成同一启动约定；更换 MCU 系列时必须一起从目标厂商库重新生成或核对。
