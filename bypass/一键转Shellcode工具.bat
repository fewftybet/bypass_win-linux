@echo off
chcp 65001 > nul
cls
title EXE转Shellcode工具 - 修正版

:: 设置默认密钥
set DEFAULT_KEY=170

:: 获取当前脚本目录
set "script_dir=%~dp0"
set "tool_dir=%script_dir%EXEToshellcode\"
set "xor_dir=%script_dir%xor\"
set "out_dir=%script_dir%out\"

:: 如果out目录不存在则创建
if not exist "%out_dir%" (
    mkdir "%out_dir%"
)

:: 确保工具目录存在
if not exist "%tool_dir%" (
    echo 错误: EXEToshellcode目录不存在
    pause
    exit /b 1
)

if not exist "%xor_dir%" (
    echo 错误: xor目录不存在
    pause
    exit /b 1
)

:: 提示用户输入EXE文件路径
:input_exe
echo 请将EXE文件拖放到此窗口中，或手动输入文件路径：
set /p "exe_file=EXE文件路径: "

:: 移除路径中的引号
set "exe_file=%exe_file:"=%"

:: 检查文件是否存在
if not exist "%exe_file%" (
    echo 错误: 文件不存在 - "%exe_file%"
    goto input_exe
)

:: 获取文件名
for %%F in ("%exe_file%") do (
    set "filename=%%~nF"
    set "file_ext=%%~xF"
)

:: 检查是否是EXE文件
if /i not "%file_ext%"==".exe" (
    echo 错误: 请选择.exe文件
    goto input_exe
)

:: 输入密钥
echo 请输入加密密钥（默认 %DEFAULT_KEY%）：
set /p "encrypt_key=密钥: "
if "%encrypt_key%"=="" set "encrypt_key=%DEFAULT_KEY%"

:: 第一步：转换
echo [1/2] 正在将EXE转换为Shellcode...
"%tool_dir%EXEToShellcode.exe" -e "%exe_file%" -o "%tool_dir%%filename%.bin" || (
    echo 错误: EXE转换失败
    pause
    exit /b 1
)

:: 第二步：加密
echo [2/2] 正在加密Shellcode文件...
python "%xor_dir%xor.py" "%tool_dir%%filename%.bin" "%out_dir%%filename%.bin" "%encrypt_key%" || (
    echo 错误: 加密过程失败
    pause
    exit /b 1
)

:: 删除临时文件
if exist "%tool_dir%%filename%.bin" (
    del "%tool_dir%%filename%.bin"
)

:: 完成提示
echo.
echo ========================================
echo 操作成功完成!
echo.
echo 原始EXE文件: %exe_file%
echo 生成输出文件: %out_dir%%filename%.bin
echo 使用的XOR密钥: %encrypt_key%
echo.
echo 输出目录: %out_dir%
echo ========================================
echo.
pause