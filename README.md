# GD32E230 Simple Digital Oscilloscope

基于 GD32E230C8T6 的简易数字示波器固件。项目从原始 Keil 工程迁移到 CMake + ARM GNU Toolchain，并保留 GD32 SPL 作为外部依赖，方便在 CLion 或命令行下构建、烧录和调试。

项目链接：[立创开源硬件平台](https://oshwhub.com/golden_nianhua/simple-digital-oscilloscope) | [GitHub](https://github.com/Golden-nianhua/GD32E230-Simple-Digital-Oscilloscope)

> `main` 保持原始最终案例的输入方式；波轮开关、PWM 关闭拉低和 ADC 单点毛刺滤波位于 `Oscilloscope-nianhua` 分支。

## 功能

- PA3 单通道 ADC 连续采样，DMA 每次采集 300 个点
- ST7735S 160 x 128 SPI TFT 波形显示
- 输入电压、采样频率、PWM 输出状态的屏幕显示
- PA2 / TIMER14_CH0 PWM 输出
- PA6 / TIMER2_CH0 频率测量输入
- 基于 GD32 SPL 的 CMake / GCC 构建，生成 ELF、HEX、BIN 和 MAP
- Release 使用 `-Os`、LTO、段垃圾回收和 newlib-nano，适配 64 KiB Flash

## 分支

| 分支 | 用途 |
| --- | --- |
| `main` | 原始最终案例迁移后的 GCC 版本，保留 EC11 编码器和原始按键流程。 |
| `Oscilloscope-nianhua` | 实际硬件适配版：PB3 左、PB9 右、PB4 按下，均为内部上拉且按下接地；包含横屏地址偏移、PWM 关闭时 PA2 拉低、ADC 三点中值滤波和电压换算校准。 |

## 硬件连接

| 功能 | GD32E230 引脚 | 说明 |
| --- | --- | --- |
| ADC 输入 | PA3 | 模拟输入，必须保持在 MCU 允许的模拟输入范围内。 |
| PWM 输出 | PA2 | TIMER14_CH0。功能分支关闭 PWM 后会主动拉低该引脚。 |
| 频率测量 | PA6 | TIMER2_CH0。 |
| TFT SCK | PA5 | SPI0 时钟。 |
| TFT MOSI | PA7 | SPI0 数据。 |
| TFT RESET / DC / CS / BL | PB5 / PB6 / PB7 / PB8 | ST7735S 控制信号与背光。 |
| 波轮左 / 右 / 按下 | PB3 / PB9 / PB4 | 仅 `codex/wheel-switch-input`；开关另一侧接地。 |

高频或快速边沿输入若仍有多个连续采样点的异常，应优先检查模拟前端、接地和 ADC 输入带宽。功能分支的软件中值滤波只移除孤立单点毛刺，不应替代输入保护或模拟抗混叠设计。

## 构建环境

- CMake 3.22 或更高版本
- Ninja
- ARM GNU Toolchain，提供 `arm-none-eabi-gcc`
- GD32E23x Firmware Library V2.5.0（包含 CMSIS 与 SPL）

默认 SPL 路径定义在 `cmake/gcc-arm-none-eabi.cmake` 的 `GD32_FIRMWARE_ROOT`。路径不同可在 CMake 配置时覆盖：

```powershell
cmake --preset Release -DGD32_FIRMWARE_ROOT='D:/path/to/GD32E23x_Firmware_Library_V2.5.0'
cmake --build build/Release
```

如 ARM 工具链没有加入 `PATH`，额外指定其安装目录：

```powershell
cmake --preset Release `
  -DARM_GNU_TOOLCHAIN_ROOT='C:/path/to/arm-gnu-toolchain' `
  -DGD32_FIRMWARE_ROOT='D:/path/to/GD32E23x_Firmware_Library_V2.5.0'
cmake --build build/Release
```

调试构建：

```powershell
cmake --preset Debug
cmake --build build/Debug
```

Release 输出位于 `build/Release/`：

- `GD32E230_Oscilloscope.elf`
- `GD32E230_Oscilloscope.hex`
- `GD32E230_Oscilloscope.bin`
- `GD32E230_Oscilloscope.map`

链接脚本 `GD32E230x8_FLASH.ld` 将 Flash 和 RAM 分别限制为 64 KiB 与 8 KiB。请优先烧录 Release；Debug 含调试信息，空间余量明显更小。

## 烧录与调试

`Misc/pyocd.yaml` 使用仓库内的 GD32 DFP Pack，并指定 `gd32e230c8` 目标。接入 CMSIS-DAP 后可执行：

```powershell
uv tool run pyocd load --connect=under-reset --config Misc/pyocd.yaml `
  build/Release/GD32E230_Oscilloscope.elf
```

硬件烧录和模拟前端的最终校准需在实际目标板上完成。

## 目录

| 路径 | 内容 |
| --- | --- |
| `Core/Src`、`Core/Inc` | 示波器应用、外设驱动、中断和头文件。 |
| `cmake` | ARM GCC 工具链与 SPL 显式源文件列表。 |
| `Misc` | GD32 DFP Pack、SVD 和 pyOCD 配置。 |
| `startup_gd32e23x.S`、`GD32E230x8_FLASH.ld` | GCC 启动文件和 GD32E230C8T6 内存布局。 |

GD32 Firmware Library 不提交到本仓库，由 `GD32_FIRMWARE_ROOT` 引用。
