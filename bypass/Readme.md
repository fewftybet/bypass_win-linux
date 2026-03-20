# 项目说明

本项目包含一组二进制处理与演示用组件，包含自动化脚本、XOR 编码工具以及示例代码。为避免被误用，本文档只做结构与约定说明，不提供具体的操作步骤或可执行的使用指引。若需要实验性使用，请在合规与授权范围内开展，并在内部文档中维护详细操作流程。

## 目录结构

- `EXEToshellcode/`
- `EXEToshellcode/EXEToShellcode.exe`
  - 外部转换工具（第三方可执行文件）。
- `xor/`
- `xor/xor.py`
  - 简单的 XOR 编码/解码工具脚本。
- `一键转Shellcode工具.bat`
  - Windows 下的批处理封装脚本，用于串联转换与 XOR 编码流程，并将结果写入 `out/` 目录。
- `loader_win.cpp`
  - Windows 示例代码（演示性质）。
- `loader_win32.exe`
  - 预编译的 Windows 32 位示例可执行文件。
- `output.bin`
  - 示例输出文件（仅用于本地测试与验证）。
- `out/`
  - 输出目录（脚本运行时自动创建，不一定提交到仓库）。

## 约定说明

- 输出目录统一为 `out/`。
- `一键转Shellcode工具.bat` 会在缺失时自动创建 `out/` 目录。
- XOR 编码脚本依赖 Python 3 运行环境。

## 通用 C++ 编译说明（非特定用途）

#### 编译 Win32
i686-w64-mingw32-g++ loader_win.cpp -o loader_win32.exe -static
#### 编译 Win64
x86_64-w64-mingw32-g++ loader_win.cpp -o loader_win64.exe -static

## 注意
#### 32位的程序用32位的加载器
eg: 将程序转为shellcodexxx_32.exe->exe2shellcode
	编译加载器loader_win.cpp->loader_win32.exe

## 安全与合规

- 本项目仅用于合法授权的安全研究、教学或测试环境。
- 禁止在未授权环境中使用或传播相关组件。
- 若需实际操作步骤，请在内部合规文档中维护，避免公共渠道传播。

